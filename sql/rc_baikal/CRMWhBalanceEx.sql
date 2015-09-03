sa_make_object 'procedure', 'CRMWhBalanceEx', 'bp';

alter procedure bp.CRMWhBalanceEx(
    @ddate datetime
)
begin

    select wh.WareHouseId,
        cast(@ddate as varchar(24)) as DocumentDate,
        cast(@ddate as varchar(24)) as DocumentNumber,
        null as PersonId,
        w.WareId,
        w.UnitId,
        cast(
            sum(r.volume)
            +
            isnull((
                select sum(rg.vol)
                from dbo.recgoods rg join dbo.recept r on rg.id = r.id
                where r.storage = wh.id
                    and r.ddate >= @ddate
                    and rg.goods = w.id
            ), 0)
            -
            isnull((
                select sum(ig.vol)
                from dbo.incgoods ig join dbo.income i on ig.id = i.id
                where i.storage = wh.id
                    and i.ddate >= @ddate
                    and ig.goods = w.id
            ), 0)
        as integer) as Quantity
    from dbo.remains r join bp.CRMWare w on w.id = r.goods
        join bp.CRMWareHouse wh on wh.id = r.storage
    group by wh.WareHouseId, w.WareId, w.UnitId, w.id, wh.id;

end
;
