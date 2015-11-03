create or replace procedure bp.xDataLinkGetCRMOrder()
begin

    declare @request xml;
    declare @response xml;
    declare @schema xml;
    declare @parenTIdPath STRING;

    set @request = bp.xDataLinkMakeRequest('CRMOrder', 'get');
    set @response = bp.[xDataLink.RequestLog](@request);

    set @response = bp.xDataLinkResultSetFromResponse(@response, 'CRMOrder');

    merge into bp.CRMOrder(
        ActionDate,
        AddressId,
        CRMClientId,
        CompanyId,
        CreateId ,
        CRMDbId,
        CRMOrderDate,
        CRMOrderNumber,
        CRMPayKindId,
        CRMWareHouseId,
        PersonId,
        StatusId,
        Summa,
        WareHouseId,
        DocumentTypeId,
        PriceTypeId
    ) using with auto name(
        select *
        from openxml(xmlelement('root', @response), '/root/data')
            with(
                ActionDate STRING 'ActionDate',
                AddressId STRING' AddressId',
                CRMClientId STRING 'CRMClientId',
                CompanyId STRING 'CompanyId',
                CreateId STRING 'CreateId',
                CRMDbId STRING 'CRMDbId',
                CRMOrderDate STRING 'CRMOrderDate',
                CRMOrderNumber STRING 'CRMOrderNumber',
                CRMPayKindId STRING 'CRMPayKindId',
                CRMWareHouseId STRING 'CRMWareHouseId',
                PersonId STRING 'PersonId',
                StatusId STRING 'StatusId',
                Summa STRING 'Summa',
                WareHouseId STRING 'WareHouseId',
                DocumentTypeId STRING 'DocumentTypeId',
                PriceTypeId STRING 'PriceTypeId'
            )
        ) as t on t.CRMOrderNumber = bp.CRMOrder.CRMOrderNumber
    when not matched then insert
    when matched then update;

    set @schema = '
        <d name="CRMOrderLine">
            <f name="CRMOrderDate" type="Date" />
            <f name="CRMWareHouseId" type="String" />
            <f name="Price" type="Decimal" />
            <f name="LineNumber" type="Integer" />
            <f name="Quantity" type="Decimal" />
            <f name="UnitId" type="String" />
            <f name="WareHouseId" type="String" />
            <f name="WareId" type="String" />
        </d>';

    merge into bp.CRMOrderLine(
        CRMOrder,
        Price,
        Quantity,
        UnitId,
        WareHouseId,
        WareId
    ) using with auto name(
        select (
                select id
                from bp.CRMOrder
                where CRMOrderNumber = d.CRMOrderNumber
            ) as CRMOrder,
            f.Price,
            f.Quantity,
            f.UnitId,
            f.WareHouseId,
            f.WareId
        from openxml(xmlelement('root', @response), '/root/data')
            with(
                 CRMOrderNumber STRING 'CRMOrderNumber',
                 CRMOrderLine xml 'CRMOrderLine/@mp:xmltext'
            ) as d outer apply
                (
                    select *
                    from openxml(xmlelement('root', bp.xDataLinkResultSetFromDetail(d.CRMOrderLine, @schema)),'/root/data')
                        with (
                            Price STRING 'Price',
                            Quantity STRING 'Quantity',
                            UnitId STRING 'UnitId',
                            WareHouseId STRING 'WareHouseId',
                            WareId STRING 'WareId'
                        )

                ) as f
        ) as t on t.CRMOrder = bp.CRMOrderLine.CRMOrder
            and t.WareId = bp.CRMOrderLine.WareId
        when not matched then insert
        when matched then update;


    set @schema = '
        <d name="CRMOrderOption">
            <f name="CRMOrderDate" type="Date" />
            <f name="OptionTypeId" type="String" />
            <f name="Value" type="String" />
            <f name="OptionTypeName" type="String" />
        </d>';



end
;
