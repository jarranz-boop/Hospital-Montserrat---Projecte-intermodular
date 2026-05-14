-- Índexes per a la PACIENT
CREATE INDEX IF NOT EXISTS idx_pacient_dni ON pacient(dni);
CREATE INDEX IF NOT EXISTS idx_pacient_cognom ON pacient(cognom);

-- Índexes per a la VISITA
CREATE INDEX IF NOT EXISTS idx_visita_pacient ON visita(id_pacient);
CREATE INDEX IF NOT EXISTS idx_visita_metge ON visita(id_metge);
CREATE INDEX IF NOT EXISTS idx_visita_data ON visita(data);

-- Índexes per a la  PERSONAL
CREATE INDEX IF NOT EXISTS idx_personal_dni ON personal(dni);

-- Índexes per a la RESERVA_HABITACIO
CREATE INDEX IF NOT EXISTS idx_reserva_hab_pacient ON reserva_habitacio(id_pacient);
CREATE INDEX IF NOT EXISTS idx_reserva_hab_data ON reserva_habitacio(data_ingres);

-- Índexes per a la RESERVA_QUIROFAN
CREATE INDEX IF NOT EXISTS idx_reserva_q_pacient ON reserva_quirofan(id_pacient);
CREATE INDEX IF NOT EXISTS idx_reserva_q_data ON reserva_quirofan(data);
