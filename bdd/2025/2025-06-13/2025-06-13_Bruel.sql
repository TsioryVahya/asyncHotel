create or replace view HISTORIQUEPVINGLIB as
select h.ID,
       h.DATY,
       h.PU            as puvente,
       h.REMARQUE,
       h.IDINGREDIENTS as idproduit,
       ai.LIBELLE      as idproduitlib
from HISTORIQUEPVING h
         left join AS_INGREDIENTS ai on ai.id = h.IDINGREDIENTS;