-- creation checkoutlib
create or replace view checkoutlib as
select
    ch.*,
    ci.PRODUITLIBELLE,
    case when ch.ETAT = 1 then 'CREE'
         when ch.ETAT = 11 then 'VALIDEE'
        END as etatlib
from CHECKOUT ch
         join CHECKINLIBELLE ci on ci.ID = ch.RESERVATION;


-- creation view vide reservationSimple
create or replace view RESERVATIONSIMPLE as
select
    rs.*,
    rsdt.IDPRODUIT,
    rsdt.QTE
from RESERVATION rs
         join RESERVATIONDETAILS rsdt on rs.ID = rsdt.IDMERE
where 1> 2;