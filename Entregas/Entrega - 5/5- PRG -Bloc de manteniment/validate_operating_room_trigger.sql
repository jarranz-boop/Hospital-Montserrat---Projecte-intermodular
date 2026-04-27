CREATE OR REPLACE FUNCTION validar_disponibilitat_quirofan()
RETURNS TRIGGER AS $$
BEGIN
    IF EXISTS (
        SELECT 1 
        FROM operacions o
        WHERE o.id_quirofan = NEW.id_quirofan
        AND tsrange(o.data_hora, o.data_hora + o.durada, '[)') &&
            tsrange(NEW.data_hora, NEW.data_hora + NEW.durada, '[)')
    ) THEN
        RAISE EXCEPTION 'El quiròfan % ja està ocupat en aquesta franja horària (%).',
            NEW.id_quirofan, NEW.data_hora;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tg_validar_operacio
BEFORE INSERT ON operacions
FOR EACH ROW
EXECUTE FUNCTION validar_disponibilitat_quirofan();
