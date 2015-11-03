sa_make_object 'procedure', 'post', 'bp';

alter procedure bp.[post]()
begin
    declare @request xml;

    set @request = http_variable('request');
    --set @request = csconvert(@request, 'utf8', '1251cyr');
    message 'bp.post @request = ', @request;

    insert into bp.CRMOrder on existing update with auto name
    select ActionDate,
        AddressId,
        CRMClientId,
        CompanyId,
        CreateId,
        CRMDbId,
        CRMOrderDate,
        CRMOrderNumber,
        CRMPayKindId,
        CRMWareHouseId ,
        PersonId ,
        StatusId ,
        Summa ,
        WareHouseId ,
        DocumentTypeId ,
        PriceTypeId ,

        id, xid, ts, cts
    from openxml(@request,' /data/CRMOrder')
        with(
            ActionDate STRING '@ActionDate',
            AddressId STRING' @AddressId',
            CRMClientId STRING '@CRMClientId',
            CompanyId STRING '@CompanyId',
            CreateId STRING '@CreateId',
            CRMDbId STRING '@CRMDbId',
            CRMOrderDate STRING '@CRMOrderDate',
            CRMOrderNumber STRING '@CRMOrderNumber',
            CRMPayKindId STRING '@CRMPayKindId',
            CRMWareHouseId STRING '@CRMWareHouseId',
            PersonId STRING '@PersonId',
            StatusId STRING '@StatusId',
            Summa STRING '@Summa',
            WareHouseId STRING '@WareHouseId',
            DocumentTypeId STRING '@DocumentTypeId',
            PriceTypeId STRING '@PriceTypeId',

            id integer '@id',
            xid uniqueidentifier '@xid',
            ts datetime '@ts',
            cts datetime '@cts'
        );

    insert into bp.CRMOrderLine on existing update with auto name
        select Price,
            Quantity,
            UnitId,
            WareHouseId,
            WareId,
            CRMOrder,
            id, xid, ts, cts
    from openxml(@request,' /data/CRMOrderLine')
        with(
            Price STRING '@Price',
            Quantity STRING '@Quantity',
            UnitId STRING '@UnitId',
            WareHouseId STRING '@WareHouseId',
            WareId STRING '@WareId',
            CRMOrder integer '@CRMOrder',

            id integer '@id',
            xid uniqueidentifier '@xid',
            ts datetime '@ts',
            cts datetime '@cts'
        );

end
;
