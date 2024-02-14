drop database if exists schoolDB;
create database if not exists schoolDB;
use schoolDB;

delimiter //


create table people(
    id               int            primary key auto_increment,
    name             varchar(32)    not null,
    surname          varchar(32)    not null,
    pesel            varchar(11)    unique,
        check (pesel like '___________'), -- sprawdzenie czy pesel ma 11 cyfr
    sex              char           not null check (sex in ('k', 'm')),
    birthday         date           not null
);

-- tabela przechowujaca informacje o rodzicach uczniow
create table parents(
    id                 int              not null primary key,
    adress_street      varchar(128),
    adress_city        varchar(128),
    adress_postal_code varchar(6),
    phone_number       varchar(9)       unique,
    email              varchar(64),
        check (email like '%@%'),

    foreign key (id) references people(id)
);

create table teachers(
    id                 int              not null primary key,
    adress_street      varchar(128),
    adress_city        varchar(128),
    adress_postal_code varchar(6),
    phone_number       varchar(9)       unique,
    email              varchar(64),
        check (email like '%@%'),
    salary             decimal(10, 2),

    foreign key (id) references people(id)
);

create table class(
    year                int     not null
        check (year between 0 and 4),
    symbol              char    not null,
    admin_teacher_id    int     not null,
    specialization      char    not null,
    check (specialization in ('p', 'm', 's')), -- profil klasy p - polski, m - matematyka, s - science/biol-chem
    foreign key (admin_teacher_id) references teachers(id),

    primary key (year, symbol)
);

-- tabela przechowujaca informacje o uczniach
create table students(
    id                  int     not null primary key,
    first_parent_id     int,
    second_parent_id    int,
    class_year          int     not null,
    class_symbol        char    not null,

    foreign key (class_year, class_symbol)  references  class(year, symbol),
    foreign key (first_parent_id)           references  parents (id),
    foreign key (second_parent_id)          references  parents (id),
    foreign key (id)                        references  people(id)
);

-- tabela przechowujaca informacje o kandydatach
create table candidates(
    id                      int         not null primary key,
    pl_exam_result          int         default 0, -- procentowy wynik egzaminu z polskiego
    math_exam_result        int         default 0,
    science_exam_result     int         default 0,
    extracurricular_act     int         default false, -- czy ma jakies pozaszkolne aktywnosci - wolontariat na przyklad
    chosen_class_symbol     char        default null,
    filling_date            datetime,

    check (pl_exam_result between 0 and 100),
    check (math_exam_result between 0 and 100),
    check (extracurricular_act  between 0 and 100),
    foreign key (id) references people(id)
);

-- tabela przechowujaca informacje o pracownikach innych niz nauczyciele
create table administration_employees(
    id                 int              not null primary key,
    adress_street      varchar(128),
    adress_city        varchar(128),
    adress_postal_code varchar(6),
    phone_number       varchar(9)       unique,
    salary             decimal(10, 2),
    role               varchar(128),

    foreign key (id) references people(id)
);

-- tabela przechowujaca specialne role sal lekcyjnych
create table classroom_roles(
    id              int not null primary key auto_increment,
    description     varchar(256)
);

-- reprezentacja ogolnego przedmiotu
create table subjects(
    id                      int             not null primary key auto_increment,
    name                    varchar(32)     not null,
    description             varchar(255),
    required_classroom_type int not null,
    foreign key (required_classroom_type) references classroom_roles(id)
);

-- na przyklad jezyk polski z krzystofem k.
create table courses(
    id              int     not null primary key auto_increment,
    teacher_id      int     not null,
    subject_id      int     not null,

    foreign key (teacher_id) references teachers (id),
    foreign key (subject_id) references subjects (id)
);

create table class_courses(
    class_year      int     not null,
    class_symbol    char    not null,
    course_id       int     not null,
    foreign key (class_year, class_symbol) references class(year, symbol),
    foreign key (course_id) references courses(id),
    primary key (class_year, class_symbol, course_id)
);

-- pokazuje ktory uczen jest w jakiej grupie
create table students_attending_courses(
    id_of_student   int     not null,
    id_of_course    int     not null,

    primary key (id_of_student, id_of_course),
    foreign key (id_of_student) references students (id),
    foreign key (id_of_course) references courses (id)
);

create table product_category(
    id                  int             primary key,
    name                varchar(32)     not null,
    profit_margin       int             not null
);

create table school_shop(
    id              int             not null auto_increment,
    name            varchar(32),
    category        int             not null,
    quantity        int             not null,
    bulk_price      decimal(10,2)   not null,

    primary key (id),
    foreign key (category) references product_category(id)
);

create table orders(
    id              int                 not null auto_increment,
    item_id         int                 not null,
    quantity        int                 not null,
    order_date      date                not null default (CURRENT_DATE),
    price           decimal(10,2)       not null,

    primary key (id),
    foreign key (item_id) references school_shop (id)
);

create table transactions(
     id              int                not null auto_increment,
     item_id         int                not null,
     quantity        int                not null,
     order_date      date               not null default (CURRENT_DATE),
     price           decimal(10,2),

     primary key (id),
     foreign key (item_id) references school_shop (id)
);

create table scholarship_details(
    id                  int             not null,
    name                varchar(30),
    amount              int             not null,
    payment_frequency   char            not null,

    primary key (id),
    -- częstotliwośc wypłaty:  m - raz na miesiąc, y - raz w ciągu roku, s - raz na semestr
    check (payment_frequency in ('m', 'y', 's'))
);

create table scholarship_grants(
    id_of_student       int     not null,
    id_of_scholarship   int     not null,

    primary key (id_of_student, id_of_scholarship),
    foreign key (id_of_student) references students (id),
    foreign key (id_of_scholarship) references scholarship_details (id)
);

# create table amount_of_students_on_the_course
# (
#     course_id int not null primary key,
#     counter   int not null default 0,
#     foreign key (course_id) references courses (id)
# );
#
# create trigger insert_students_counter
#     before insert
#     on students_attending_courses
#     for each row
# begin
#     if exists(select * from amount_of_students_on_the_course where course_id = new.id_of_course) then
#         update amount_of_students_on_the_course set counter = counter + 1 where course_id = new.id_of_course;
#     else
#         insert into amount_of_students_on_the_course(course_id, counter) values (new.id_of_course, 1);
#     end if;
# end //
#
# create trigger update_students_counter
#     before update
#     on students_attending_courses
#     for each row
# begin
#     if old.id_of_course != new.id_of_course then
#         update amount_of_students_on_the_course set counter = counter - 1 where course_id = old.id_of_course;
#         update amount_of_students_on_the_course set counter = counter + 1 where course_id = new.id_of_course;
#     end if;
# end //

-- tabela przechowujaca dane na temat sal lekcyjnych
create table classrooms(
    id                  int not null primary key, -- jako id traktuje numer sali ktory widnieje na drzwiach, wiec nie ma auto_increment
    capacity            int,                      -- ile uczniow miesci sie w sali
    has_projector       boolean,                  -- czy sala ma projektor multimedialny?
    special_role_id     int,
    last_renovation     date,                     -- data ostatniego remontu

    foreign key (special_role_id) references classroom_roles (id)
);

-- Rozpiska dzwonkow
create table lessons_schedule(
    id              int     primary key auto_increment,
    week_day        int     not null,
        check (week_day between 1 and 7),
    lesson_num      int     not null,
    start_time      time    default ('12:00:00'),
    end_time        time    default ('13:00:00'),
        check (start_time < end_time)
);

-- Plan lekcji, np. w piatek o 7:30 w sali numer 50 ma lekcje kurs o zadanym ID
create table timetable(
    id                      int     primary key auto_increment,
    id_lessons_schedules    int     not null,
    id_of_course            int     not null,
    id_of_classroom         int     not null,

    foreign key (id_lessons_schedules) references lessons_schedule(id),
    foreign key (id_of_course) references courses (id),
    foreign key (id_of_classroom) references classrooms (id)
);

-- zajecia same w sobie. maja pointer na harmonogram w ktorym czasie powinny wystepowac
create table lessons(
    id                      int primary key auto_increment,
    timetable_id            int       not null,
    lesson_date             timestamp not null,
    needs_substitution      int     default false,
    teacher_substitution_id int     default null,
    is_in_progress          boolean default false,

    foreign key (timetable_id) references timetable (id)
);

-- tabela przechowujaca informacje o urlopach nauczycieli i innych pracownikow szkoly
create table vacations(
    employee_id         int     not null,
    vacation_start      date    not null,
    vacation_end        date    default null,

    primary key (employee_id, vacation_start)
);

-- obecnosc ucznia na zajeciach
create table student_presence(
    id_of_lesson    int         not null,
    id_of_student   int         not null,
    was_absent      boolean     default true,

    foreign key (id_of_lesson) references lessons (id),
    foreign key (id_of_student) references students (id),
    primary key (id_of_lesson, id_of_student)
);

create table course_marks_categories(
    id              int             not null primary key auto_increment,
    course_id       int             not null,
    description     varchar(256),
    weight          int             default 1,
        check (weight >= 0),

    foreign key (course_id) references courses(id)
);
-- oceny ucznia
create table student_marks(
    id              int         not null primary key auto_increment,
    mark_category   int         not null,
    id_of_student   int         not null,
    mark            int,
        check (mark <= 6 and mark >= 0),

    foreign key (mark_category) references course_marks_categories (id),
    foreign key (id_of_student) references students (id)
);

-- po dopisaniu kursu do danej klasy, automatycznie zapisujemy cala klase na ten kurs
create trigger insert_class_courses
    after insert
    on class_courses
    for each row
begin
    declare done int default false;
    declare temp_id int default 0;
    declare cur cursor for
        (select id from students s where s.class_year = new.class_year and s.class_symbol = new.class_symbol);
    declare continue handler for not found set done = true;

    open cur;
    read_loop: loop
        fetch cur into temp_id;
        if done then
            leave read_loop;
        end if;

        insert into students_attending_courses
            values (temp_id, new.course_id);
    end loop;
end //

-- po dopisaniu ucznia do klasy, zapisujemy go na wszystkie kursy dla tej klasy
create trigger insert_students
    after insert
    on students
    for each row
begin
    declare done int default false;
    declare temp_id int default 0;
    declare cur cursor for
        (select cc.course_id from class_courses cc where cc.class_year = new.class_year and cc.class_symbol = new.class_symbol);
    declare continue handler for not found set done = true;

    open cur;
    read_loop: loop
        fetch cur into temp_id;
        if done then
            leave read_loop;
        end if;

        insert into students_attending_courses (id_of_student, id_of_course)
            values (new.id, temp_id);
    end loop;
end //

create trigger insert_vacations
    after insert
    on vacations
    for each row
begin
    if new.vacation_end is null then
        if (select count(*) from lessons l where l.lesson_date >= new.vacation_start and new.employee_id = (select teacher_id from courses c where c.id = (select id_of_course from timetable t where t.id = l.timetable_id))) > 0 then
            update lessons l
                set needs_substitution = true
            where l.lesson_date >= new.vacation_start and new.employee_id = (select teacher_id from courses c where c.id = (select id_of_course from timetable t where t.id = l.timetable_id));
        end if;
    else
        if (select count(*) from lessons l where l.lesson_date >= new.vacation_start and l.lesson_date <= new.vacation_end and new.employee_id = (select teacher_id from courses c where c.id = (select id_of_course from timetable t where t.id = l.timetable_id))) > 0 then
            update lessons l
                set needs_substitution = true
            where l.lesson_date >= new.vacation_start and l.lesson_date <= new.vacation_end and new.employee_id = (select teacher_id from courses c where c.id = (select id_of_course from timetable t where t.id = l.timetable_id));
        end if;
    end if;
end //

create trigger update_vacations
    after update
    on vacations
    for each row
begin
    if old.vacation_end is null then
        if (select count(*) from lessons l where l.lesson_date >= old.vacation_start and old.employee_id = (select teacher_id from courses c where c.id = (select id_of_course from timetable t where t.id = l.timetable_id))) > 0 then
            update lessons l
                set needs_substitution = false
            where l.lesson_date >= old.vacation_start and old.employee_id = (select teacher_id from courses c where c.id = (select id_of_course from timetable t where t.id = l.timetable_id));
        end if;
    else
        if (select count(*) from lessons l where l.lesson_date >= old.vacation_start and l.lesson_date <= old.vacation_end and old.employee_id = (select teacher_id from courses c where c.id = (select id_of_course from timetable t where t.id = l.timetable_id))) > 0 then
            update lessons l
                set needs_substitution = false
            where l.lesson_date >= old.vacation_start and l.lesson_date <= old.vacation_end and old.employee_id = (select teacher_id from courses c where c.id = (select id_of_course from timetable t where t.id = l.timetable_id));
        end if;
    end if;

    if new.vacation_end is null then
        if (select count(*) from lessons l where l.lesson_date >= new.vacation_start and new.employee_id = (select teacher_id from courses c where c.id = (select id_of_course from timetable t where t.id = l.timetable_id))) > 0 then
            update lessons l
                set needs_substitution = true
            where l.lesson_date >= new.vacation_start and new.employee_id = (select teacher_id from courses c where c.id = (select id_of_course from timetable t where t.id = l.timetable_id));
        end if;
    else
        if (select count(*) from lessons l where l.lesson_date >= new.vacation_start and l.lesson_date <= new.vacation_end and new.employee_id = (select teacher_id from courses c where c.id = (select id_of_course from timetable t where t.id = l.timetable_id))) > 0 then
            update lessons l
                set needs_substitution = true
            where l.lesson_date >= new.vacation_start and l.lesson_date <= new.vacation_end and new.employee_id = (select teacher_id from courses c where c.id = (select id_of_course from timetable t where t.id = l.timetable_id));
        end if;
    end if;
end //

create trigger delete_vacations
    after delete
    on vacations
    for each row
begin
    if old.vacation_end is null then
        if (select count(*) from lessons l where l.lesson_date >= old.vacation_start and old.employee_id = (select teacher_id from courses c where c.id = (select id_of_course from timetable t where t.id = l.timetable_id))) > 0 then
            update lessons l
                set needs_substitution = false
            where l.lesson_date >= old.vacation_start and old.employee_id = (select teacher_id from courses c where c.id = (select id_of_course from timetable t where t.id = l.timetable_id));
        end if;
    else
        if (select count(*) from lessons l where l.lesson_date >= old.vacation_start and l.lesson_date <= old.vacation_end and old.employee_id = (select teacher_id from courses c where c.id = (select id_of_course from timetable t where t.id = l.timetable_id))) > 0 then
            update lessons l
                set needs_substitution = false
            where l.lesson_date >= old.vacation_start and l.lesson_date <= old.vacation_end and old.employee_id = (select teacher_id from courses c where c.id = (select id_of_course from timetable t where t.id = l.timetable_id));
        end if;
    end if;
end //

create trigger insert_lesson
    before insert
    on lessons
    for each row
begin
    set @tch_id = (select teacher_id from courses c where c.id = (select id_of_course from timetable t where t.id = new.timetable_id));

    if (select count(*) from vacations v where v.employee_id = @tch_id and ((v.vacation_end is null and v.vacation_start <= new.lesson_date) or (v.vacation_end is not null and v.vacation_start <= new.lesson_date and v.vacation_end >= new.lesson_date))) > 0 then
        set new.needs_substitution = true;
    end if;
end //

create trigger update_lesson
    before update
    on lessons
    for each row
begin
    set @tch_id = (select teacher_id from courses c where c.id = (select id_of_course from timetable t where t.id = new.timetable_id));

    if (select count(*) from vacations v where v.employee_id = @tch_id and ((v.vacation_end is null and v.vacation_start <= new.lesson_date) or (v.vacation_end is not null and v.vacation_start <= new.lesson_date and v.vacation_end >= new.lesson_date))) > 0 then
        set new.needs_substitution = true;
    else
        set new.needs_substitution = false;
    end if;
end //

create trigger insert_transaction
    before insert
    on transactions
    for each row
begin
    declare prod_quantity int default (select quantity from school_shop ss where ss.id = new.item_id);
    declare msg varchar(255);

    if new.price is null then
        set new.price = new.quantity * (select bulk_price from school_shop ss where ss.id = new.item_id) * (1 + 0.01 *(select profit_margin from product_category pc where pc.id = (select category from school_shop ss where ss.id = new.item_id)));
    end if;

    if prod_quantity < new.quantity then
        set msg = 'Nie mozna kupic tylu produktow';
        signal sqlstate '45000' set message_text = msg;
        set new.item_id = null; -- rollback
    else
        update school_shop ss
            set ss.quantity = prod_quantity - new.quantity
        where ss.id = new.item_id;

        if prod_quantity - new.quantity < 5 and (select count(*) from orders o where o.item_id = new.item_id) = 0 then
            insert into orders (item_id, quantity, price)
            values (new.item_id, 30, (select bulk_price from school_shop ss where ss.id = new.item_id));
        end if;
    end if;
end //

DELIMITER //
/* ------ ------ ------ ------ ------ ------ procedures */
create procedure get_average_mark(in studentId int, in courseId int)
begin
    declare done int default false;
    declare temp_mark int;
    declare temp_weight int default 0;
    declare weight_count int default 0;
    declare result decimal(10,2) default 0;
    declare cur cursor for
        (select sm.mark, cmc.weight from student_marks sm join course_marks_categories cmc on sm.mark_category = cmc.id
        where (sm.id_of_student = studentId) and (cmc.course_id = courseId));
    declare continue handler for not found set done = true;

    open cur;
    read_loop: loop
        fetch cur into temp_mark, temp_weight;
        if done then
            leave read_loop;
        end if;
        SET result = result + (temp_weight * temp_mark);
        SET weight_count = weight_count + temp_weight;
    end loop;

    close cur;
    if weight_count = 0 then
        select concat('Uczen nie ma zadnych ocen z przedmiotu ', s.name) as srednia
            from courses c
            join subjects s on s.id = c.subject_id = s.id
            where c.id = courseId;
    else
        set result = result/weight_count;
        select result as srednia;
    end if;
end //

-- wypisuje liste uczniow ktorych uczy dany nauczyciel
create procedure get_students_of_teacher(in teacherId int)
begin
    select distinct p.id, p.name, p.surname, concat(s.class_year, s.class_symbol) as class
    from students s
    left join students_attending_courses on s.id = students_attending_courses.id_of_student
    join people p on s.id = p.id
    where id_of_course in (select id from courses where courses.teacher_id = teacherId);
end //

-- updatuje in progress field na zajeciach
create procedure update_lessons_in_progress()
begin
    SET @lesson_length_in_minutes = 90;
    update lessons
    set is_in_progress = true
    where TIME_TO_SEC(TIMEDIFF(NOW(), lesson_date)) / 60 > 0 &&
          TIME_TO_SEC(TIMEDIFF(NOW(), lesson_date)) / 60 < @lesson_length_in_minutes;

end //

/* ------ ------ ------ ------ ------ ------ functions */
create function set_absence_to_student(lessonDate date, studentId int, wasabsent boolean)
    returns varchar(100)
    reads sql data
begin
    declare foundLessons boolean;
    declare statusNotExists boolean;
    declare lessonId integer;

    set foundLessons = EXISTS(select * from lessons where lesson_date = lessonDate);

    if (not foundLessons) then return 'cannot find lessons at this day' ; end if;

    set lessonId = (select lessons.id from lessons where lesson_date = lessonDate limit 1);
    set statusNotExists =
            (select count(*) = 0 from student_presence where id_of_lesson = lessonId and studentId = id_of_student);

    if statusNotExists then
        insert into student_presence(id_of_lesson, id_of_student, was_absent) values (lessonId, studentId, wasabsent);
        return 'Entry was created';
    end if;

    update student_presence
    set was_absent = wasabsent
    where id_of_lesson = lessonId
      and studentId = id_of_student;
    return 'Entry was updated';
end //

-- funkcja zwracajaca dzien tygodnia zadany liczba 1-7
create function week_day (day int)
    returns varchar(32) deterministic
begin
    case day
        when 1 then return 'poniedzialek';
        when 2 then return 'wtorek';
        when 3 then return 'sroda';
        when 4 then return 'czwartek';
        when 5 then return 'piatek';
        when 6 then return 'sobota';
        when 7 then return 'niedziela';
    end case;
end //

create function candidates_pts (can_id int)
    returns decimal(5,2) deterministic
begin
    return (select c.pl_exam_result * 0.3 + c.math_exam_result * 0.3 + c.science_exam_result * 0.3 + c.extracurricular_act  * 10 from candidates c where c.id = can_id);
end //

-- procedura wyswietlajaca informacje kontaktowe rodzicow danego ucznia
create procedure get_parents_contact_info (studentid int)
begin
    if studentid in (select id from students) then
        drop table if exists temp;
        create table temp(
            Name varchar(32),
            Surname varchar(32),
            Adress varchar(256),
            Phone varchar(9)
        );

        if (select first_parent_id from students where students.id = studentid) is not null then
            insert into temp (name, surname, adress, phone)
            select p.name, p.surname, concat(par.adress_street, ', ', par.adress_postal_code, ' ', par.adress_city), par.phone_number
            from students s
            join people p on p.id = s.first_parent_id
            join parents par on p.id = par.id
            where s.id = studentid;
        end if;

        if (select second_parent_id from students where students.id = studentid) is not null then
            insert into temp (name, surname, adress, phone)
            select p.name, p.surname, concat(par.adress_street, ', ', par.adress_postal_code, ' ', par.adress_city), par.phone_number
            from students s
            join people p on p.id = s.second_parent_id
            join parents par on p.id = par.id
            where s.id = studentid;
        end if;

        select * from temp;

        drop table temp;
    else
        select 'Uczen o zadanym ID nie istnieje' as result;
    end if;
end //

-- procedura wyswietlajaca plan lekcji dla danej klasy
create procedure class_timetable (year int, symbol char)
begin
    if (year, symbol) in (select c.year, c.symbol from class c) then
        select week_day(ls.week_day), ls.lesson_num, ls.start_time, ls.end_time, s.name, t.id_of_classroom, p.name, p.surname
        from class_courses cc
        join courses c on cc.course_id = c.id
        join subjects s on c.subject_id = s.id
        join timetable t on c.id = t.id_of_course
        join lessons_schedule ls on t.id_lessons_schedules = ls.id
        join people p on c.teacher_id = p.id
        where cc.class_year = year and cc.class_symbol = symbol;
    else
        select 'Podana klasa nie istnieje';
    end if;
end //

-- funkcja zwracajaca informacje o tym czy dany kandydat jest w top 6 osobach - czy ma szanse sie dostac do szkoly?
create function candidate_in_top6 (can_id int)
    returns int deterministic
begin
    declare 6th_id int default (select c1.id from candidates c1 order by candidates_pts(c1.id) desc, c1.filling_date asc limit 5,1);
    declare 6th_score int default (candidates_pts(6th_id));
    declare score int default (select candidates_pts(can_id));
    declare date datetime default (select filling_date from candidates where candidates.id = can_id);
    if score > 6th_score then
        return true;
    else
        if score = 6th_score and date <= (select filling_date from candidates where id = 6th_id) then
            return true;
        else
            return false;
        end if;
    end if;
end //

-- funkcja uzywana w procedurze propose_new_classes() w sytuacji, gdy klasa do ktorej chcialby dostac sie uczen jest juz zapelniona
create function set_new_class_preferences (m_full int, p_full int, s_full int, pref char)
    returns char deterministic
begin
    case pref
        when 'm' then
            if (not m_full) then
                return 'm';
            else
                if (not s_full) then
                    return 's';
                else
                    return 'p';
                end if;
            end if;
        when 'p' then
            if (not p_full) then
                return 'p';
            else
                if (not s_full) then
                    return 's';
                else
                    return 'm';
                end if;
            end if;
        when 's' then
            if (not s_full) then
                return 's';
            else
                if (not m_full) then
                    return 'm';
                else
                    return 'p';
                end if;
            end if;
    end case;
end //

-- procedura wybierajaca 6 najlepszych osob z listy kandydatow, a nastepnie przydzielajaca im odpowiednie klasy zgodnie z opiem rekrutacji
create procedure propose_new_classes ()
begin
    declare class_capacity int default 2;
    declare m_students smallint default 0;
    declare s_students smallint default 0;
    declare p_students smallint default 0;
    declare n int default 0;
    declare i int default 0;
    declare temp_id int default 0;
    declare temp_chosen_class char;

    drop table if exists temp;
    create table temp(
        id int,
        pl_exam_result int,
        math_exam_result int,
        science_exam_result int,
        extracurricular_act int,
        chosen_class_symbol char,
        filling_date datetime
    );

    insert into temp
        select * from candidates c where candidates_pts(c.id) >= 50 order by candidates_pts(c.id) desc, c.filling_date asc limit 6;

    set n = (select count(*) from temp);
    while i < n do
        set temp_id = (select id from temp c order by candidates_pts(c.id) desc, c.filling_date asc limit 1);
        set temp_chosen_class = (select chosen_class_symbol from temp where id = temp_id);

        if (select count(*) from temp t where t.chosen_class_symbol = temp_chosen_class and candidates_pts(t.id) = candidates_pts(temp_id)) > 1 then
            case temp_chosen_class
                when 'm' then set temp_id = (select id from temp t where t.chosen_class_symbol = temp_chosen_class and candidates_pts(t.id) = candidates_pts(temp_id) order by t.math_exam_result desc, t.filling_date asc limit 1);
                when 'p' then set temp_id = (select id from temp t where t.chosen_class_symbol = temp_chosen_class and candidates_pts(t.id) = candidates_pts(temp_id) order by t.pl_exam_result desc, t.filling_date asc limit 1);
                when 's' then set temp_id = (select id from temp t where t.chosen_class_symbol = temp_chosen_class and candidates_pts(t.id) = candidates_pts(temp_id) order by t.science_exam_result desc, t.filling_date asc limit 1);
            end case;
        end if;

        insert into students (id, first_parent_id, second_parent_id, class_year, class_symbol)
            values (temp_id, null, null, 0, (select symbol from class where year = 0 and specialization = temp_chosen_class));

        delete from temp
            where id = temp_id;

        case temp_chosen_class
            when 'm' then set m_students = m_students + 1;
            when 'p' then set p_students = p_students + 1;
            when 's' then set s_students = s_students + 1;
        end case;

        update temp
        set chosen_class_symbol = set_new_class_preferences (m_students >= class_capacity, p_students >= class_capacity, s_students >= class_capacity, chosen_class_symbol)
        where chosen_class_symbol = chosen_class_symbol;

        set i = i + 1;
    end while;

    drop table temp;

    select 'Klasa A' as ID, concat('Specializacja: ', (select specialization from class where year = 0 and symbol = 'a')) as Name, concat('Wychowawaca: ', (select p.name from class c join people p on c.admin_teacher_id = p.id where c.year = 0 and c.symbol = 'a'), ' ', (select p.surname from class c join people p on c.admin_teacher_id = p.id where c.year = 0 and c.symbol = 'a')) as Surname
    union
    select p.id, p.name, p.surname
    from students s
    join people p on s.id = p.id
    where s.class_year = 0 and s.class_symbol = 'a'
    union
    select 'Klasa B' as ID, concat('Specializacja: ', (select specialization from class where year = 0 and symbol = 'b')) as Name, concat('Wychowawaca: ', (select p.name from class c join people p on c.admin_teacher_id = p.id where c.year = 0 and c.symbol = 'b'), ' ', (select p.surname from class c join people p on c.admin_teacher_id = p.id where c.year = 0 and c.symbol = 'b')) as Surname
    union
    select p.id, p.name, p.surname
    from students s
    join people p on s.id = p.id
    where s.class_year = 0 and s.class_symbol = 'b'
    union
    select 'Klasa C' as ID, concat('Specializacja: ', (select specialization from class where year = 0 and symbol = 'c')) as Name, concat('Wychowawaca: ', (select p.name from class c join people p on c.admin_teacher_id = p.id where c.year = 0 and c.symbol = 'c'), ' ', (select p.surname from class c join people p on c.admin_teacher_id = p.id where c.year = 0 and c.symbol = 'c')) as Surname
    union
    select p.id, p.name, p.surname
    from students s
    join people p on s.id = p.id
    where s.class_year = 0 and s.class_symbol = 'c';
end //

-- wyswietla liste uczniow w klasie zadanej w argumencie
create procedure show_class (yr int, smbl char)
begin
    select p.id, p.name, p.surname
    from students s
    join people p on s.id = p.id
    where s.class_year = yr and s.class_symbol = smbl;
end //

