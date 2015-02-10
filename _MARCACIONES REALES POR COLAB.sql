 
 
select 
 distinct  marc.fecha_marcacion , 
 marc.empresa,
 marc.empleado,
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
      m.empresa,m.empleado,to_char(m.fecha_marcacion,'mm/dd/yyyy') as fecha_marcacion,
      case when m.hora is  null and m.minuto is   null then
        null
        else
           to_char( to_date( lpad(  m.hora ,2,'0') ||':' || lpad(  m.minuto,2,'0') ,'hh24:mi'),'hh:mi p.m.' )            
          end marcacion,
        
      row_number()
      over 
      ( partition by m.empleado,m.mes,m.dia,m.ano
      order by m.hora ) as grupo
       from smw_marcaciones m 

      where 
       m.empleado=19834
      and m.empresa=69
      and m.fecha_marcacion between to_date('05/01/2014','mm/dd/yyyy')
      and to_date('05/15/2014','mm/dd/yyyy')
      order by m.fecha_marcacion
      )marc
group by marc.fecha_marcacion ,marc.empresa, marc.empleado
order by marc.fecha_marcacion  
     
