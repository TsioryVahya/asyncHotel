-- etat lib
CREATE OR REPLACE  VIEW "RESERVATION_LIB" ("ID", "IDCLIENT", "IDCLIENTLIB", "DATY", "REMARQUE", "ETAT", "ETATLIB", "MONTANT", "MONTANTTTC", "MONTANTTVA", "PAYE", "RESTEAPAYER", "REVIENT", "MARGE") AS
SELECT r.id,
       r.idClient,
       c.NOM                                                     AS idclientlib,
       r.daty,
       r.remarque,
       r.etat,
       CASE
           WHEN r.etat = 1
               THEN 'CRÉÉE'
           WHEN r.etat = 0
               THEN 'ANNULÉE'
           WHEN r.etat = 11
               THEN 'VISÉE'
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
         left join MOUVEMENTCAISSEGROUPERESA mvt on mvt.IDORIGINE = r.ID;

-- ajout colonne remarque
CREATE OR REPLACE VIEW "RESERVATIONDETAILS_LIB_MARGE" ("ID", "IDMERE", "QTE", "DATY", "IDPRODUIT", "LIBELLEPRODUIT", "CATEGORIEPRODUIT", "PU", "MONTANT", "TVA", "MONTANTTVA", "MONTANTTTC", "CATEGORIEPRODUITLIB", "HEURE", "DISTANCEESTIMATION", "KILOMETRAGECHECKIN", "KILOMETRAGECHECKOUT", "DISTANCEREELLE", "CHARGE_PER_KILOMETRE", "VALEUR_ACTUELLE", "REVIENT", "MARGE", "IDCHECKIN", "IDCHECKOUT", "IDVOITURE", "ETAT","REMARQUE") AS
SELECT r.ID,
       r.IDMERE,
       r.QTE,
       r.DATY,
       r.IDPRODUIT,
       ai.LIBELLE                                                                      AS libelleproduit,
       ai.idCATEGORIEINGREDIENT                                                        AS categorieproduit,
       r.PU,
       r.QTE * r.PU                                                                    AS montant,
       ai.tva                                                                          as tva,
       cast(r.qte * r.pu * (nvl(ai.tva, 0) / 100) as number(20, 2))                    as montantTva,
       cast((r.QTE * r.PU) + (r.qte * r.pu * (nvl(ai.tva, 0) / 100)) as number(20, 2)) as montantttc,
       ai.CATEGORIEINGREDIENT                                                          AS categorieproduitlib,
       r.heure                                                                         AS heure,
       r.DISTANCEESTIMATION,
       cac.KILOMETRAGECHECKIN,
       cac.KILOMETRAGECHECKOUT,
       nvl(cac.KILOMETRAGECHECKOUT - cac.KILOMETRAGECHECKIN, 0) as distancereelle,
       v.CHARGE_PER_KILOMETRE,
       v.VALEUR_ACTUELLE,
       cast (greatest(nvl(cac.KILOMETRAGECHECKOUT - cac.KILOMETRAGECHECKIN, r.DISTANCEESTIMATION) * v.CHARGE_PER_KILOMETRE,0) as number(30,2)) as revient,
       cast((r.QTE * r.PU) - greatest(nvl(cac.KILOMETRAGECHECKOUT - cac.KILOMETRAGECHECKIN, r.DISTANCEESTIMATION) * v.CHARGE_PER_KILOMETRE,0)as number(30,2)) as marge,
       cac.id as idcheckin,
       cac.CHECKOUT as idcheckout,
       ai.IDVOITURE,
       rm.ETAT,
       r.remarque
FROM RESERVATIONDETAILS r
         LEFT JOIN AS_INGREDIENTS_LIB ai ON ai.id = r.IDPRODUIT
         left join CHECKINAVECCHEKOUT cac on cac.reservation = r.id
         left join voiture v on v.id = ai.idvoiture
         left join reservation rm on rm.id = r.IDMERE;

-- rectifs libelle etat

CREATE OR REPLACE VIEW "CHECKINLIBELLE" ("ID", "RESERVATION", "IDRESERVATIONMERE", "DATY", "HEURE", "REMARQUE", "CLIENT", "IDPRODUIT", "ETAT", "IDCLIENT", "CHECKOUT", "PRODUITLIBELLE", "PU", "TVA", "ETATLIB", "KILOMETRAGECHECKIN", "KILOMETRAGECHECKOUT", "DISTANCEREELLE", "QUANTITE", "EQUIVALENCE") AS
SELECT
    c.ID,
    c.RESERVATION,
    nvl(r2.ID,c.reservation) AS idReservationMere,
    c.DATY,
    c.HEURE,
    c.REMARQUE,
    cl.nom AS CLIENT,
    c.IDPRODUIT,
    c.ETAT,
    c.IDCLIENT,
    c.CHECKOUT,
    i.LIBELLE AS produitLibelle,
    i.pu,
    i.tva,
    CASE
        WHEN c.ETAT = 0
            THEN 'ANNULÉ'
        WHEN c.ETAT = 1
            THEN 'CRÉÉ'
        WHEN c.ETAT = 11
            THEN 'VISÉ'
        END AS ETATLIB,
    c.kilometragecheckin,
    c.kilometragecheckout,
    c.distancereelle,
    c.quantite,
    u.EQUIVALENCE
FROM
    checkInAvecChekOut c
        LEFT JOIN RESERVATIONDETAILS r ON r.ID = c.RESERVATION
        LEFT JOIN RESERVATION r2 ON r.IDMERE = r2.id
        LEFT JOIN AS_INGREDIENTS i ON c.IDPRODUIT = i.id
        LEFT JOIN CLIENT cl ON c.IDCLIENT=cl.id
        left join AS_UNITE u on i.UNITE=u.ID;


-- etat lib
CREATE OR REPLACE VIEW "CHECKOUTLIB" ("ID", "RESERVATION", "IDRESERVATIONMERE", "DATY", "HEURE", "REMARQUE", "ETAT", "PRODUITLIBELLE", "ETATLIB", "KILOMETRAGECHECKIN", "KILOMETRAGECHECKOUT", "DISTANCEREELLE", "QUANTITE") AS
select
    ch.ID,ci.ID as RESERVATION,ci.IDRESERVATIONMERE,ch.DATY,ch.HEURE,ch.REMARQUE,ch.ETAT,
    ci.PRODUITLIBELLE,
    case when ch.ETAT = 1 then 'CRÉÉ'
         when ch.ETAT = 11 then 'VISÉ'
        END as etatlib,
    ci.kilometragecheckin,
    ch.KILOMETRAGE as kilometragecheckout,
    ci.distancereelle,
    ch.quantite
from CHECKOUT ch
         join CHECKINLIBELLE ci on ci.ID = ch.RESERVATION;