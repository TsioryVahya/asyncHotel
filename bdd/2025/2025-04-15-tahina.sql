create view ACTE_LIB as
SELECT
    a.ID,
    a.DATY,
    a.IDPRODUIT,
    ai.LIBELLE AS libelleproduit,
    a.QTE,
    a.PU,
    a.PU * a.QTE AS montant,
    a.LIBELLE,
    a.IDCLIENT,
    c.NOM AS idclientlib,
    a.IDRESERVATION,
    a.ETAT,
    CASE
        WHEN a.ETAT = 0
            THEN 'ANNULEE'
        WHEN a.ETAT = 1
            THEN 'CREE'
        WHEN a.ETAT = 11
            THEN 'VISEE'
        END AS ETATLIB,
    ai.COMPTE_VENTE,
    ai.COMPTE_ACHAT,
    a.IDPRODUIT as IDCHAMBRE,
    ai.LIBELLE as chambre,
    cc.CHECKOUT
FROM ACTE a
         LEFT JOIN AS_INGREDIENTS ai  ON ai.id = a.IDPRODUIT
         LEFT JOIN CLIENT c ON c.id = a.IDCLIENT
left join CHECKINAVECCHEKOUT cc on cc.id=a.IDRESERVATION;

create or replace RESERVATIONDETSANSCIGROUP as
select max(id) as id,
       rd."IDMERE",
	rd."IDPRODUIT",
	sum(rd."QTE") as qte,
	min(rd."DATY") as daty,
	avg(rd."PU") as pu,
	max(rd."REMARQUE") as remarque,
	max(rd."ETAT") as etat,
	rd."IDCLIENT"
from RESERVATIONDETSANSCI rd group by rd.IDMERE,rd.IDPRODUIT,rd.IDCLIENT;

create or replace view CHECKOUTAVECRESERVATION as
select c.RESERVATION ,o.id,o.DATY,o.ETAT,  o.HEURE,o.REMARQUE, o.RESERVATION as checkOut from CHECKOUT o left join CHECKIN c on c.id=o.RESERVATION
/

create or replace view ACTE_LIB as
SELECT
    a.ID,
    a.DATY,
    a.IDPRODUIT,
    ai.LIBELLE AS libelleproduit,
    a.QTE,
    a.PU,
    a.PU * a.QTE AS montant,
    nvl(a.LIBELLE,ai.LIBELLE) as libelle,
    a.IDCLIENT,
    c.NOM AS idclientlib,
    a.IDRESERVATION,
    a.ETAT,
    CASE
        WHEN a.ETAT = 0
            THEN 'ANNULEE'
        WHEN a.ETAT = 1
            THEN 'CREE'
        WHEN a.ETAT = 11
            THEN 'VISEE'
        END AS ETATLIB,
    ai.COMPTE_VENTE,
    ai.COMPTE_ACHAT,
    a.IDPRODUIT as IDCHAMBRE,
    ai.LIBELLE as chambre,
    cc.CHECKOUT
FROM ACTE a
         LEFT JOIN AS_INGREDIENTS ai  ON ai.id = a.IDPRODUIT
         LEFT JOIN CLIENT c ON c.id = a.IDCLIENT
left join CHECKINAVECCHEKOUT cc on cc.id=a.IDRESERVATION
/

create or replace view ACTE_LIB as
SELECT
    a.ID,
    a.DATY,
    a.IDPRODUIT,
    ai.LIBELLE AS libelleproduit,
    a.QTE,
    a.PU,
    a.PU * a.QTE AS montant,
    nvl(a.LIBELLE,ai.LIBELLE) as libelle,
    a.IDCLIENT,
    c.NOM AS idclientlib,
    a.IDRESERVATION,
    a.ETAT,
    CASE
        WHEN a.ETAT = 0
            THEN 'ANNULEE'
        WHEN a.ETAT = 1
            THEN 'CREE'
        WHEN a.ETAT = 11
            THEN 'VISEE'
        END AS ETATLIB,
    ai.COMPTE_VENTE,
    ai.COMPTE_ACHAT,
    a.IDPRODUIT as IDCHAMBRE,
    ai.LIBELLE as chambre,
    cc.CHECKOUT,
    a.TVA
FROM ACTE a
         LEFT JOIN AS_INGREDIENTS ai  ON ai.id = a.IDPRODUIT
         LEFT JOIN CLIENT c ON c.id = a.IDCLIENT
left join CHECKINAVECCHEKOUT cc on cc.id=a.IDRESERVATION
/

