BEGIN TRANSACTION

-- Taula del personal
CREATE TABLE personal (
    id_personal SERIAL PRIMARY KEY,
    nom TEXT NOT NULL,
    tipus_empleat TEXT CHECK (tipus_empleat IN ('metge/ssa', 'infermer/a', 'administratiu/va', 'neteja')) NOT NULL,
 
    -- Camps per infermeria
    es_de_planta BOOLEAN DEFAULT TRUE,
    metge_assignat_id INT REFERENCES personal(id_personal)
);

-- Taula de pacients
CREATE TABLE pacients (
    id_pacient SERIAL PRIMARY KEY,
    nom TEXT NOT NULL,
    dni TEXT UNIQUE NOT NULL
);

-- Taula de operacions
CREATE TABLE operacions (
    id_operacio SERIAL PRIMARY KEY,
    id_quirofan INT NOT NULL,
    id_pacient INT REFERENCES pacients(id_pacient),
    id_metge INT REFERENCES personal(id_personal),
    data_hora TIMESTAMP NOT NULL,
    durada INTERVAL DEFAULT '1 hour'
);

-- Taula de els infermers/es amb quina operacio están assignats/des
CREATE TABLE infermeria_operacio (
    id_operacio INT REFERENCES operacions(id_operacio),
    id_infermer INT REFERENCES personal(id_personal),
    PRIMARY KEY (id_operacio, id_infermer)
);

-- Taula de visites
CREATE TABLE visites (
    id_visita SERIAL PRIMARY KEY,
    id_pacient INT REFERENCES pacients(id_pacient),
    id_metge INT REFERENCES personal(id_personal),
    data_entrada TIMESTAMP NOT NULL
);

COMMIT;