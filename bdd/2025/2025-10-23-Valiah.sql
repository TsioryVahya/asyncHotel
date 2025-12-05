
  
CREATE OR REPLACE VIEW VENTE_DETAILS_CPL AS 
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
          CPL.iddevise AS iddevise,
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
          LEFT JOIN PRODUIT p ON p.ID = vd.IDPRODUIT
          LEFT JOIN Vente_cpl cpl ON cpl.ID = vd.IDVENTE 
         ;
         