create or replace view CHECKOUTAVECRESERVATION as
select c.RESERVATION ,o.id,o.DATY,o.ETAT,  o.HEURE,o.REMARQUE, o.RESERVATION as checkOut,
       case when o.ETAT = 1 then 'CREE'
            when o.ETAT = 11 then 'VALIDEE'
           end as etatlib
from CHECKOUT o left join CHECKIN c on c.id=o.RESERVATION;

-- ajout idreservation
create or replace view CHECKOUTLIB as
select
    ch."ID",ch."RESERVATION",ch."DATY",ch."HEURE",ch."REMARQUE",ch."ETAT",
    ci.PRODUITLIBELLE,
    case when ch.ETAT = 1 then 'CREE'
         when ch.ETAT = 11 then 'VALIDEE'
        END as etatlib,
    ci.RESERVATION as idreservation
from CHECKOUT ch
         join CHECKINLIBELLE ci on ci.ID = ch.RESERVATION;


-- ajout tva
create or replace view ST_INGREDIENTSAUTOSERVICE as
SELECT
    ai."ID",ai."LIBELLE",ai."SEUIL",ai."UNITE",ai."QUANTITEPARPACK",ai."PU",ai."ACTIF",ai."PHOTO",ai."CALORIE",ai."DURRE",ai."COMPOSE",ai."CATEGORIEINGREDIENT",ai."IDFOURNISSEUR",ai."DATY",ai."QTELIMITE",ai."PV",ai."LIBELLEVENTE",ai."SEUILMIN",ai."SEUILMAX",ai."PUACHATUSD",ai."PUACHATEURO",ai."PUACHATAUTREDEVISE",ai."PUVENTEUSD",ai."PUVENTEEURO",ai."PUVENTEAUTREDEVISE",ai."ISVENTE",ai."ISACHAT",ai."COMPTE_VENTE",ai."COMPTE_ACHAT",
    CASE
        WHEN ai.COMPTE_VENTE IS NOT NULL THEN ai.COMPTE_VENTE
        ELSE ai.COMPTE_ACHAT
        END AS compte,
    ai.TVA
FROM AS_INGREDIENTS ai where ai.pv>0
                         and CATEGORIEINGREDIENT='CAT002'