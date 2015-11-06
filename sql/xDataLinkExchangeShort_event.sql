sa_make_object 'event', 'xDataLinkExchangeShort', 'bp'
;
alter event bp.xDataLinkExchangeShort
add schedule xDataLinkExchangeShort
between '6:06AM'  and '23:01PM'
every 10 minutes on  ('Mon','Tue','Wed','Thu','Fri','Sat','Sun')
handler
begin

    if EVENT_PARAMETER('NumActive') <> '1' then
        return;
    end if;

    call bp.xDataLinkExchangeShort();

    exception
    when others then

        call util.errorHandler('bp.xDataLinkExchangeShort', SQLSTATE, errormsg());

        rollback;

end
;
