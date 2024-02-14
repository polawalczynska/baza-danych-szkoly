use schoolDB;

delete from administration_employees where true;
delete from student_marks where true;
delete from course_marks_categories where true;
delete from student_presence where true;
delete from lessons where true;
delete from timetable where true;
delete from lessons_schedule where true;
delete from classrooms where true;
delete from students_attending_courses where true;
delete from class_courses where true;
delete from courses where true;
delete from subjects where true;
delete from classroom_roles where true;
delete from students where true;
delete from class where true;
delete from teachers where true;
delete from parents where true;
delete from people where true;

alter table administration_employees
    auto_increment = 1;
alter table classroom_roles
    auto_increment = 1;
alter table parents
    auto_increment = 1;
alter table students
    auto_increment = 1;
alter table teachers
    auto_increment = 1;
alter table subjects
    auto_increment = 1;
alter table courses
    auto_increment = 1;
alter table students_attending_courses
    auto_increment = 1;
alter table lessons
    auto_increment = 1;
alter table student_marks
    auto_increment = 1;
alter table people
    auto_increment = 1;

INSERT INTO people (name, surname, pesel, sex, birthday)
VALUES ('Jerzy', 'Kowalski', '75201568431', 'm', '1980-10-12'),
       ('Anna', 'Kowalska', '75287568431', 'k', '1980-10-12'),
       ('Anna', 'Nowak', '75201008431', 'k', '1980-10-12'),
       ('Marian', 'Sielanka', '73201568431', 'm', '1980-10-12'),
       ('Zygmunt', 'Ptak', '75201568031', 'm', '1980-10-12'),
       ('Vlad', 'Kowalski', '02201568431', 'm', '1980-10-12'),
       ('Miroslaw', 'Ptak', '02201532431', 'm', '1980-10-12'),
       ('Bob', 'Borsuk', '71520538431', 'm', '1980-10-12'),
       ('Aneta', 'Zalewska', '98220147492', 'k', '1980-10-12'),
       ('Maria', 'Milkowska', '91220147192', 'k', '1991-02-11'),
       ('Zygmunt', 'Czyscioch', '70173016310', 'm', '1970-12-22'),
       ('Aneta', 'Brudna', '80205639163', 'k', '1980-10-12');

INSERT INTO parents (id, adress_street, adress_city, adress_postal_code, phone_number)
VALUES (1, 'ul. Polska 3', 'Krakow', '12-345', '123456789'),
       (2, 'ul. Norymberska 21', 'Warszawa', '33-333', '987333321'),
       (3, 'ul. Katalonska 6', 'Warszawa', '33-333', '987654321'),
       (4, 'ul. Pikolska 91', 'Warszawa', '33-333', '494798254'),
       (5, 'ul. Lipska 6', 'Warszawa', '33-333', '987564991');

insert into teachers (id, adress_street, adress_city, adress_postal_code, phone_number, salary)
values (8, 'ul. Lipska 68', 'Warszawa', '33-333', '987966991', 6300.00),
       (9, 'ul. Mazowiecka 68', 'Warszawa', '33-333', '987968991', 5800.00);

insert into class (year, symbol, admin_teacher_id, specialization)
values (1, 'a', 8, 'm'),
       (1, 'b', 9, 's'),
       (0, 'a', 8, 'm'),
       (0, 'b', 9, 's'),
       (0, 'c', 9, 'p');

insert into students (id, first_parent_id, second_parent_id, class_year, class_symbol)
values (6, 1, 2, 1, 'a'),
       (7, 5, null, 1, 'b');

insert into classroom_roles (description)
values ('brak specialnej roli'),
       ('sala gimnastyczna'),
       ('pracownia informatyczna'),
       ('pracownia chemiczna'),
       ('pracownia fizyczna');

insert into subjects(name, required_classroom_type)
values ('matematyka', 1),
       ('fizyka', 5);

insert into courses(teacher_id, subject_id)
values (8, 1),
       (8, 2),
       (9, 2);

insert into class_courses (class_year, class_symbol, course_id)
values (1, 'a', 1),
       (1, 'a', 2),
       (1, 'b', 3);

insert into classrooms (id, capacity, has_projector, special_role_id, last_renovation)
values (27, 30, 1, 3, '2018-08-01'),
       (108, 100, 0, 1, '2010-04-01'),
       (50, 35, 0, 5, '2005-01-01');

insert into lessons_schedule (week_day, lesson_num, start_time, end_time)
values (1, 1, '8:00:00', '8:45:00'),
       (1, 2, '8:55:00', '9:40:00');

insert into timetable(id_lessons_schedules,id_of_course, id_of_classroom)
values (1, 1, 108),
       (1, 3, 50),
       (2, 2, 50);

insert into lessons(timetable_id, lesson_date)
values (3, '2012-12-2 8:00:00'),
       (1, '2012-12-5 9:40:00'),
       (1, '2012-12-7 8:00:00'),
       (2, '2023-02-01 13:30:00');

insert into course_marks_categories (course_id, description, weight)
values (1, 'sprawdzian - trygonometria', 3),
       (2, 'kartkowka - hydrostatyka', 2),
       (1, 'aktywnosc', 1);

insert into student_marks(mark_category, id_of_student, mark)
values (1, 6, 4),
       (2, 6, 6),
       (3, 6, 5);

insert into student_presence(id_of_lesson, id_of_student, was_absent)
values (1, 7, false),
       (2, 6, false),
       (3, 6, true),
       (4, 6, false);

insert into administration_employees (id, adress_street, adress_city, adress_postal_code, phone_number, role, salary)
values (10, 'ul. Katalonska 6', 'Warszawa', '33-333', '987654321', 'pracowniczka sekretariatu', 4050.00),
       (11, 'ul. Katalonska 6', 'Warszawa', '33-333', '987654621', 'wozny', 2700.00),
       (12, 'ul. Katalonska 6', 'Warszawa', '33-333', '986654321', 'sprzataczka', 2700.00);

insert into people (name, surname, pesel, sex, birthday)
values ('Marek', 'Ryba', '02738123481', 'm', '2002-06-25'),
       ('Anna', 'Kandydacka', '02759823481', 'k', '2002-08-10'),
       ('Marcin', 'Sredni-Kandydat', '02738893481', 'm', '2002-06-25'),
       ('Maciej', 'Geniusz', '02738698481', 'm', '2002-09-25'),
       ('Mikolaj', 'Matejko', '02738698621', 'm', '2002-09-25'), -- 17
       ('Joanna', 'Paczesniak', '02739108481', 'k', '2002-09-25'),
       ('Lukasz', 'Mickiewicz', '02738646881', 'm', '2002-09-25'),
       ('Marzena', 'Nowicka', '02908698481', 'k', '2002-09-25'),
       ('Jakub', 'Iwanecki', '02738698881', 'm', '2002-09-25');

insert into students (id, first_parent_id, second_parent_id, class_year, class_symbol)
values (13, null, null, 1, 'a');

insert into candidates (id, pl_exam_result, math_exam_result, science_exam_result, extracurricular_act, chosen_class_symbol, filling_date)
values  (14, 85, 57, 90, false, 'm', '2022-08-01'),
        (15, 50, 50, 50, false, 'm', '2022-08-02'),
        (16, 10, 80, 90, false, 'm', '2022-08-02'),
        (17, 90, 80, 20, true, 'm', '2022-08-02'),
        (18, 80, 95, 95, false, 'm', '2022-08-03'),
        (19, 84, 95, 95, true, 'm', '2022-08-02'),
        (20, 10, 70, 90, true, 's', '2022-08-02'),
        (21, 60, 50, 90, false, 's', '2022-08-02');

insert into lessons (timetable_id, lesson_date)
values (1, '2023-04-01');

insert into vacations (employee_id, vacation_start, vacation_end)
values (8, '2022-12-31', null);
#
# update vacations
# set vacation_end = '2022-12-31'
# where employee_id = 8;
#
# update lessons
# set lesson_date = '2022-12-31'
# where lesson_date = '2023-04-01';

insert into product_category (id, name, profit_margin)
values (1, 'napoje', 10),
       (2, 'przekaski', 25),
       (3, 'inne', 30);

insert into school_shop (name, category, quantity, bulk_price)
values ('drozdzowka', 2, 30, 2.00),
       ('pizzerka', 2, 10, 3.50),
       ('woda', 1, 40, 1.50),
       ('chrupki kukurydziane', 2, 15, 4.00),
       ('sok jablkowy', 1, 10, 3.00),
       ('chusteczki', 3, 25, 1.80);

insert into scholarship_details (id, name, amount, payment_frequency)
values (1, 'Stypendium starosty', 150, 'm'),
       (2, 'Stypendium unijne', 2000, 's');


insert into scholarship_grants (id_of_student, id_of_scholarship)
values (6, 1),
       (7, 1),
       (7, 2);

insert into transactions (item_id, quantity)
values (3, 1),
       (1, 10),
       (4, 12);

insert into student_marks(mark_category, id_of_student, mark)
values (1, 13, 4),
       (2, 13, 4);
