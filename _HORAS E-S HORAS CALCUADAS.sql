 select 
 hc.empresa,
 hc.empleado,
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
     END ENTRADA2,
  hc.tipo_dia,  
    decode (  hc.num_dia,1,'DO'
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
      hc.empleado=19834
     and hc.empresa=69
     and hc.fecha_marcacion between to_date('05/01/2014','mm/dd/yyyy')
     and to_date('05/15/2014','mm/dd/yyyy')     
     order by hc.fecha_marcacion
  
