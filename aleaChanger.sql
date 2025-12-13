CREATE OR REPLACE FORCE VIEW "ASYNCHOTEL"."RESERVATIONDETAILS_LIB_MARGE"
(
  "ID","IDMERE","QTE","DATY","IDPRODUIT","LIBELLEPRODUIT","CATEGORIEPRODUIT",
  "PU","MONTANT","TVA","MONTANTTVA","MONTANTTTC","CATEGORIEPRODUITLIB","HEURE",
  "DISTANCEESTIMATION","KILOMETRAGECHECKIN","KILOMETRAGECHECKOUT","DISTANCEREELLE",
  "CHARGE_PER_KILOMETRE","VALEUR_ACTUELLE","REVIENT","MARGE",
  "IDCHECKIN","IDCHECKOUT","IDVOITURE","IDVOITURELIB","ETAT"
)
AS
SELECT
  r.ID,
  r.IDMERE,
  r.QTE,
  r.DATY,
  r.IDPRODUIT,
  ai.LIBELLE                                                                      AS LIBELLEPRODUIT,
  ai.idCATEGORIEINGREDIENT                                                        AS CATEGORIEPRODUIT,
  r.PU,
  r.QTE * r.PU                                                                    AS MONTANT,
  ai.TVA                                                                          AS TVA,
  CAST(r.QTE * r.PU * (NVL(ai.TVA, 0) / 100) AS NUMBER(20, 2))                    AS MONTANTTVA,
  CAST((r.QTE * r.PU) + (r.QTE * r.PU * (NVL(ai.TVA, 0) / 100)) AS NUMBER(20, 2)) AS MONTANTTTC,
  ai.CATEGORIEINGREDIENT                                                          AS CATEGORIEPRODUITLIB,
  r.HEURE                                                                         AS HEURE,
  r.DISTANCEESTIMATION,
  cac.KILOMETRAGECHECKIN,
  cac.KILOMETRAGECHECKOUT,
  NVL(cac.KILOMETRAGECHECKOUT - cac.KILOMETRAGECHECKIN, 0)                        AS DISTANCEREELLE,
  v.CHARGE_PER_KILOMETRE,
  v.VALEUR_ACTUELLE,
  CAST(GREATEST(NVL(cac.KILOMETRAGECHECKOUT - cac.KILOMETRAGECHECKIN, r.DISTANCEESTIMATION) * v.CHARGE_PER_KILOMETRE, 0) AS NUMBER(30, 2)) AS REVIENT,
  CAST((r.QTE * r.PU) - GREATEST(NVL(cac.KILOMETRAGECHECKOUT - cac.KILOMETRAGECHECKIN, r.DISTANCEESTIMATION) * v.CHARGE_PER_KILOMETRE, 0) AS NUMBER(30, 2)) AS MARGE,
  cac.ID                                                                           AS IDCHECKIN,
  cac.CHECKOUT                                                                     AS IDCHECKOUT,
  r.IDVOITURE,                                  -- ICI: voiture du détail
  v.NOM                                        AS IDVOITURELIB,  -- label voiture du détail
  rm.ETAT
FROM RESERVATIONDETAILS r
LEFT JOIN AS_INGREDIENTS_LIB ai ON ai.ID = r.IDPRODUIT
LEFT JOIN CHECKINAVECCHEKOUT cac ON cac.RESERVATION = r.ID
LEFT JOIN VOITURE v ON v.ID = r.IDVOITURE       -- ICI: jointure sur la voiture du détail
LEFT JOIN RESERVATION rm ON rm.ID = r.IDMERE;