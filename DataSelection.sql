create table GPA_W_IDENTIFIERS as
select SZVGRDE_PIDM
      ,SZVGRDE_TERM_CODE
      ,SZVGRDE_SUBJ_CODE
      ,SZVGRDE_CRSE_NUMB
      ,SZVGRDE_CRN
      ,SZVGRDE_GRADE
      ,SZVGRDE_CREDIT
      ,SHRGRDE_QUALITY_POINTS
      ,SHRDGMR_ACYR_CODE
     -- ,SZVSECT_MTYP_CODE
  from SZVGRDE
      ,SHRGRDE
      ,SHRDGMR
      --,SSRMEET
      --,(select SHRDGMR1.SHRDGMR_PIDM pidm FROM SHRDGMR SHRDGMR1 where SHRDGMR1.SHRDGMR_DEGC_CODE = 'AB' and SHRDGMR1.SHRDGMR_LEVL_CODE = 'U') SHRDGMRB
 where 1=1
   --and SHRDGMRB.pidm (+) = SZVGRDE_PIDM
   --and SHRDGMR_DEGC_CODE = 'AB'
   and SHRDGMR_LEVL_CODE ='U'
   and SHRDGMR_PIDM (+) = SZVGRDE_PIDM 
   --and SZVGRDE_TERM_CODE = (EXTRACT(YEAR FROM SYSDATE)-5)||'01'
--   and SZVGRDE_PIDM = 50567891
   and SZVGRDE_GRADE = SHRGRDE_CODE
       and EXISTS (select 1 from SSRMEET WHERE SZVGRDE_TERM_CODE = SSRMEET_TERM_CODE
       and SZVGRDE_CRN = SSRMEET_CRN and SSRMEET_MTYP_CODE = 'CLAS')   
   and substr(SZVGRDE_TERM_CODE,1,4) <= to_char(SYSDATE,'YYYY')
   and SHRGRDE_GPA_IND = 'Y'
   and SHRGRDE_LEVL_CODE = 'U'
   
   and --SZVGRDE_SUBJ_CODE||'-'||SZVGRDE_CRSE_NUMB||'-'||
        SZVGRDE_CRN IN
      (select
               --SZVGRDE1.SZVGRDE_SUBJ_CODE ||'-'|| SZVGRDE1.SZVGRDE_CRSE_NUMB||'-'||
               SZVGRDE1.SZVGRDE_CRN 
          from SHRDGMR
              ,SZVGRDE SZVGRDE1
              ,SGBSTDN
         where SHRDGMR_PIDM = SZVGRDE1.SZVGRDE_PIDM
           and SZVGRDE1.SZVGRDE_PIDM = SGBSTDN_PIDM
    
           and SGBSTDN_LEVL_CODE ='U'
           and ((
                  SHRDGMR_DEGS_CODE in ('UA','UP','UX')
                 and SHRDGMR_DEGC_CODE = 'AB'
                 and SHRDGMR_LEVL_CODE ='U')
                or 
                (SGBSTDN.SGBSTDN_ACYR_CODE = to_char(SYSDATE,'YYYY') and
                  SGBSTDN.SGBSTDN_STST_CODE = 'AS')
               )
       )
       and SZVGRDE_TERM_CODE >= (to_char(SYSDATE,'YYYY')-4)||'02'
       AND SZVGRDE_TERM_CODE <= to_char(SYSDATE,'YYYY')||'02'
       
       ORDER BY SZVGRDE_PIDM
--SZVGRDE_SUBJ_CODE = :subj and SZVGRDE_CRSE_NUMB = :crse
--order by SZVGRDE_TERM_CODE, SZVGRDE_SUBJ_CODE, SZVGRDE_CRSE_NUMB, SZVGRDE_PIDM
; 