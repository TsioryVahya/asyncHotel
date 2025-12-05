create or replace view ReservationDetailsAvecMere as
select rd.id,ing.id as IDPRODUIT,rd.qte,rd.daty,r.IDCLIENT,r.ETAT as etat,c.nom||' '||c.TELEPHONE as libelleclient ,rd.IDMERE,ing.LIBELLE as libelleproduit from AS_INGREDIENTS ing
    join reservationDetails rd on rd.idproduit=ing.ID
    left join reservation r on r.id=rd.IDMERE
left join CLIENT c on c.id=r.IDCLIENT;