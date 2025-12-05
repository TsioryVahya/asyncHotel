--Menu : 
--modification Magasin miova Site 
--Suppression Bon de commande client

UPDATE MENUDYNAMIQUE
SET LIBELLE='Site'
WHERE ID='MDT021030017';

UPDATE MENUDYNAMIQUE
SET ID_PERE='MNDN0'
WHERE ID='MNDN00000000107';

--Ajouter TABLE "NATIONALITE"
--id,val,desce 
--TABLE Client ajouter fk idNationalite

create table NATIONALITE(
    id varchar(100) constraint NATIONALITE_pk primary key ,
    val varchar(255) ,
    desce varchar(255)
);


create sequence seqNATIONALITE
      minvalue 1
      maxvalue 999999999999
      start with 1
      increment by 1
      cache 20;
      
      

CREATE OR REPLACE FUNCTION getseqNATIONALITE
   RETURN NUMBER
IS
   retour   NUMBER;
BEGIN
   SELECT seqNATIONALITE.NEXTVAL INTO retour FROM DUAL;

   RETURN retour;
END; 

ALTER TABLE CLIENT ADD idNationalite varchar(100) CONSTRAINT client_nationalite_fk REFERENCES NATIONALITE(id);


--MENUS
--Livraison des vente :miala
--Bondecommande :miala
--Magasin miova hoe site
--composant miova ho services et chambres
--Acte miova ho Service Faits

UPDATE MENUDYNAMIQUE
SET ID_PERE='MNDN0'
WHERE ID='MNDN000000008';

UPDATE MENUDYNAMIQUE
SET ID_PERE='MNDN0'
WHERE ID='MNDN0000000123';

UPDATE MENUDYNAMIQUE
SET LIBELLE='Site'
WHERE ID='MDT021030017';

UPDATE MENUDYNAMIQUE
SET LIBELLE='Services et Chambres'
WHERE ID='MNDN00001';

UPDATE MENUDYNAMIQUE
SET LIBELLE='Service Faits'
WHERE ID='ELM001104001';

--manampy menu iray hoe occupation any @farany ambany, d # fotsiny aloha ny URL anle izy stp

INSERT INTO MENUDYNAMIQUE
(ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES('ELM001404001', 'Occupation', 'fa fa-bed', NULL, 16, 1, NULL);

INSERT INTO USERMENU
(ID, REFUSER, IDMENU, IDROLE, CODESERVICE, CODEDIR, INTERDIT)
VALUES('USRMEN01404001', '*', 'ELM001404001', NULL, NULL, NULL, NULL);


--RESERVATIONDETSANSCI
--mba  ampiana  heure avy amin reservation details koa aminity  stp,

CREATE OR REPLACE  VIEW RESERVATIONDETSANSCI (ID, IDMERE, IDPRODUIT, QTE, DATY, PU, REMARQUE, ETAT,HEURE) AS 
  SELECT
	rd.ID,
	rd.IDMERE,
	rd.IDPRODUIT,
	rd.QTE,
	rd.DATY,
	rd.PU,
	rd.REMARQUE,
	rd.ETAT,
	rd.HEURE
FROM
	reservationDetails rd
WHERE
	rd.idmere NOT IN (
	SELECT
		c.reservation
	FROM
		checkin c
	WHERE
		c.etat >= 11
		AND c.IDPRODUIT = rd.idproduit);

create or replace view ST_INGREDIENTSAUTOVENTE as
SELECT
    ai."ID",ai."LIBELLE",ai."SEUIL",ai."UNITE",ai."QUANTITEPARPACK",ai."PU",ai."ACTIF",ai."PHOTO",ai."CALORIE",ai."DURRE",ai."COMPOSE",ai."CATEGORIEINGREDIENT",ai."IDFOURNISSEUR",ai."DATY",ai."QTELIMITE",ai."PV",ai."LIBELLEVENTE",ai."SEUILMIN",ai."SEUILMAX",ai."PUACHATUSD",ai."PUACHATEURO",ai."PUACHATAUTREDEVISE",ai."PUVENTEUSD",ai."PUVENTEEURO",ai."PUVENTEAUTREDEVISE",ai."ISVENTE",ai."ISACHAT",ai."COMPTE_VENTE",ai."COMPTE_ACHAT", ai.TVA,
    CASE
        WHEN ai.COMPTE_VENTE IS NOT NULL THEN ai.COMPTE_VENTE
        ELSE ai.COMPTE_ACHAT
        END AS compte
FROM AS_INGREDIENTS ai where ai.pv>0


-- nanampy colonne chambre tao amin'ny acte izay as_ingredient ihany
alter table ACTE add idchambre varchar(255) constraint fk_chambre references AS_INGREDIENTS;

-- nanao vue azahona ny categorie hebergement rehetra
create or replace view ST_INGREDIENTSAUTOCHAMBRE as
SELECT
    ai."ID",ai."LIBELLE",ai."SEUIL",ai."UNITE",ai."QUANTITEPARPACK",ai."PU",ai."ACTIF",ai."PHOTO",ai."CALORIE",ai."DURRE",ai."COMPOSE",ai."CATEGORIEINGREDIENT",ai."IDFOURNISSEUR",ai."DATY",ai."QTELIMITE",ai."PV",ai."LIBELLEVENTE",ai."SEUILMIN",ai."SEUILMAX",ai."PUACHATUSD",ai."PUACHATEURO",ai."PUACHATAUTREDEVISE",ai."PUVENTEUSD",ai."PUVENTEEURO",ai."PUVENTEAUTREDEVISE",ai."ISVENTE",ai."ISACHAT",ai."COMPTE_VENTE",ai."COMPTE_ACHAT", ai.TVA,
    CASE
        WHEN ai.COMPTE_VENTE IS NOT NULL THEN ai.COMPTE_VENTE
        ELSE ai.COMPTE_ACHAT
        END AS compte
FROM AS_INGREDIENTS ai where ai.pv>0 and ai.CATEGORIEINGREDIENT = 'CAT001'


-- nanampy idchambre
create or replace view ACTE_LIB as
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
    a.IDCHAMBRE,
    st.LIBELLE as chambre
FROM ACTE a
         LEFT JOIN AS_INGREDIENTS ai  ON ai.id = a.IDPRODUIT
         LEFT JOIN ST_INGREDIENTSAUTOCHAMBRE st on st.ID = a.IDCHAMBRE
         LEFT JOIN CLIENT c ON c.id = a.IDCLIENT;


-- creation CHECKINSANSCHEKOUTCPL afahana mahazo chambre libelle
create or replace view CHECKINSANSCHEKOUTCPL as
select
    ch."ID",ch."RESERVATION",ch."DATY",ch."HEURE",ch."REMARQUE",ch."CLIENT",ch."IDPRODUIT",ch."ETAT",ch."IDCLIENT",
    ing.LIBELLE as chambre
from CHECKINSANSCHEKOUT ch
         join AS_INGREDIENTS ing on ch.idproduit = ing.id
where ing.CATEGORIEINGREDIENT = 'CAT001'