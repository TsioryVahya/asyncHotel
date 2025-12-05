-----2025-04-15
---------Tiavina

--checkin , qte number(30,2)
ALTER TABLE CHECKIN ADD qte NUMBER(30,2); 

--mba anaovana menu iray azafady
--lien: reservation/reservation-simple-saisie.jsp atao zanan'ny reservation 
--atao titre reseravation simple

INSERT INTO MENUDYNAMIQUE
(ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES('ELM001504001', 'Réservation simple', 'fa fa-plus', 'module.jsp?but=reservation/reservation-simple-saisie.jsp', 3, 2, 'ELM001104004');

--ilay vue mila ovaina
--RESERVATIONDETSANSCI atao group by idproduit et idReservation 


CREATE OR REPLACE  VIEW RESERVATIONDETSANSCI (ID, IDMERE, IDPRODUIT, QTE, DATY, PU, REMARQUE, ETAT, IDCLIENT) AS 
    SELECT
    min(rd.ID) as id,
	rd.IDMERE,
	rd.IDPRODUIT,
	sum(rd.QTE) AS QTE ,
	min(rd.DATY) AS DATY,
	avg(rd.PU) as pu,
	rd.REMARQUE,
	avg(rd.ETAT) AS ETAT,
	min(r.IDCLIENT) AS IDCLIENT
FROM
	reservationDetails rd
	JOIN RESERVATION r
	ON rd.IDMERE = r.ID
WHERE
	rd.idmere NOT IN (
	SELECT
		c.reservation
	FROM
		checkin c
	WHERE
		c.etat >= 11
		AND c.IDPRODUIT = rd.idproduit)
GROUP BY rd.IDMERE , rd.IDPRODUIT , rd.REMARQUE
;


--menus en ordre 

UPDATE MENUDYNAMIQUE
	SET  RANG=10
	WHERE ID='MENUP001V'; 
UPDATE MENUDYNAMIQUE x
	SET x.RANG=8
	WHERE x.ID='ELM001104001';
UPDATE MENUDYNAMIQUE x
	SET x.RANG=9
	WHERE x.ID='ELM001104004';
UPDATE MENUDYNAMIQUE x
	SET x.RANG=10
	WHERE x.ID='ELM001404001'; 
UPDATE MENUDYNAMIQUE x
	SET x.RANG=11
	WHERE x.ID='MNDN274';
UPDATE MENUDYNAMIQUE x
	SET x.RANG=12
	WHERE x.ID='MENUDYN002';
UPDATE MENUDYNAMIQUE x
	SET x.RANG=15
	WHERE x.ID='MENUP001V';
UPDATE MENUDYNAMIQUE x
	SET x.RANG=14
	WHERE x.ID='MENUDYN00304001';
UPDATE MENUDYNAMIQUE x
	SET x.RANG=16
	WHERE x.ID='ELM000011';
UPDATE MENUDYNAMIQUE x
	SET x.RANG=15
	WHERE x.ID='ELM000904001';
