sa_make_object 'event', 'getBaikalData', 'bp'
;
alter event bp.getBaikalData
add schedule getBaikalData
between '0:00AM'  and '23:59PM'
every 120 minutes on  ('Mon','Tue','Wed','Thu','Fri','Sat','Sun')
handler
begin

    if EVENT_PARAMETER('NumActive') <> '1' then
        return;
    end if;

    call bp.getBaikalData();

    exception
    when others then

        call util.errorHandler('bp.getBaikalData', SQLSTATE, errormsg());

        rollback;

end
;
