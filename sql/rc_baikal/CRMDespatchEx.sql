sa_make_object 'procedure', 'CRMDespatchEx', 'bp';

alter procedure bp.CRMDespatchEx(
    @ddate datetime
)
begin

    select @ddate as ddate,
        ig.id as bid,
        ig.subid as bsubid,
        null as CompanyId,
        null as AddressId,
        null as AddressRegionType,
        null as SaleChannel,
        null as CRMOrderNumber,
        null as CRMOrderDate,
        'VendReceipt' as DocumentTypeId,
        i.ndoc as DocumentNumber,
        i.ddate as DocumentDate,
        null as PayDate,
        wh.WareHouseId,
        w.WareId,
        ig.price as Price,
        cast(ig.vol as integer) as Quantity,
        null as CRMClientId,
        null as CompanyName,
        null as AddressName,
        null as Location
    from dbo.income i join dbo.incgoods ig on i.id = ig.id
        join bp.sellers s on s.id = i.client
        join bp.CRMWareHouse wh on wh.id = i.storage
        join bp.CRMWare w on w.id = ig.goods
    where i.ddate = @ddate
    union
    select @ddate as ddate,
        rg.id,
        rg.subid,
        isnull(b.partner, abs(b.id)) as CompanyId,
        abs(b.id) as AddressId,
        null as AddressRegionType,
        null as SaleChannel,
        null as CRMOrderNumber,
        null as CRMOrderDate,
        'Despatch' as DocumentTypeId,
        r.ndoc as DocumentNumber,
        r.ddate as DocumentDate,
        dateadd(day, isnull(pay.plong, 0), r.ddate) as PayDate,
        wh.WareHouseId,
        w.WareId,
        rg.price,
        cast(rg.vol as integer) as Quantity,
        null as CRMClientId,
        coalesce(p.name, s.name, b.name) as CompanyName,
        coalesce(s.name, b.name) as AddressName,
        coalesce(s.loadfrom, b.loadto) as Location
    from dbo.recept r join dbo.recgoods rg on r.id = rg.id
        join dbo.payspt pay on pay.id = rg.pays
        join dbo.buyers b on b.id = r.client
            left outer join dbo.storages s on s.id = -r.client
            left outer join dbo.partners p on p.id = b.partner
        join bp.CRMWareHouse wh on wh.id = r.storage
        join bp.CRMWare w on w.id = rg.goods
    where r.ddate = @ddate;

end
;
