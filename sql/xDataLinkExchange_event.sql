sa_make_object 'event', 'xDataLinkExchange', 'bp'
;
alter event bp.xDataLinkExchange
add schedule xDataLinkExchange
start time '08:00' on  ('Mon','Tue','Wed','Thu','Fri','Sat','Sun')
handler
begin

    if EVENT_PARAMETER('NumActive') <> '1' then
        return;
    end if;

    call bp.xDataLinkExchange(today() -1, 1, 1, 1);

    exception
    when others then

        call util.errorHandler('bp.xDataLinkExchange', SQLSTATE, errormsg());

        rollback;

end
;
