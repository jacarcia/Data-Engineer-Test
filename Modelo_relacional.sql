create table if not exists students(
    student_id int NOT NULL,                --id del estudiante
    student_name string NOT NULL,           --Nombre del estudiante
    student_surname string NOT NULL,        --Apellido del estudiante
    email string NOT NULL,                  --E-mail del estudiante
    age int,                                --Edad del estudiante
    join_date datetime                     --Fecha de alta de usuario
PRIMARY KEY (student_id)
);


CREATE TABLE IF NOT EXISTS subscriptions (
    sub_id INT NOT NULL,                    --id de la subscripcion
    student_id int NOT NULL,                --id del estudiante
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
    last_free_end datetime                  --Fecha fin cortesia (Asumo  fin de la ultima cortesia sa realizada si hubiera)

  PRIMARY KEY (sub_id)
);


CREATE TABLE IF NOT EXISTS classes (
  class_id INT NOT NULL,                    --ID de clase
  student_id INT NOT NULL,                  --ID del estudiante
  class_name string NOT NULL,               --Nombre de la clase
  class_desc string,                        --Descripcion de la clase    
  class_taken string NOT NULL,              --Bandera de clase tomada (Y/N)
  course_id INT NOT NULL,                   --Id del curso al que pertenece la clase (Asumo que hay clases que pueden pertenecer a distintos cursos)
  course_name string NOT NULL,              --Nombre del curso
  course_desc string,                       --Descripcion del curso
  course_classes INT,                       --Cantidad de clases que conforman el curso
  school_id INT NOT NULL,                   --Id de la escuela a ña que pertenece el curso (Asumo que hay cursos que pueden pertenecer a distintas escuelas)
  school_name string NOT NULL,              --Nombre de la escuela
  school_desc string,                       --Descripcion de la escuela
  school_courses INT                        --Cantidad de cursos que conforman la escuela

  PRIMARY KEY (class_id)
);

ALTER TABLE subscriptions ADD CONSTRAINT 1 FOREIGN KEY (student_id) REFERENCES students (student_id);

ALTER TABLE classes ADD CONSTRAINT 2 FOREIGN KEY (student_id) REFERENCES students (student_id);
