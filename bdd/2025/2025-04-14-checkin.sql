CREATE OR REPLACE VIEW "ASYNCHOTEL"."RESERVATIONDETSANSCI" ("ID",
"IDMERE",
"IDPRODUIT",
"QTE",
"DATY",
"PU",
"REMARQUE",
"ETAT",
"IDCLIENT") AS
SELECT
	rd."ID",
	rd."IDMERE",
	rd."IDPRODUIT",
	rd."QTE",
	rd."DATY",
	rd."PU",
	rd."REMARQUE",
	rd."ETAT",
	r."IDCLIENT"
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
		AND c.IDPRODUIT = rd.idproduit);
