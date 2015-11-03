sa_make_object 'event', 'getBaikalDataShort', 'bp'
;
alter event bp.getBaikalDataShort
add schedule getBaikalDataShort
between '0:00AM'  and '23:59PM'
every 20 minutes on  ('Mon','Tue','Wed','Thu','Fri','Sat','Sun')
handler
begin

    if EVENT_PARAMETER('NumActive') <> '1' then
        return;
    end if;

    call bp.getBaikalDataShort();

    exception
    when others then

        call util.errorHandler('bp.getBaikalDataShort', SQLSTATE, errormsg());

        rollback;

end
;
