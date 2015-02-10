--SP QUE MUESTRA LOS EMPLEADOS QUE SE AUSENTARON UN DIA FERIADO/NACIONAL Y TENIAN QUE TRABAJAR  
  select H.EMPLEADO, h.horas_regulares  
                    from smw.smw_horascalculadas h
                    where h.tipo_dia='F' 
                    and h.horas_regulares< 1 and h.codigo_hjornada !='000'                      
                                and exists(
                                select 'true' 
                                from smw.smw_horasjornada j 
                                where j.codigo=h.codigo_hjornada and j.estatus !='I'
                                )
                     
                    and  h.fecha_marcacion between to_date('12/01/2014','mm/dd/yyyy')
                    and  to_date('12/31/2014','mm/dd/yyyy')
                    and h.empresa=10-- b.empresa
                   -- and h.empleado=b.emp
