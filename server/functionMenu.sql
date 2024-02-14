select r.routine_schema            as database_name,
       r.specific_name             as routine_name,
       r.routine_type              AS type,
       p.parameter_name,
       p.data_type,
       case
           when p.parameter_mode is null and p.data_type is not null
               then 'RETURN'
           else parameter_mode end as parameter_mode,
       p.character_maximum_length as char_length,
       p.numeric_precision,
       p.numeric_scale
from information_schema.routines r
    left join information_schema.parameters p
on p.specific_schema = r.routine_schema
    and p.specific_name = r.specific_name
where r.routine_schema not in ('sys'
    , 'information_schema'
    , 'mysql'
    , 'performance_schema')
order by r.routine_schema,
    r.specific_name,
    p.ordinal_position;
