from dotenv import load_dotenv
import os
import psycopg2
from psycopg2 import OperationalError

def connect_db(usuari, password):
    """Prova de connectar al srvprimary i si no al srvstandby."""
    hosts = ["srvprimary", "srvstandby"]
    conn = None

    for host in hosts:
        print(f"Intentant connexió a {host}...")
        try:
            conn = psycopg2.connect(
                dbname="Montserrat",
                user="postgres",
                password="anas",
                host=host,
                port="5432",
                connect_timeout=3,
            )
            print(f"Connexió establerta amb {host}")
            return conn
        except OperationalError as e:
            print(f"Error amb {host}: {e}")

    print("No s'ha pogut connectar a cap node.")
    return None

def eliminar():
    load_dotenv()
    conn = connect_db(os.getenv("DB_USER"), os.getenv("DB_PASSWORD"))
    if not conn: return

    cur = conn.cursor()
    # Taules del hospital 
    tables = [
        "personal_operacio", "reserva_quirofan", "reserva_habitacio",
        "recepta_visita", "visita", "pacient", "aparells_medics",
        "quirofans", "habitacions", "infermeria", "personal_medic",
        "personal_vari", "personal", "plantes"
    ]

    for table in tables:
        cur.execute(f"TRUNCATE public.{table} CASCADE")
        print(f"Taula {table} neta.")

    conn.commit()
    cur.close()
    conn.close()
    print("Tot esborrat.")

if __name__ == "__main__":
    eliminar()
