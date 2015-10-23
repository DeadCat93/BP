create or replace procedure bp.xDataLinkExchangePeriod(
    @ddateb datetime,
    @ddatee datetime default today()-1
)
begin
    declare @d datetime;

    set @d = @ddateb -1;

    while @d <= @ddatee loop
        set @d = @d + 1;
        message 'bp.xDataLinkExchangePeriod @d = ', @d to client;
        call bp.xDataLinkExchange(@d, 0, 1, 1);




    end loop;

end
;
