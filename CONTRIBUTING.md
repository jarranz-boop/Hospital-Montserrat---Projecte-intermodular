# Contribuir a l'Hospital Montserrat

Gràcies per voler millorar el sistema de gestió de l'Hospital Montserrat! Segueix aquestes pautes per mantenir la qualitat del codi i la integritat del sistema.

## Configuració de l'Entorn

Per treballar en aquest projecte, necessitaràs:

1.  **Python 3.x**.
2.  **PostgreSQL**: El projecte utilitza una arquitectura de servidor principal i replicació.
3.  **Dependències**: Instal·la les llibreries requerides:
    * `psycopg2`: Connexió a la base de dades.
    * `bcrypt`: Gestió i xifrat de contrasenyes.
    * `Pillow (PIL)`: Per al logotip i la interfície gràfica.
    * `tkinter`: Per a la interfície d'usuari.

## Gestió de la Base de Dades

Si realitzes canvis en el model de dades:
* Respecta l'estructura de **Superclasse/Subclasse** de la taula `PERSONAL`.
* Les altes de personal s'han de realitzar mitjançant el procediment emmagatzemat `alta_personal`.
* No modifiquis els triggers de seguretat, com `tg_validar_operacio`, sense una justificació tècnica, ja que eviten conflictes en les reserves de quiròfans.

## Estàndards de Desenvolupament

* **Seguretat:** No s'ha de saltar mai el sistema de xifrat `bcrypt` per a la gestió d'usuaris a la taula `usuarios`.
* **Interfície:** Mantén la consistència visual utilitzant el color corporatiu blau (`#2b56cc`) per als elements principals.
* **Documentació:** Qualsevol funció nova o canvi en l'SQL ha d'estar degudament comentat.

## Procés de Contribució

1.  Fes un **Fork** del repositori.
2.  Crea una branca per a la teva millora (`git checkout -b millora-nom`).
3.  Fes els teus canvis i assegura't que el fitxer `hospital_consolidated.sql` estigui actualitzat si canvies l'esquema.
4.  Obre una **Pull Request** descrivint detalladament els canvis.

## Reportar Errors
Si trobes algun error en les funcions o en els procediments de la base de dades, obre una "Issue" detallant els passos per reproduir-lo i el missatge d'error obtingut.
