sa_make_object 'procedure', 'CRMWarePrice', 'bp';

alter procedure bp.CRMWarePrice(
    @ddate datetime default today()
)
begin

    select @ddate as PriceDate,
        pl.id as PriceTypeId,
        w.WareId,
        w.UnitId,
        round(min(pp.price), 2) as Price
    from dbo.pricelist_prices pp join bp.pricelist pl on pp.list = pl.id
        join bp.CRMWare w on w.id = pp.goods
    where pp.ddate = @ddate
    group by pl.id,
        w.WareId,
        w.UnitId;

end
;
