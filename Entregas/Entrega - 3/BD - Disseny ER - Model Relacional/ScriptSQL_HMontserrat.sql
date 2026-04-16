--
CREATE TABLE PLANTES (
    id_planta SERIAL PRIMARY KEY,
    nom_planta VARCHAR(100) NOT NULL
);

CREATE TABLE HABITACIONS (
	id_habitacio SERIAL PRIMARY KEY,
    id_planta INT,
    FOREIGN KEY (id_planta) REFERENCES PLANTES(id_planta)
);

CREATE TABLE QUIROFANS (
	id_quirofan SERIAL PRIMARY KEY,
    nom_quirofan VARCHAR(100) NOT NULL,
    id_planta INT,
    FOREIGN KEY (id_planta) REFERENCES PLANTES(id_planta)
);

CREATE TABLE APARELLS_MEDICS (
    id SERIAL PRIMARY KEY,
    id_quirofan INT,
    tipus VARCHAR(100),
    quantitat INT CHECK (quantitat >= 1),
    FOREIGN KEY (id_quirofan) REFERENCES QUIROFANS(id_quirofan)
);


-- PERSONAL
-- Superclase
CREATE TABLE PERSONAL (
    id_personal SERIAL PRIMARY KEY,
    DNI VARCHAR(15) UNIQUE NOT NULL,
    nom VARCHAR(50) NOT NULL CHECK(nom = INITCAP(nom)),
    cognom VARCHAR(50) NOT NULL CHECK(cognom = INITCAP(cognom)),
    data_naixement DATE,
    datade_contratacio DATE DEFAULT CURRENT_DATE
);

-- Subclase Personal Mèdic
CREATE TABLE PERSONAL_MEDIC (
    id_metge INT PRIMARY KEY,
    especialitat VARCHAR(100),
    estudis TEXT,
    cv TEXT,
    FOREIGN KEY (id_metge) REFERENCES PERSONAL(id_personal)
);

-- Subclase Personal Vari
CREATE TABLE PERSONAL_VARI (
    id_empleat INT PRIMARY KEY,
    tipus VARCHAR(50),
    FOREIGN KEY (id_empleat) REFERENCES PERSONAL(id_personal) 
);

-- Subclase Infermeria
CREATE TABLE INFERMERIA (
    id_infermer INT PRIMARY KEY,
    id_metge INT,
    id_planta INT,
    FOREIGN KEY (id_infermer) REFERENCES PERSONAL(id_personal),
    FOREIGN KEY (id_metge) REFERENCES PERSONAL_MEDIC(id_metge),
    FOREIGN KEY (id_planta) REFERENCES PLANTES(id_planta)
);

-- PACIENTS Y VISITAS
CREATE TABLE PACIENT (
	id_pacient SERIAL PRIMARY KEY,
    DNI VARCHAR(15) UNIQUE NOT NULL,
    nom VARCHAR(50) NOT NULL CHECK(nom = INITCAP(nom)),
    cognom VARCHAR(50) NOT NULL CHECK(cognom = INITCAP(cognom)),
    telefon VARCHAR(15),
    data_naixement DATE
);

CREATE TABLE VISITA (
    id_visita SERIAL PRIMARY KEY,
    id_pacient INT,
    id_metge INT,
    data DATE DEFAULT CURRENT_DATE,
    hora TIME,
    diagnostic TEXT,
    FOREIGN KEY (id_pacient) REFERENCES PACIENT(id_pacient),
    FOREIGN KEY (id_metge) REFERENCES PERSONAL_MEDIC(id_metge)
);

CREATE TABLE MEDICAMENT (
    id_medicament SERIAL PRIMARY KEY,
    nom VARCHAR(100) NOT NULL,
    format VARCHAR(50), 
    descripcio TEXT
);

-- Relació entre VISITA i MEDICAMENT
CREATE TABLE RECEPTA_VISITA (
    id_visita INT,
    id_medicament INT,
    PRIMARY KEY (id_visita, id_medicament),
    FOREIGN KEY (id_visita) REFERENCES VISITA(id_visita),
    FOREIGN KEY (id_medicament) REFERENCES MEDICAMENT(id_medicament)
);

-- RESERVAS

CREATE TABLE RESERVA_HABITACIO (
	id_reserva_h SERIAL PRIMARY KEY,
    id_habitacio INT,
    id_pacient INT,
    data_ingres TIMESTAMP NOT NULL,
    data_sortida TIMESTAMP,
    FOREIGN KEY (id_habitacio) REFERENCES HABITACIONS(id_habitacio),
    FOREIGN KEY (id_pacient) REFERENCES PACIENT(id_pacient)
);

CREATE TABLE RESERVA_QUIROFAN (
    id_reserva_q SERIAL PRIMARY KEY,
    id_quirofan INT,
    id_pacient INT,
    data DATE NOT NULL,
    hora TIME NOT NULL,
    FOREIGN KEY (id_quirofan) REFERENCES QUIROFANS(id_quirofan),
    FOREIGN KEY (id_pacient) REFERENCES PACIENT(id_pacient)
);

-- Relacio Entre RESERVA_QUIROFAN i PERSONAL
CREATE TABLE PERSONAL_OPERACIO (
    id_reserva_q INT,
    id_personal INT,
    PRIMARY KEY (id_reserva_q, id_personal),
    FOREIGN KEY (id_reserva_q) REFERENCES RESERVA_QUIROFAN(id_reserva_q),
    FOREIGN KEY (id_personal) REFERENCES PERSONAL(id_personal)
);