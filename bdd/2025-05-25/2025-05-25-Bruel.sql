

create or replace view RESERVATIONDETAILS_LIB_MARGE as
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
       nvl(cac.KILOMETRAGECHECKOUT - cac.KILOMETRAGECHECKIN, r.DISTANCEESTIMATION) * v.CHARGE_PER_KILOMETRE as revient,
       (r.QTE * r.PU) - (nvl(cac.KILOMETRAGECHECKIN - cac.KILOMETRAGECHECKOUT, r.DISTANCEESTIMATION) * v.CHARGE_PER_KILOMETRE) as marge,
       cac.id as idcheckin,
       cac.CHECKOUT as idcheckout,
       ai.IDVOITURE
FROM RESERVATIONDETAILS r
         LEFT JOIN AS_INGREDIENTS_LIB ai ON ai.id = r.IDPRODUIT
    left join CHECKINAVECCHEKOUT cac on cac.reservation = r.id
    left join voiture v on v.id = ai.idvoiture
/

select * from CHECKINAVECCHEKOUT;

create or replace view RESERVATIONDETAILS_LIBGROUPE2 as
SELECT min(r.ID)                              as id,
       r.IDMERE,
       sum(r.QTE)                             as qte,
       min(r.DATY)                            as daty,
       r.IDPRODUIT,
       r.libelleproduit                       AS libelleproduit,
       r.categorieproduit                     AS categorieproduit,
       avg(r.PU)                              as pu,
       sum(r.QTE * r.PU)                      AS montant,
       avg(r.tva)                             as tva,
       cast(sum(montantTva) as number(20, 2)) as montantTva,
       cast(sum(montantttc) as number(20, 2)) as montantttc,
       r.categorieproduitlib                  AS categorieproduitlib,
       min(r.heure)                           AS heure,
       r.DISTANCEESTIMATION,
       r.distancereelle,
       r.KILOMETRAGECHECKIN,
       r.KILOMETRAGECHECKOUT,
       r.CHARGE_PER_KILOMETRE,
       r.VALEUR_ACTUELLE,
       r.revient,
       r.marge,
       r.idcheckin,
       r.idcheckout,
       r.IDVOITURE
FROM RESERVATIONDETAILS_LIB_MARGE r
group by r.idmere, r.idproduit, r.libelleproduit, r.categorieproduit, r.categorieproduitlib, r.DISTANCEESTIMATION,
         r.KILOMETRAGECHECKIN, r.KILOMETRAGECHECKOUT, r.CHARGE_PER_KILOMETRE, r.VALEUR_ACTUELLE, r.revient, r.marge, r.distancereelle, r.idcheckin,
       r.idcheckout, r.IDVOITURE
/


create or replace view reservation_nbr_checkin as
select idmere as reservation, IDVOITURE, sum(case when idcheckin is null then 0 else 1 end) as checkinnumber from RESERVATIONDETAILS_LIB_MARGE group by idmere, IDVOITURE;

create or replace view reservationlib_sanscheckin as
select rl.*, rnc.checkinnumber, rnc.IDVOITURE from RESERVATION_LIB rl left join reservation_nbr_checkin rnc on rnc.reservation = rl.id where checkinnumber < 1;
