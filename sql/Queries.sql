use schoolDB;


delimiter //
-- wyswietla liste zajec dla wszystkich uczniow
create view students_timetable as
    select p.id, p.name, p.surname, s2.name subject_name, t.id_of_classroom, ls.week_day, ls.start_time, ls.end_time
    from students s
    join people p on s.id = p.id
    join students_attending_courses sac on sac.id_of_student = p.id
    join courses c on sac.id_of_course = c.id
    join subjects s2 on c.subject_id = s2.id
    join timetable t on c.id = t.id_of_course
    join lessons_schedule ls on t.id_lessons_schedules=ls.id
    order by p.id;

-- select * from students_timetable;

-- wyswietla liste kandydatow z obliczonymi punktami do rekrutacji do szkoly oraz decyzją - czy mają ich dość by się dostać
create view candidates_stats as
    select p.id, p.name, p.surname, candidates_pts(c.id) as points,
        if(candidates_pts(c.id) >= 50, if(candidate_in_top6(c.id), 'Approved', 'Not approved (reserve)'), 'Not approved') as Decision
    from people p
    join candidates c on p.id = c.id
    order by points desc;

-- select * from candidates_stats;

-- wyswietla liste zajec ktore potrzebuja zastepstwa, bo nauczyciel jest na urlopie
create view lessons_needing_substitution as
    select l.id, l.lesson_date, week_day(ls.week_day) as week_day, ls.start_time, ls.end_time, s.name
    from lessons l
    join timetable t on l.timetable_id = t.id
    join lessons_schedule ls on t.id_lessons_schedules = ls.id
    join courses c on t.id_of_course = c.id
    join subjects s on c.subject_id = s.id
    where l.needs_substitution = true and l.teacher_substitution_id is null;

-- select * from lessons_needing_substitution;

-- wyswietla liste ocen kazdego ucznia
create view journal_marks as
    select sm.id_of_student, p.name, p.surname, s.name as subject, cmc.description, sm.mark, cmc.weight
    from student_marks sm
    join course_marks_categories cmc on sm.mark_category = cmc.id
    join courses c on cmc.course_id = c.id
    join subjects s on c.subject_id = s.id
    join people p on sm.id_of_student = p.id
    order by id_of_student, subject, weight desc;

-- select * from journal_marks;

-- wyswietla informacje o tym na ktorych lekcjach byli obecni lub nieobecni wszyscy uczniowie w szkole
create view journal_presence as
    select sp.id_of_student, p.name, p.surname, s.name as subject, l.lesson_date, if(sp.was_absent, 'absent', 'present') as status
    from student_presence sp
    join lessons l on sp.id_of_lesson = l.id
    join timetable t on t.id = l.timetable_id
    join courses c on t.id_of_course = c.id
    join subjects s on c.subject_id = s.id
    join people p on sp.id_of_student = p.id
    order by id_of_student, l.lesson_date;

-- select * from journal_presence;

-- wyswietla informacje na ilu zajeciach (procentowo) byl dany uczen
create function presence_percentage (stud_id int)
    returns decimal (5, 2) deterministic
begin
    declare sum int default (select count(*) from journal_presence where id_of_student = stud_id);
    declare presence int default (select count(*) from journal_presence where id_of_student = stud_id and status = 'present');
    return (presence/sum) * 100;
end //

-- wyswietla informacje na ilu zajeciach (procentowo) byl dany uczen
 select presence_percentage(6);

-- wypisuje srednia ocene dla studenta x i przedmiotu y
call get_average_mark(6, 1);

-- wypisuje liste uczniow ktorych uczy zadany nauczyciel
call get_students_of_teacher(8);

-- wypisuje informacje kontaktowe do rodzicow danego ucznia
call get_parents_contact_info(6);

-- wypisuje plan lekcji klasy zadanej w argumentach
call class_timetable(1, 'a');

call show_class (1, 'a');

call propose_new_classes();


-- ustawia obecnosc ucznia danego dnia
 select set_absence_to_student('2012-12-05', 6, 1);
 