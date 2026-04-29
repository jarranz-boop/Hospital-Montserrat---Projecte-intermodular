CREATE OR REPLACE PROCEDURE alta_personal(
    p_nom TEXT,
    p_tipus VARCHAR(50),
    p_es_planta BOOLEAN DEFAULT NULL,
    p_id_metge INT DEFAULT NULL
)
LANGUAGE plpgsql
AS $$
BEGIN
    -- Validació: Si és infermer i no és de planta, ha de tenir metge assignat
    IF p_tipus = 'infermer/a' AND COALESCE(p_es_planta, FALSE) = FALSE AND p_id_metge IS NULL THEN
        RAISE EXCEPTION 'Els infermers/res no de planta han de dependre d''un metge/ssa.';
    END IF;
    -- Validació del tipus de metge
    IF p_id_metge IS NOT NULL THEN
        IF NOT EXISTS (
            SELECT 1 FROM personal
            WHERE id_personal = p_id_metge AND tipus_empleat = 'metge/ssa'
        ) THEN
            RAISE EXCEPTION 'El supervisor assignat ha de ser un metge/ssa.';
        END IF;
    END IF;
    INSERT INTO personal (nom, tipus_empleat, es_de_planta, metge_assignat_id)
    VALUES (p_nom, p_tipus, p_es_planta, p_id_metge);
END;
$$;