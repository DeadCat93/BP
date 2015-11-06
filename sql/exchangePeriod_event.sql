sa_make_object 'event', 'exchangePeriod', 'bp'
;
alter event bp.exchangePeriod
handler
begin
    declare @ddate datetime;

    if EVENT_PARAMETER('NumActive') <> '1' then
        return;
    end if;

    set @ddate = isnull(
            if isdate(event_parameter('startDate')) = 1 then event_parameter('startDate') endif,
            dateadd(day, -datepart(day, today()) +1, today())
        );

    message 'bp.exchangePeriod event @ddate = ', @ddate;

    call bp.exchangePeriod(@ddate);

exception
when others then

    call util.errorHandler('bp.exchangePeriod', SQLSTATE, errormsg());

    rollback;

end
;
