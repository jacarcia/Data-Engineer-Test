create table if not exists student_school_facts(
    student_id int NOT NULL,                --id del estudiante
    sub_id INT NOT NULL,                    --id de la subscripcion
    sub_type string NOT NULL,               --tipo de subscripcion
    sub_status string NOT NULL,             --Estado de la sub: Activo, Pausa, Cortesia, Inactivo
    classes_taken INT,                      --Total de clases completadas por el estudiante
    courses_taken INT,                      --Total de cursos completados por el estuiante
    school_id INT,                          --Id de la escuela a ña que pertenece el curso
PRIMARY KEY (student_id)
);

create table if not exists student_dim(
    student_id int NOT NULL,                --id del estudiante
    student_name string NOT NULL,           --Nombre del estudiante
    student_surname string NOT NULL,        --Apellido del estudiante
    email string NOT NULL,                  --E-mail del estudiante
    age int,                                --Edad del estudiante
    join_date datetime,                     --Fecha de alta de usuario
PRIMARY KEY (student_id)
); 

CREATE TABLE IF NOT EXISTS subscriptions_dim (
    sub_id INT NOT NULL,                    --id de la subscripcion
    sub_type string NOT NULL,               --tipo de subscripcion
    payment_method string NOT NULL,         --forma de pago: recurrente y no recurrente (puede tener codificacion para casos hibridos)
    currency string NOT NULL,               --Moneda del pago
    payment_date datetime NOT NULL,         --Fecha del pago
    sub_status string NOT NULL,             --Estado de la sub: Activo, Pausa, Cortesia, Inactivo
    sub_start_date datetime NOT NULL,       --Fecha inicio Sub
    sub_end_date datetime NOT NULL,         --Fecha fin Sub (en caso de estar activa, fecha de renovacion)
    last_pause_start datetime,              --Fecha inicio pausa (Asumo  inicio de la ultima pausa realizada si hubiera)
    last_pause_end datetime,                --Fecha fin pausa (Asumo  fin de la ultima pausa realizada si hubiera)
    last_free_start datetime,               --Fecha inicio cortesia (Asumo  inicio de la ultima cortesia sa realizada si hubiera)
    last_free_end datetime,                 --Fecha fin cortesia (Asumo  fin de la ultima cortesia sa realizada si hubiera)

  PRIMARY KEY (sub_id)
);


CREATE TABLE IF NOT EXISTS classes_dim (
  class_id INT NOT NULL,                    --ID de clase
  class_name string NOT NULL,               --Nombre de la clase
  class_desc string,                        --Descripcion de la clase    
  class_taken string NOT NULL,              --Bandera de clase tomada (Y/N)
  course_id INT NOT NULL,                   --Id del curso al que pertenece la clase (Asumo que hay clases que pueden pertenecer a distintos cursos)
  PRIMARY KEY (class_id)
);

CREATE TABLE IF NOT EXISTS courses_dim (
  course_id INT NOT NULL,                   --Id del curso al que pertenece la clase (Asumo que hay clases que pueden pertenecer a distintos cursos)
  course_name string NOT NULL,              --Nombre del curso
  course_desc string,                       --Descripcion del curso
  course_classes INT,                       --Cantidad de clases que conforman el curso
  school_id INT NOT NULL,                   --Id de la escuela a ña que pertenece el curso (Asumo que hay cursos que pueden pertenecer a distintas escuelas)
  PRIMARY KEY (course_id)
);

CREATE TABLE IF NOT EXISTS school_dim (
  school_id INT NOT NULL,                   --Id de la escuela a ña que pertenece el curso (Asumo que hay cursos que pueden pertenecer a distintas escuelas)
  school_name string NOT NULL,              --Nombre de la escuela
  school_desc string,                       --Descripcion de la escuela
  school_courses INT,                       --Cantidad de cursos que conforman la escuela

  PRIMARY KEY (school_id)
);


ALTER TABLE student_school_facts ADD CONSTRAINT 1 FOREIGN KEY (student_id) REFERENCES student_dim (student_id);

ALTER TABLE student_school_facts ADD CONSTRAINT 2 FOREIGN KEY (sub_id) REFERENCES subscriptions_dim (sub_id);

ALTER TABLE courses_dim ADD CONSTRAINT 3 FOREIGN KEY (course_id) REFERENCES classes_dim (course_id);

ALTER TABLE school_dim ADD CONSTRAINT 4 FOREIGN KEY (school_id) REFERENCES courses_dim (school_id);

ALTER TABLE student_school_facts ADD CONSTRAINT 5 FOREIGN KEY (school_id) REFERENCES school_dim (school_id);
