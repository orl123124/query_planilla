 
-------------------------------------------------------------------------
 select c3.process_level,round(sum(c3.op),3) from (
 select c2.empleado,c2.process_level, c2.salary_class,c2.rata,
        case c2.salary_class
          when 'S' then
            c2.rata/12
            when 'H' then
              c2.rata*208
              end as op
  from(
 select c1.empleado ,
        (select em.salary_class from employee em where em.employee=c1.empleado)salary_class
       ,(select   EM.PAY_RATE from employee em where em.employee=c1.empleado)as rata
       ,(select   EM.Process_Level from employee em where em.employee=c1.empleado) as process_level
 from (
       select distinct em.employee  as empleado
       FROM    
        LAWSON4.EMPLOYEE EM
        inner join PRCHECK CK on  ck.employee=em.employee
       where
          CK.CHECK_DATE>=trunc(to_date('04/01/2010','MM/DD/YYYY'))
       and CK.CHECK_DATE<trunc(to_date('04/16/2010','MM/DD/YYYY'))                     
       order by em.employee
    )c1
    )c2
    )c3
    group by c3.process_level
    order by c3.process_level asc
