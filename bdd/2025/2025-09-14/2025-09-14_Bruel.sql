create or replace view MOUVEMENTCAISSE_VISE as
select ID,DESIGNATION,IDCAISSE,IDVENTEDETAIL,IDVIREMENT,DEBIT,CREDIT,DATY,ETAT,IDOP,IDORIGINE,IDDEVISE,TAUX,IDTIERS,COMPTE,IDPREVISION from MOUVEMENTCAISSE
WHERE ETAT=11
/

create or replace view v_etatcaisse as
SELECT  r.ID
     ,r.IDCAISSE
     ,c.val                                                                    AS idcaisseLib
     ,c.idtypecaisse
     ,tc.desce                                                                 AS idtypecaisselib
     ,c.idpoint
     ,p.desce                                                                  AS idpointlib
     ,r.DATY dateDernierReport
     ,CAST(NVL(((r.MONTANT+nvl(mvtAv.CREDIT-mvtAv.DEBIT,0))*taux.taux),0)                                          AS number(30,2)) montantDernierReport
     ,CAST(NVL(mvt.debit,0)                                                    AS number(30,2)) debit
     ,CAST(NVL(mvt.credit,0)                                                   AS number(30,2)) credit
     ,CAST((NVL(mvt.credit,0) + NVL((r.MONTANT+nvl(mvtAv.CREDIT-mvtAv.DEBIT,0))*taux.taux,0) - NVL(mvt.debit,0)) AS number(30,2)) reste
     ,'AR'                                                                     AS devise
FROM REPORTCAISSE_devise r,
    (
        SELECT  r.IDCAISSE
             ,MAX(r.DATY) maxDateReport
        FROM REPORTCAISSE_devise r
        WHERE r.ETAT = 11
          AND r.DATY <=TO_CHAR(SYSDATE, 'DD/MM/YYYY')
        GROUP BY  r.IDCAISSE
    ) rm, (
    SELECT  m.IDCAISSE
         ,SUM(nvl((m.DEBIT*t.taux),0)) DEBIT
         ,SUM(nvl((m.CREDIT*t.taux),0)) CREDIT
    FROM MOUVEMENTCAISSE_VISE m,
         (
             SELECT  r.IDCAISSE
                  ,MAX(r.DATY) maxDateReport
             FROM REPORTCAISSE r
             WHERE r.ETAT = 11
               AND r.DATY <= TO_CHAR(SYSDATE, 'DD/MM/YYYY')
             GROUP BY  r.IDCAISSE
         ) rm, (
             SELECT  ta.*
             FROM TAUXDECHANGE ta,
                  (
                      SELECT  MAX(daty) AS daty
                           ,iddevise
                      FROM TAUXDECHANGE t
                      WHERE daty <= TO_CHAR(SYSDATE, 'DD/MM/YYYY')
                      GROUP BY  iddevise
                  ) tmax
             WHERE ta.daty = tmax.daty
               AND ta.iddevise = tmax.iddevise ) t
    WHERE m.IDDEVISE = t.iddevise(+)
      AND m.IDCAISSE = rm.idcaisse(+)
      AND m.DATY >= TO_CHAR(SYSDATE, 'DD/MM/YYYY')
      AND m.DATY <= TO_CHAR(SYSDATE, 'DD/MM/YYYY')
    GROUP BY  m.IDCAISSE ) mvt
   ,(
    SELECT  m.IDCAISSE
         ,SUM(nvl((m.DEBIT*t.taux),0)) DEBIT
         ,SUM(nvl((m.CREDIT*t.taux),0)) CREDIT
    FROM MOUVEMENTCAISSE_VISE m,
         (
             SELECT  r.IDCAISSE
                  ,MAX(r.DATY) maxDateReport
             FROM REPORTCAISSE r
             WHERE r.ETAT = 11
               AND r.DATY <= TO_CHAR(SYSDATE, 'DD/MM/YYYY')
             GROUP BY  r.IDCAISSE
         ) rm, (
             SELECT  ta.*
             FROM TAUXDECHANGE ta,
                  (
                      SELECT  MAX(daty) AS daty
                           ,iddevise
                      FROM TAUXDECHANGE t
                      WHERE daty <= TO_CHAR(SYSDATE, 'DD/MM/YYYY')
                      GROUP BY  iddevise
                  ) tmax
             WHERE ta.daty = tmax.daty
               AND ta.iddevise = tmax.iddevise ) t
    WHERE m.IDDEVISE = t.iddevise(+)
      AND m.IDCAISSE = rm.idcaisse(+)
      AND m.DATY >= maxDateReport
      AND m.DATY < TO_CHAR(SYSDATE, 'DD/MM/YYYY')
    GROUP BY  m.IDCAISSE ) mvtAv
   ,(
    SELECT  ta.*
    FROM TAUXDECHANGE ta,
         (
             SELECT  MAX(daty) AS daty
                  ,iddevise
             FROM TAUXDECHANGE t
             WHERE daty <= TO_CHAR(SYSDATE, 'DD/MM/YYYY')
             GROUP BY  iddevise
         ) tmax
    WHERE ta.daty = tmax.daty
      AND ta.iddevise = tmax.iddevise ) taux, caisse c, typecaisse tc, point p
WHERE r.DATY = rm.maxDateReport
  AND r.IDDEVISE = taux.iddevise(+)
  AND r.ETAT = 11
  AND r.IDCAISSE = rm.IDCAISSE
  AND r.IDCAISSE = c.ID(+)
  AND r.IDCAISSE = mvt.idcaisse(+)
  AND r.IDCAISSE = mvtAv.idcaisse(+)
  AND c.IDTYPECAISSE = tc.ID(+)
  AND c.IDPOINT = p.ID;
