create or replace procedure bp.getBaikalDataPeriod(
    @ddateb datetime,
    @ddatee datetime default today()-1
)
begin

    while @ddateb <= @ddatee loop

        call bp.getBaikalData(@ddateb);

        set @ddateb = dateadd(day, 1,  @ddateb);

    end loop;

end
;
