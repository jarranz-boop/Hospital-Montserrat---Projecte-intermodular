CREATE OR REPLACE FUNCTION veure_plan_visites(data_dia DATE)
RETURNS TABLE (
    hora_entrada TIME,
    metge TEXT,
    pacient TEXT
)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT 
        v.data_entrada::time,
        m.nom,
        p.nom
    FROM visites v
    JOIN personal m ON v.id_metge = m.id_personal
    JOIN pacients p ON v.id_pacient = p.id_pacient
    WHERE v.data_entrada::date = data_dia
    ORDER BY v.data_entrada;
END;
$$;
