create or replace view RESERVATIONMONTANT as
SELECT r.IDMERE,
       cast(sum(r.montant) as number(20, 2))    AS montant,
       cast(sum(r.MONTANTTVA) as number(20, 2)) as MONTANTTVA,
       cast(sum(r.MONTANTTTC) as number(20, 2)) as MONTANTTTC,
       cast(sum(r.revient) as number(20, 2))    as revient,
       cast(sum(r.marge) as number(20, 2))      as marge
FROM RESERVATIONDETAILS_LIB_MARGE r
GROUP BY r.IDMERE
/

create or replace view RESERVATION_LIB as
SELECT r.id,
       r.idClient,
       c.NOM                                                     AS idclientlib,
       r.daty,
       r.remarque,
       r.etat,
       CASE
           WHEN r.etat = 1
               THEN 'CREE'
           WHEN r.etat = 0
               THEN 'ANNULEE'
           WHEN r.etat = 11
               THEN 'VISEE'
           END                                                   AS etatlib,
       rm.montant,
       rm.MONTANTTTC,
       rm.MONTANTTVA,
       nvl(mvt.CREDIT, 0)                                        as paye,
       cast(rm.MONTANTTTC - nvl(mvt.CREDIT, 0) as number(20, 2)) as resteAPayer,
       rm.revient,
       rm.marge
FROM RESERVATION r
         LEFT JOIN CLIENT c ON c.id = r.idClient
         LEFT JOIN reservationmontant rm ON rm.idmere = r.id
         left join MOUVEMENTCAISSEGROUPERESA mvt on mvt.IDORIGINE = r.ID
/