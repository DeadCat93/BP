create or replace procedure bp.exchangePeriod(
    @ddate datetime default dateadd(day, -datepart(day, today()) +1, today())
)
begin
    declare @d datetime;

    set @ddate = greater(@ddate, util.getUserOption('bp.exchangeStart'));

    set @d = @ddate;
    call bp.getBaikalDataPeriod(@d, today() -1);
    commit;

    set @d = @ddate;
    call bp.xDataLinkExchangePeriod(@d, today() -1);
    commit;

    return;

end
;
