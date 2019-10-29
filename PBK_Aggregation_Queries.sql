--------------------------------------------------------------
----FROM ACCESS

select allscores.* from 

          (select 
          nn.STU_ID
          ,SUM((nn.zscore)*(nn.UNITS))/SUM(nn.UNITS) weighted_avg_zscore
          ,AVG(nn.zscore)
          --,nn.EXP_GRAD_YEAR
          ,SUM(nn.UNITS)
          from
          
                    (select n.STU_ID
                     ,CASE 
                        WHEN (stddev(n.GRADE_POINTS)OVER(PARTITION BY n.INSTR_ID, n.CRSE_ID)) = 0 THEN 0
                        ELSE
                        (   (n.GRADE_POINTS - AVG(n.GRADE_POINTS) OVER(PARTITION BY n.INSTR_ID, n.CRSE_ID))/(stddev(n.GRADE_POINTS)OVER(PARTITION BY n.INSTR_ID, n.CRSE_ID))   )
                  END zscore
                  
                  ,n.UNITS
                  ,n.GRADE_POINTS
                  ,n.EXP_GRAD_YEAR
                  from SALMEIDA.IMPORTED_GPAS n) nn
                  WHERE nn.zscore <> 0
                  group by nn.STU_ID
                  HAVING sum(nn.UNITS) > 64) allscores


WHERE allscores.STU_ID in 
                      (select STU_ID
                        from SALMEIDA.IMPORTED_GPAS
                        WHERE EXP_GRAD_YEAR = 2020)

;



---------------------------------------------------------------------------------
---MINE
select allscores.* from 

(select 
nn.SZVGRDE_PIDM
,CASE WHEN SUM(nn.SZVGRDE_CREDIT) = 0 THEN 0 ELSE SUM((nn.zscore)*(nn.SZVGRDE_CREDIT))/SUM(nn.SZVGRDE_CREDIT)
END weighted_avg_zscore
,AVG(nn.zscore)
--,nn.EXP_GRAD_YEAR
,SUM(nn.SZVGRDE_CREDIT)
from 

            (select n.SZVGRDE_PIDM
            ,CASE 
                  WHEN (stddev(n.SHRGRDE_QUALITY_POINTS)OVER(PARTITION BY n.SZVGRDE_SUBJ_CODE, n.SZVGRDE_CRSE_NUMB)) = 0 THEN 0
                  ELSE
                  (   (n.SHRGRDE_QUALITY_POINTS - AVG(n.SHRGRDE_QUALITY_POINTS) OVER(PARTITION BY n.SZVGRDE_SUBJ_CODE, n.SZVGRDE_CRSE_NUMB))/(stddev(n.SHRGRDE_QUALITY_POINTS)OVER(PARTITION BY n.SZVGRDE_SUBJ_CODE, n.SZVGRDE_CRSE_NUMB))   )
            END zscore
            ,n.SZVGRDE_CREDIT
            ,n.SHRDGMR_ACYR_CODE
            from ITS_SBROWN2.GPA_W_IDENTIFIERS n) nn
            group by nn.SZVGRDE_PIDM
            HAVING SUM(nn.SZVGRDE_CREDIT) > 64) allscores


WHERE allscores.SZVGRDE_PIDM in 
                      (select SZVGRDE_PIDM
                        from ITS_SBROWN2.GPA_W_IDENTIFIERS
                        WHERE SHRDGMR_ACYR_CODE = 2020)
;





(select *
from ITS_SBROWN2.GPA_W_IDENTIFIERS);
--WHERE SHRDGMR_ACYR_CODE = 2020);

-------------COMPUTE ON NON ZERO ZSCORES------------------------
select 
          nn.STU_ID
          ,SUM((nn.zscore)*(nn.UNITS))/SUM(nn.UNITS) weighted_avg_zscore
          ,AVG(nn.zscore)
          --,nn.EXP_GRAD_YEAR
          ,SUM(nn.UNITS)
          from
          
                    (select n.STU_ID
                     ,CASE 
                        WHEN (stddev(n.GRADE_POINTS)OVER(PARTITION BY n.INSTR_ID, n.CRSE_ID)) = 0 THEN 0
                        ELSE
                        (   (n.GRADE_POINTS - AVG(n.GRADE_POINTS) OVER(PARTITION BY n.INSTR_ID, n.CRSE_ID))/(stddev(n.GRADE_POINTS)OVER(PARTITION BY n.INSTR_ID, n.CRSE_ID))   )
                  END zscore
                  
                  ,n.UNITS
                  ,n.GRADE_POINTS
                  ,n.EXP_GRAD_YEAR
                  from SALMEIDA.IMPORTED_GPAS n) nn
                  WHERE nn.zscore <> 0
                  group by nn.STU_ID;
            

--------------SELECT ALL SCORES EXCEPT 0 ZSCORES---------------
select * from (select n.STU_ID
            ,CASE 
                  WHEN (stddev(n.GRADE_POINTS)OVER(PARTITION BY n.INSTR_ID, n.CRSE_ID)) = 0 THEN 0
                  ELSE
                  (   (n.GRADE_POINTS - AVG(n.GRADE_POINTS) OVER(PARTITION BY n.INSTR_ID, n.CRSE_ID))/(stddev(n.GRADE_POINTS)OVER(PARTITION BY n.INSTR_ID, n.CRSE_ID))   )
            END zscore
            
            ,n.UNITS
            ,n.GRADE_POINTS
            ,n.EXP_GRAD_YEAR
            from SALMEIDA.IMPORTED_GPAS n) n1
            WHERE n1.zscore <> 0;













----------------FIND ZSCORES-------------------
--select AVG(this.zscore) from 
(select n.STU_ID
            ,CASE 
                  WHEN (stddev(n.GRADE_POINTS)OVER(PARTITION BY n.INSTR_ID, n.CRSE_ID)) = 0 THEN 0
                  ELSE
                  (   (n.GRADE_POINTS - AVG(n.GRADE_POINTS) OVER(PARTITION BY n.INSTR_ID, n.CRSE_ID))/(stddev(n.GRADE_POINTS)OVER(PARTITION BY n.INSTR_ID, n.CRSE_ID))   )
            END zscore
            
            ,n.UNITS
            ,n.GRADE_POINTS
            ,n.EXP_GRAD_YEAR
            from SALMEIDA.IMPORTED_GPAS n); 
            --WHERE this.STU_ID = 50650819;
