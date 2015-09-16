create or replace procedure bp.xDataLinkExchangePeriod(
    @ddateb datetime,
    @ddatee datetime default today()-1
)
begin

    while @ddateb <= @ddatee loop

        call bp.xDataLinkExchange(@ddateb, 0, 1, 1);

        set @ddateb = dateadd(day, 1,  @ddateb);

    end loop;

end
;
