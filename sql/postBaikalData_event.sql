sa_make_object 'event', 'postBaikalData', 'bp'
;
alter event bp.postBaikalData
add schedule postBaikalData
between '0:00AM'  and '23:59PM'
every 20 minutes on  ('Mon','Tue','Wed','Thu','Fri','Sat','Sun')
handler
begin

    if EVENT_PARAMETER('NumActive') <> '1' then
        return;
    end if;

    call bp.postBaikalData();

    exception
    when others then

        call util.errorHandler('bp.postBaikalData', SQLSTATE, errormsg());

        rollback;

end
;
