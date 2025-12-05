CREATE OR REPLACE VIEW V_DISPONIBILTE_CHAMBRE AS
SELECT
    d.DATY,
    i.ID AS IDCHAMBRE,
    i.LIBELLE AS NOMCHAMBRE,
    resa.QTE,
    resa.IDMERE AS IDRESERVATION,
    resa.ETAT
FROM (
         SELECT TO_DATE('2025-01-01', 'YYYY-MM-DD') + LEVEL - 1 AS DATY
         FROM dual
         CONNECT BY LEVEL <= TO_DATE('2026-12-31', 'YYYY-MM-DD') - TO_DATE('2025-01-01', 'YYYY-MM-DD') + 1
     ) d
         CROSS JOIN (
    SELECT * FROM AS_INGREDIENTS WHERE CATEGORIEINGREDIENT = 'CAT001'
) i
         LEFT JOIN RESERVATIONDETAILSAVECMERE resa
                   ON resa.DATY = d.DATY AND resa.IDPRODUIT = i.ID;
/

-- ny libelle ana chambre anaty AS_INGREDIENTS ampiana numero de chambre

update RESERVATION set etat = 0 where id = 'RESA000067';
update AS_INGREDIENTS set LIBELLE = 'Suite Premium' where id = 'CHB00012';