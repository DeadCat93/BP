create or replace procedure bp.getBaikalData(
    @ddate datetime default today() -1,
    @url STRING default 'http://10.25.2.16/rc_baikal9/bpData'
)
begin
    declare @response xml;
    declare @dateStr STRING;
    declare @dateStrNext STRING;

    set @dateStr =  convert(varchar(24), @ddate, 111);
    set @dateStrNext =  convert(varchar(24), @ddate +1, 111);

    -- CRMWhBalanceEx (остатки)
    set @response = bp.getDataLog(@url + '/CRMWhBalanceEx', @dateStr);

    delete from bp.CRMWhBalanceEx
    where ddate = @ddate;

    merge into bp.CRMWhBalanceEx(
        ddate,
        WareHouseId,
        DocumentDate,
        DocumentNumber,
        WareId,
        UnitId,
        Quantity
    ) using with auto name(
        select @ddate as ddate,
            WareHouseId,
            DocumentDate,
            DocumentNumber,
            WareId,
            UnitId,
            Quantity
        from openxml(xmlelement('root', @response), '/root/CRMWhBalanceEx')
            with(
                WareHouseId STRING 'WareHouseId',
                DocumentDate STRING 'DocumentDate',
                DocumentNumber STRING 'DocumentNumber',

                WareId STRING 'WareId',
                UnitId STRING 'UnitId',
                Quantity integer 'Quantity'
            )
    ) as t on bp.CRMWhBalanceEx.ddate = t.ddate
        and bp.CRMWhBalanceEx.WareHouseId = t.WareHouseId
        and bp.CRMWhBalanceEx.WareId = t.WareId
        and bp.CRMWhBalanceEx.UnitId = t.UnitId
    when not matched then insert
    when matched then
    update
    set DocumentDate = t.DocumentDate,
        DocumentNumber = t.DocumentNumber,
        Quantity = t.Quantity;

    -- CRMDespatchEx (движение товара)
    set @response = bp.getDataLog(@url + '/CRMDespatchEx', @dateStr);

    delete from bp.CRMDespatchEx
    where ddate = @ddate;

    merge into bp.CRMDespatchEx(
        ddate,
        bid,
        bsubid,
        CompanyId,
        AddressId,
        AddressRegionType,
        SaleChannel,
        CRMOrderNumber,
        CRMOrderDate,
        DocumentTypeId,
        DocumentNumber,
        DocumentDate,
        PayDate,
        WareHouseId,
        WareId,
        Price,
        Quantity,
        CRMClientId,
        CompanyName,
        AddressName,
        Location
    ) using with auto name (
        select @ddate as ddate,
            bid ,
            bsubid,
            CompanyId,
            AddressId,
            AddressRegionType,
            SaleChannel,
            CRMOrderNumber,
            CRMOrderDate,
            DocumentTypeId,
            DocumentNumber,
            DocumentDate,
            PayDate,
            WareHouseId,
            WareId,
            Price,
            Quantity,
            CRMClientId,
            CompanyName,
            AddressName,
            Location
        from openxml(xmlelement('root', @response), '/root/CRMDespatchEx')
            with(
                bid integer 'bid',
                bsubid integer 'bsubid',
                CompanyId STRING 'CompanyId',
                AddressId STRING 'AddressId',
                AddressRegionType STRING 'AddressRegionType',
                SaleChannel STRING 'SaleChannel',
                CRMOrderNumber STRING 'CRMOrderNumber',
                CRMOrderDate STRING 'CRMOrderDate',
                DocumentTypeId STRING 'DocumentTypeId',
                DocumentNumber STRING 'DocumentNumber',
                DocumentDate STRING 'DocumentDate',
                PayDate STRING 'PayDate',
                WareHouseId STRING 'WareHouseId',
                WareId STRING 'WareId',
                Price decimal(18,4) 'Price',
                Quantity integer 'Quantity',
                CRMClientId STRING 'CRMClientId',
                CompanyName STRING 'CompanyName',
                AddressName STRING 'AddressName',
                Location STRING 'Location'
            )
    ) as t on bp.CRMDespatchEx.bid = t.bid
        and bp.CRMDespatchEx.bsubid = t.bsubid
        when not matched then insert
        when matched then
        update;

    -- CRMWarePrice (цены)
    set @response = bp.getDataLog(@url + '/CRMWarePrice', @dateStrNext);

    delete from bp.CRMWarePrice
    where PriceDate = @ddate +1;

    insert into bp.CRMWarePrice with auto name
    select @ddate +1 as PriceDate,
        PriceTypeId,
        WareId,
        UnitId,
        Price
    from openxml(xmlelement('root', @response), '/root/CRMWarePrice')
        with(
            PriceTypeId STRING 'PriceTypeId',
            WareId STRING 'WareId',
            UnitId STRING 'UnitId',
            Price decimal(18, 2) 'Price'
        );

    -- CRMWarePrice (цены)
    set @response = bp.getDataLog(@url + '/CRMWarePriceAddress', @dateStrNext);

    delete from bp.CRMWarePriceAddress;

    insert into bp.CRMWarePriceAddress with auto name
    select AddressId,
        PriceTypeId
    from openxml(xmlelement('root', @response), '/root/CRMWarePriceAddress')
        with(
            PriceTypeId STRING 'PriceTypeId',
            AddressId STRING 'AddressId'
        );

    -- CRMOrderStatus
    set @response = bp.getDataLog(@url + '/CRMOrderStatus', @dateStr);

    update bp.CRMOrder
    set status =
            case
                when d.status = 0 then 0
                when d.status = 1 and d.sale_order is null then -1
                when d.status = 1 and d.sale_order_status4 = 1 then 1
                else 0
            end
    from bp.CRMOrder o join (
            select id,
                status,
                sale_order,
                sale_order_status4
            from openxml(xmlelement('root', @response), '/root/CRMOrderStatus')
                with(
                    id integer 'id',
                    status integer 'status',
                    sale_order integer 'sale_order',
                    sale_order_status4 integer 'sale_order_status4'
                )
            ) as d on d.id = o.id;

end
;
