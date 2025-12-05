 --nanisy valeur ana client sy nanampy etatlib ana checkin
 -- ASYNCHOTEL.CHECKINLIBELLE source

CREATE OR REPLACE  VIEW CHECKINLIBELLE (ID,RESERVATION,DATY,HEURE,REMARQUE,CLIENT,IDPRODUIT,ETAT,IDCLIENT,CHECKOUT,PRODUITLIBELLE,PU,TVA,etatlib) AS 
  SELECT
	c.ID,
	c.RESERVATION,
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
	THEN 'ANNULEE'
	WHEN c.ETAT = 1
	THEN 'CREE'
	WHEN c.ETAT = 11
	THEN 'VISEE'
END AS ETATLIB
FROM
	checkInAvecChekOut c
LEFT JOIN AS_INGREDIENTS i ON c.IDPRODUIT = i.id
LEFT JOIN CLIENT cl ON c.IDCLIENT=cl.id
;


--menus anle reservation calendrier 
INSERT INTO MENUDYNAMIQUE
(ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES('ELMD001104005', 'Calendrier', 'fa fa-calendar', 'module.jsp?but=reservation/reservation-calendrier.jsp', 1, 2, 'ELM001104004');

UPDATE MENUDYNAMIQUE
	SET  RANG=4 
	WHERE ID='ELM001504001';
UPDATE MENUDYNAMIQUE
	SET RANG=2 
	WHERE ID='313';
UPDATE MENUDYNAMIQUE
	SET  RANG=3 
	WHERE ID='ELM001104006';

--menus anle occupation saisie sy liste (checkin)
 INSERT INTO MENUDYNAMIQUE
(ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES('ELM00314', 'Saisie', 'fa fa-plus', 'module.jsp?but=check/checkin-saisie.jsp', 1, 2, 'ELM001404001');
INSERT INTO MENUDYNAMIQUE
(ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES('ELM00315', 'Liste', 'fa fa-list', 'module.jsp?but=check/checkin-liste.jsp', 2, 2, 'ELM001404001');


CREATE VIEW historique_utilisateur AS (
SELECT 
	h.*,u.LOGINUSER AS utilisateur 
FROM Historique h
LEFT JOIN UTILISATEUR u ON h.IDUTILISATEUR =u.REFUSER 
);
