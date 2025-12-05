
ALTER TABLE VENTE_DETAILS ADD datereservation date;

-- LOCATION.VENTE_DETAILS_SAISIE source
CREATE OR REPLACE  VIEW VENTE_DETAILS_SAISIE (ID, IDVENTE, IDPRODUIT, DESIGNATION, IDORIGINE, QTE, PU, REMISE, TVA, PUACHAT, PUVENTE, IDDEVISE, TAUXDECHANGE, COMPTE,datereservation) AS 
  SELECT 
         id,
         IDVENTE ,
         IDPRODUIT ,
         DESIGNATION ,
         IDORIGINE ,
         qte,
         pu,
         REMISE ,
         TVA ,
         PUACHAT ,
         PUVENTE ,
         IDDEVISE ,
         TAUXDECHANGE ,
         compte,
         DATERESERVATION 
         FROM VENTE_DETAILS vd 
;
SELECT * FROM 	vente_details_saisie;





CREATE OR REPLACE VIEW VENTE_DETAILS_CPL (ID, IDVENTE, IDVENTELIB, IDPRODUIT, IDPRODUITLIB, IDORIGINE, QTE, PU, MONTANTREMISE, MONTANT, IDDEVISE, TAUXDECHANGE, TVA, IDCLIENT, IDCLIENTLIB, DESIGNATION, PUREVIENT, MONTANTREVIENT,DATERESERVATION) AS 
  SELECT vd.ID,
          vd.IDVENTE,
          v.DESIGNATION AS IDVENTELIB,
          vd.IDPRODUIT,
          p.VAL AS IDPRODUITLIB,
          vd.IDORIGINE,
          vd.QTE,
          VD.pu
             AS PU,
         	CAST((nvl(vd.remise/100,0))*(vd.QTE * vd.PU) AS NUMBER(30,2)) AS montantRemise,
            CAST((1-nvl(vd.remise/100,0))*(vd.QTE * vd.PU) AS NUMBER(30,2)) AS montant,
          vd.iddevise AS iddevise,
          vd.tauxDeChange AS tauxDeChange,
          vd.tva AS tva,
          v.idclient,
          v.idclientlib,
          vd.designation,
          vd.PUREVIENT,
          cast(vd.QTE*vd.PUREVIENT as NUMBER(20,2)) as montantRevient,
          vd.DATERESERVATION 
     FROM VENTE_DETAILS vd
          LEFT JOIN VENTE_LIB v ON v.ID = vd.IDVENTE
          LEFT JOIN PRODUIT p ON p.ID = vd.IDPRODUIT;
         
         SELECT * FROM VENTE_DETAILS_CPL vdc ;






