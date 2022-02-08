--Suponiendo que nuestras tablas orígen están alojadas en una instancia de Azure DB o Azure SQL, para realizar el proceso de ETL, 
--podemos utilizar un script SQL y programarlo en el módulo de Data Factory con los trigger de recurrencia requeridos para que se ejecute la migración de los datos en las tablas de origen relacional y pasarlo a las tablas del modelo snowflake.

-- 1. refrescamos las tablas a consumir para tener la última versión de los datos
refresh table students;
refresh table subscriptions;
refresh table classes;

--2. Corremos las queries de inserción de datos en las tablas creadas previamente en el script 'Modelo_relacional.sql'
insert into table student_dim
    select distinct(
        s.student_id as student_id,  
        s.student_name as student_name
        s.student_surname as student_surname,
        s.email as email, 
        s.age as age,        
        s.join_date as join_date
    from students as S
    );

insert into table subscriptions_dim
    select distinct(
        sub.sub_id as sub_id,                
        sub.sub_type as sub_type,           
        sub.payment_method as payment_method,     
        sub.currency as currency,           
        sub.payment_date as payment_date,     
        sub.sub_status as sub_status,         
        sub.sub_start_date as sub_start_date,   
        sub.sub_end_date as sub_end_date,     
        sub.last_pause_start as last_pause_start,          
        sub.last_pause_end as last_pause_end,            
        sub.last_free_start as last_free_start,           
        sub.last_free_end as last_free_end             
    from subscriptions as sub
    );

insert into table student_school_facts
select(
    s.student_id as student_id,             
    sub.sub_id as sub_id,                   
    sub.sub_type as sub_type,              
    sub.sub_status as sub_status,            
    (select count(*) 
        from classes as C2 
        where C2.class_taken = 'Y' 
        and C2.student_id = S.student_id) 
    as classes_taken,                     
    (select count(*) 
        from classes as C3 
        where C3.class_taken = 'Y' 
        and C2.student_id = S.student_id
        group by C3.course_id 
        having count(C3.class_id) >= C3.course_classes )
    as courses_taken,                     
    school_id INT,                         
from students as S, subscriptions as sub, classes as C

);

insert into table  classes_dim 
    select distinct(
        C.class_id as class_id,                  
        C.class_name as class_name,              
        C.class_desc as class_desc,                       
        C.class_taken as class_taken,             
        C.course_id as course_id                 
 from classes as C
);

insert into table  courses_dim 
select distinct(
  C.course_id as course_id,             
  C.course_name as course_name,         
  C.course_desc as course_desc,         
  C.course_classes as course_classes,   
  C.school_id as school_id              
 from classes as C
);

insert into table school_dim 
select distinct(
  C.school_id as school_id,             
  C.school_name as school_name,         
  C.school_desc as school_desc,         
  C.school_courses as school_courses,   

  from classes as C
);

