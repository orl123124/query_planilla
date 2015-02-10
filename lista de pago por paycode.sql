
select 
      PRSYSTEM.R_NAME,  
      PRTIME.Process_Level as PROCESS_LEV,  
      PRPAYCODE.PAY_CODE, 
      PRTIME.PAY_SUM_GRP, 
      PRPAYCODE.DESCRIPTION,
      sum(PRTIME.WAGE_AMOUNT) AS extra ,
      colt.total as totales_por_process_level, 
      colt.PROCESS_LEV as pl
FROM   
    LAWSON4.PRPAYCODE PRPAYCODE
    inner join LAWSON4.PRTIME PRTIME on PRPAYCODE.SEQ_NBR=PRTIME.PCD_SEQ_NBR and PRPAYCODE.COMPANY=PRTIME.COMPANY 
    inner join LAWSON4.EMPLOYEE EMPLOYEE on EMPLOYEE.EMPLOYEE=PRTIME.EMPLOYEE and EMPLOYEE.COMPANY=PRTIME.COMPANY
    inner join LAWSON4.PRCHECK PRCHECK on PRCHECK.CHECK_ID =PRTIME.CHECK_ID and PRTIME.COMPANY=PRCHECK.COMPANY 
    inner join LAWSON4.PRSYSTEM PRSYSTEM on PRTIME.PROCESS_LEVEL=PRSYSTEM.PROCESS_LEVEL and PRSYSTEM.COMPANY =PRTIME.COMPANY
    ,
(       select   
        PRTIME.Process_Level as  PROCESS_LEV, 
        sum(PRTIME.WAGE_AMOUNT) AS total    
        FROM   
        LAWSON4.PRTIME PRTIME 
        inner join LAWSON4.PRCHECK PRCHECK on PRCHECK.CHECK_ID =PRTIME.CHECK_ID and PRTIME.COMPANY=PRCHECK.COMPANY
        WHERE   
        (PRCHECK.CHECK_DATE>=trunc(to_date('04/01/2010'/*fi*/,'MM/DD/YYYY'))
        and  PRCHECK.CHECK_DATE<trunc(to_date('04/16/2010'/*ff*/,'MM/DD/YYYY')))
       -- and prtime.process_level =36    
        and prtime.process_level = prcheck.process_level
        group by  PRTIME.Process_Level
)colt
WHERE   
--prtime.process_level =36 and
   prtime.process_level = colt.PROCESS_LEV and
 (PRCHECK.CHECK_DATE>=trunc(to_date('04/01/2010','MM/DD/YYYY'))
      and  PRCHECK.CHECK_DATE<trunc(to_date('04/16/2010','MM/DD/YYYY')))
group by  PRTIME.Process_Level,
          PRPAYCODE.PAY_CODE, 
          PRTIME.PAY_SUM_GRP,
          PRPAYCODE.DESCRIPTION,
          PRSYSTEM.R_NAME,
          colt.total,
          colt.PROCESS_LEV
    order by  PRPAYCODE.PAY_CODE   desc  
          
 
