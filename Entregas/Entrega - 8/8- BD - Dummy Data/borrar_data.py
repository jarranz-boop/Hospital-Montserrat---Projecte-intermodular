import random
import os
from datetime import timedelta, date
from faker import Faker
from dotenv import load_dotenv
import psycopg2
from psycopg2 import OperationalError

def connect_db():
    """Prova de connectar al srvprimary i si no al srvstandby."""
    hosts = ["srvprimary", "srvstandby"]
    
    for host in hosts:
        print(f"Intentant connectar a {host}...")
        try:
            conn = psycopg2.connect(
                dbname="Montserrat",
                user="postgres",
                password="anas",
                host=host,
                port="5432",
                connect_timeout=3
            )
            print(f"Connexió establerta amb {host}")
            return conn
        except OperationalError as e:
            print(f"Error amb {host}: {e}")
            
    return None

def generar_dades_completes():
    load_dotenv()

    # 1. Connexió a la base de dades (Usant la funció de dalt)
    conn = connect_db()
    if not conn:
        print("No s'ha pogut connectar a cap node PostgreSQL.")
        return
    cur = conn.cursor()

    # 2. Configuració d'idiomes (Anex 9)
    fake_es = Faker('es_ES')
    fake_ru = Faker('ru_RU')
    fake_ja = Faker('ja_JP')
    fake_zh = Faker('zh_CN')

    locales = [fake_es, fake_ru, fake_ja, fake_zh]
    # 4 idiomes = 4 pesos (85% espanyol, 5% rus, 5% japonès, 5% xinès)
    pesos = [85, 5, 5, 5]

    # 3. Infraestructura
    plantes_ids = []
    for i in range(1, 6):
        cur.execute("INSERT INTO PLANTES (nom_planta) VALUES (%s) RETURNING id_planta", (f"Planta {i}",))
        plantes_ids.append(cur.fetchone()[0])

    hab_ids = []
    quiro_ids = []
    for p_id in plantes_ids:
        for _ in range(20): # Habitacions
            cur.execute("INSERT INTO HABITACIONS (id_planta) VALUES (%s) RETURNING id_habitacio", (p_id,))
            hab_ids.append(cur.fetchone()[0])
        for i in range(1, 4): # Quiròfans
            cur.execute("INSERT INTO QUIROFANS (nom_quirofan, id_planta) VALUES (%s, %s) RETURNING id_quirofan",
                        (f"Q-{p_id}-{i}", p_id))
            quiro_ids.append(cur.fetchone()[0])

    # 4. Personal (Superclase/Subclase)
    metges_ids = []
    personal_total_ids = []

    def crear_personal(cantidad, tipo):
        for _ in range(cantidad):
            f = random.choices(locales, weights=pesos)[0]
            dni = fake_es.unique.bothify(text='########?')
            cur.execute("""INSERT INTO PERSONAL (DNI, nom, cognom, data_naixement, datade_contratacio)
                           VALUES (%s, %s, %s, %s, %s) RETURNING id_personal""",
                        (dni, f.first_name().title(), f.last_name().title(),
                         fake_es.date_of_birth(minimum_age=25, maximum_age=65), date.today()))
            p_id = cur.fetchone()[0]
            personal_total_ids.append(p_id)

            if tipo == 'MEDIC':
                cur.execute("INSERT INTO PERSONAL_MEDIC (id_metge, especialitat, estudis) VALUES (%s, %s, %s)",
                            (p_id, 'Especialista', 'Doctorat en Medicina'))
                metges_ids.append(p_id)
            elif tipo == 'INFERMERA':
                cur.execute("INSERT INTO INFERMERIA (id_infermer, id_metge, id_planta) VALUES (%s, %s, %s)",
                            (p_id, random.choice(metges_ids), random.choice(plantes_ids)))
            elif tipo == 'VARI':
                t_vari = 'Neteja' if _ < 100 else 'Administració'
                cur.execute("INSERT INTO PERSONAL_VARI (id_empleat, tipus) VALUES (%s, %s)", (p_id, t_vari))

    crear_personal(100, 'MEDIC')
    crear_personal(200, 'INFERMERA')
    crear_personal(150, 'VARI')

    # 5. Pacients (50.000)
    pacients_data = []
    for _ in range(50000):
        f = random.choices(locales, weights=pesos)[0]
        pacients_data.append((
            fake_es.unique.bothify(text='########?'), f.first_name().title(),
            f.last_name().title(), fake_es.phone_number()[:15], fake_es.date_of_birth()
        ))
    cur.executemany("INSERT INTO PACIENT (DNI, nom, cognom, telefon, data_naixement) VALUES (%s,%s,%s,%s,%s)", pacients_data)

    cur.execute("SELECT id_pacient FROM PACIENT")
    pac_ids = [r[0] for r in cur.fetchall()]

    # 6. Medicaments
    cur.executemany("INSERT INTO MEDICAMENT (nom, format) VALUES (%s, %s)",
                    [(fake_es.word().capitalize(), 'Pastilles') for _ in range(100)])
    cur.execute("SELECT id_medicament FROM MEDICAMENT")
    med_ids = [r[0] for r in cur.fetchall()]

    # 7. Visites (100.000)
    visites_batch = []
    for _ in range(100000):
        visites_batch.append((
            random.choice(pac_ids),
            random.choice(metges_ids),
            fake_es.date_this_year(),
            "10:00:00",
            "Seguiment rutinari"
        ))

    # Inserim visites i guardem IDs per receptes
    cur.executemany("""INSERT INTO VISITA (id_pacient, id_metge, data, hora, diagnostic)
                       VALUES (%s, %s, %s, %s, %s)""", visites_batch)

    # 8. Reserves i Operacions
    for _ in range(1000):
        p_id = random.choice(pac_ids)
        cur.execute("INSERT INTO RESERVA_HABITACIO (id_habitacio, id_pacient, data_ingres) VALUES (%s, %s, %s)",
                    (random.choice(hab_ids), p_id, date.today()))

        cur.execute("INSERT INTO RESERVA_QUIROFAN (id_quirofan, id_pacient, data, hora) VALUES (%s, %s, %s, %s) RETURNING id_reserva_q",
                    (random.choice(quiro_ids), p_id, date.today(), "09:00:00"))
        rq_id = cur.fetchone()[0]

        cur.execute("INSERT INTO PERSONAL_OPERACIO (id_reserva_q, id_personal) VALUES (%s, %s)",
                    (rq_id, random.choice(personal_total_ids)))

    conn.commit()
    print("FET")
    cur.close()
    conn.close()

if __name__ == "__main__":
    generar_dades_completes()
