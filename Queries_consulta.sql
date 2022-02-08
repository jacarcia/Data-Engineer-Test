--Estudiantes nuevos por semana (se debe ejecutar semanalmente)

select count(*)
from subscriptions
where sub_start_date >= NOW() - INTERVAL 7 DAYS

--Estudiantes nuevos por mes (se debe ejecutar mensualmente)

select count(*)
from subscriptions
where sub_start_date >= NOW() - INTERVAL 1 MONTH

--Cursos tomados por un estudiante 'TEST' con 80% de clases vistas

select count(course_id)
from classes
where student_id = 'TEST'
and class_taken = 'Y'
group by course_id 
having count(class_id) * 100.0 / (select count(*) from clases) >= course_classes*0.80

--Consulta por pausas o consultas para un estudiante 'TEST'

select 
case 
    when last_pause_start IS NOT NULL
        THEN 'Hubo Pausas'
        else 'No hubo pausas'
    end as status_pausa,
case 
    when last_free_start IS NOT NULL
        THEN 'Hubo Cortesia'
        else 'No hubo Cortesia'
    end as status_cortesia
from subscriptions
where student_id = 'TEST'