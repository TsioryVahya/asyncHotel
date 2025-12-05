-- Max date reservation izay zokony indrindra
create or replace view reservationdetailsmaxdate as
SELECT *
FROM (
    SELECT r.*,
           ROW_NUMBER() OVER (PARTITION BY IDMERE ORDER BY daty DESC) AS rn
    FROM RESERVATIONDETAILS r
)
WHERE rn = 1;

-- reservation lib efa miaraka amle date max anzay fille ao
create or replace view reservation_lib_avecmaxdate as
select rl.*, rdmd.DATY as DATYFINPOTENTIEL
from RESERVATION_LIB rl
         left join RESERVATIONDETAILSMAXDATE rdmd on rl.id = rdmd.IDMERE;
