--Diamondra
--ajout heure dans reservationdetails

 ALTER TABLE RESERVATIONDETAILS ADD heure varchar2(100);

--nanampy tva
 -- ASYNCHOTEL.AS_INGREDIENTS_LIB source
CREATE OR REPLACE VIEW AS_INGREDIENTS_LIB (ID, LIBELLE, SEUIL, UNITE, QUANTITEPARPACK, PU, ACTIF, PHOTO, CALORIE, DURRE, COMPOSE, IDCATEGORIEINGREDIENT, CATEGORIEINGREDIENT, IDCATEGORIE, IDFOURNISSEUR, DATY, BIENOUSERV, ETATLIB, COMPTE_VENTE, COMPTE_ACHAT, PV,TVA) AS 
  SELECT ing.id,
          ing.LIBELLE,
          ing.SEUIL,
          au.VAL AS unite,
          ing.QUANTITEPARPACK,
          ing.pu,
          ing.ACTIF,
          ing.PHOTO,
          ing.CALORIE,
          ing.DURRE,
          ing.COMPOSE,
          cating.id AS IDCATEGORIEINGREDIENT ,
          catIng.VAL AS CATEGORIEINGREDIENT,
          ing.CATEGORIEINGREDIENT AS idcategorie,
          ing.idfournisseur,
          ing.daty,
          catIng.desce as bienOuServ,
	      CASE WHEN ing.id IN (SELECT idproduit FROM INDISPONIBILITE i )
	      THEN 'INDISPONIBLE'
	      WHEN ing.id NOT IN (SELECT idproduit FROM INDISPONIBILITE i )
	      THEN 'DISPONIBLE'
	      END AS etatlib,
        ing.COMPTE_VENTE,
        ing.COMPTE_ACHAT,
        ing.pv,
        ing.tva
     FROM as_ingredients ing
          JOIN AS_UNITE AU ON ing.UNITE = AU.ID
          JOIN CATEGORIEINGREDIENTLIB catIng
             ON catIng.id = ing.CATEGORIEINGREDIENT;

            
            
--nanampy CATEGORIEPRODUITLIB sy heure
-- ASYNCHOTEL.RESERVATIONDETAILS_LIB source

CREATE OR REPLACE  VIEW RESERVATIONDETAILS_LIB (ID, IDMERE, QTE, DATY, IDPRODUIT, LIBELLEPRODUIT, CATEGORIEPRODUIT, PU, MONTANT, TVA, MONTANTTVA, MONTANTTTC,CATEGORIEPRODUITLIB,HEURE) AS 
  SELECT 
r.ID,
r.IDMERE,
r.QTE,
r.DATY,
r.IDPRODUIT,
ai.LIBELLE AS libelleproduit,
ai.idCATEGORIEINGREDIENT AS categorieproduit,
r.PU,
r.QTE * r.PU AS  montant,
ai.tva as tva,
cast(r.qte*r.pu*(nvl(ai.tva,0)/100) as number(20,2)) as montantTva,
cast((r.QTE * r.PU)+(r.qte*r.pu*(nvl(ai.tva,0)/100)) as number(20,2)) as montantttc,
ai.CATEGORIEINGREDIENT AS categorieproduitlib,
r.heure AS heure
FROM RESERVATIONDETAILS r 
LEFT JOIN AS_INGREDIENTS_LIB ai ON ai.id = r.IDPRODUIT;


--ajout colonne idreservation dans vente
ALTER TABLE vente ADD idreservation VARCHAR2(100) ;

create or replace view ReservationDetailsAvecMere as
select rd.id,ing.id as IDPRODUIT,rd.qte,rd.daty,r.IDCLIENT,r.ETAT as etat,c.nom||' '||c.TELEPHONE as libelleclient ,rd.IDMERE,ing.LIBELLE as libelleproduit from AS_INGREDIENTS ing
    join reservationDetails rd on rd.idproduit=ing.ID
    left join reservation r on r.id=rd.IDMERE
left join CLIENT c on c.id=r.IDCLIENT;
