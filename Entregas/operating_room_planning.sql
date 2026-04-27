CREATE OR REPLACE FUNCTION veure_plan_quirofan(data_dia DATE)
RETURNS TABLE (
    id_quirofan INT,
    hora TIME,
    pacient TEXT,
    metge TEXT,
    equip_infermeria TEXT
)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT 
        o.id_quirofan, 
        o.data_hora::time, 
        p.nom, 
        m.nom,
        STRING_AGG(inf.nom, ', ') AS equip_infermeria
    FROM operacions o
    JOIN pacients p ON o.id_pacient = p.id_pacient
    JOIN personal m ON o.id_metge = m.id_personal
    LEFT JOIN infermeria_operacio io ON o.id_operacio = io.id_operacio
    LEFT JOIN personal inf ON io.id_infermer = inf.id_personal
    WHERE o.data_hora::date = data_dia
    GROUP BY o.id_quirofan, o.data_hora, p.nom, m.nom
    ORDER BY o.id_quirofan, o.data_hora;
END;
$$;
