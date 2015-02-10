--cambio final 01-03-2015
--CUADRO COMPARATTIVO DE MARCACIONES Y HORAS TRABAJADAS POR EMPRESA Y FECHA
 select * from 
 (
  select 
  hc.empresa,
(  select r_name from prsystem ps where trim(ps.process_level)=hc.empresa) as empresa_nombre,
  hc.empleado,
  ( select  trim(e.first_name)  ||' '||trim(e.last_name) 
  from employee e 
  where e.employee=hc.empleado)as nombre,
  ( select e.department 
  from employee e 
  where e.employee=hc.empleado)as departamento,
  hc.fecha_marcacion,
 CASE WHEN   hc.hora_entrada1 IS NULL OR  hc.minuto_entrada1 IS NULL THEN
   NULL
   ELSE
   to_char( to_date( lpad(  hc.hora_entrada1 ,2,'0') ||':' || lpad(  hc.minuto_entrada1,2,'0') ,'hh24:mi'),'hh:mi p.m.' ) 
 END ENTRADA1,    
 CASE WHEN   hc.hora_salida1 IS NULL OR  hc.minuto_salida1 IS NULL THEN
   NULL
   ELSE
   to_char( to_date( lpad(  hc.hora_salida1 ,2,'0') ||':' || lpad(  hc.minuto_salida1,2,'0') ,'hh24:mi'),'hh:mi p.m.' )       
 END SALIDA1,
 CASE WHEN   hc.hora_entrada2 IS NULL OR  hc.minuto_entrada2 IS NULL THEN
   NULL
   ELSE
   to_char( to_date( lpad(  hc.hora_entrada2 ,2,'0') ||':' || lpad(  hc.minuto_entrada2,2,'0') ,'hh24:mi'),'hh:mi p.m.' )            
 END ENTRADA2,
 CASE WHEN   hc.hora_salida2 IS NULL OR  hc.minuto_salida2 IS NULL THEN
   NULL
   ELSE
   to_char( to_date( lpad(  hc.hora_salida2 ,2,'0') ||':' || lpad(  hc.minuto_salida2,2,'0') ,'hh24:mi'),'hh:mi p.m.' )            
 END SALIDA2,
 hc.tipo_dia,  
 decode (  hc.num_dia ,1,'DO'
                      ,2,'LU'
                      ,3,'MA'
                      ,4,'MI'
                      ,5,'JU'
                      ,6,'VI'
                      ,7,'SA'  )as Dia, 
  j.turno,j.codigo
  from smw_horascalculadas hc
  inner join smw_horasjornada j on j.codigo=hc.codigo_hjornada and j.estatus='A'  
 where
     --hc.empleado=19834 and 
       hc.empresa=67 and (select  j.job_class
                                  from employee e inner join jobcode j on e.job_code=j.job_code
                                  where e.employee=hc.empleado)<3 
     and hc.fecha_marcacion between to_date('12/01/2014','mm/dd/yyyy')
     and to_date('12/31/2014','mm/dd/yyyy')     
    -- order by hc.fecha_marcacion
)sub_hcal,
( 
      select 
      distinct  marc.fecha_m  , 
      marc.empresa as empresa_m,
      marc.empleado as empleado_m,
      max(decode(marc.grupo, 1,marcacion   )  ) as marcacion_1,
      max(decode(marc.grupo, 2,marcacion   )  ) as marcacion_2,
      max(decode(marc.grupo, 3,marcacion  )  ) as marcacion_3,
      max(decode(marc.grupo, 4,marcacion  )  ) as marcacion_4,
      max(decode(marc.grupo, 5,marcacion  )  ) as marcacion_5,
      max(decode(marc.grupo, 6,marcacion  )  ) as marcacion_6,
      max(decode(marc.grupo, 7,marcacion  )  ) as marcacion_7,
      max(decode(marc.grupo, 8,marcacion  )  ) as marcacion_8,
      max(decode(marc.grupo, 9,marcacion  )  ) as marcacion_9,
      max(decode(marc.grupo, 10,marcacion  )  ) as marcacion_10
      from (
        select 
        m.empresa,m.empleado,to_date(to_char(m.fecha_marcacion,'mm/dd/yyyy') ,'mm/dd/yyyy')as fecha_m ,
        case when m.hora is  null and m.minuto is   null then
          null
          else
             to_char( to_date( lpad(  m.hora ,2,'0') ||':' || lpad(  m.minuto,2,'0') ,'hh24:mi'),'hh:mi p.m.' )            
            end marcacion,
          
        row_number()
        over 
        ( partition by m.empresa, m.empleado,m.mes,m.dia,m.ano
        order by m.hora ) as grupo
        from smw_marcaciones m 
        where 
       -- m.empleado=19834 and
         m.empresa=67 and 
         (select  j.job_class
                                  from employee e inner join jobcode j on e.job_code=j.job_code
                                  where e.employee=m.empleado)<3
        and m.fecha_marcacion between to_date('12/01/2014','mm/dd/yyyy')
        and to_date('12/31/2014','mm/dd/yyyy')
        --order by m.fecha_marcacion
        )marc
      group by marc.fecha_m ,marc.empresa, marc.empleado
  --  order by marc.fecha_m  
  )sub_marc
where sub_marc.fecha_m(+) = sub_hcal.fecha_marcacion
      and sub_marc.empresa_m(+) = sub_hcal.empresa
      and sub_marc.empleado_m(+)=sub_hcal.empleado
  
 ORDER BY  sub_hcal.empleado,sub_hcal.fecha_marcacion;
