create or replace procedure bp.getBaikalData(
    @ddate datetime default today() -1,
    @url STRING default 'http://127.0.0.1/rc_baikal/bpData'
)
begin
    declare @response xml;
    declare @dateStr STRING;

    set @dateStr =  convert(varchar(24), @ddate, 111);

    -- CRMWhBalanceEx (остатки)
    set @response = bp.getData(@url + '/CRMWhBalanceEx', @dateStr);

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
    set @response = bp.getData(@url + '/CRMDespatchEx', @dateStr);

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



end
;
