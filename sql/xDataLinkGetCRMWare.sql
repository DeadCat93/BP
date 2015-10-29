create or replace procedure bp.xDataLinkGetCRMWare()
begin
    declare @request xml;
    declare @response xml;

    set @request = bp.xDataLinkMakeRequest('CRMWare', 'get');
    set @response = bp.[xDataLink.RequestLog](@request);

    set @response = bp.xDataLinkResultSetFromResponse(@response);
    message 'bp.xDataLinkGetCRMWare @response result set end' to client;

    merge into bp.CRMWare(WareId, WareName, UnitId, UnitName ,Quantity)
    using with auto name(
        select WareId,
            WareName,
            UnitId,
            UnitName,
            Quantity
        from openxml(xmlelement('root', @response), '/root/data')
            with(
                WareId STRING 'WareId',
                WareName STRING 'WareName',
                UnitId STRING 'UnitId',
                UnitName STRING 'UnitName',
                Quantity decimal(18,4) 'Quantity'
            )
    ) as t on t.WareId = bp.CRMWare.WareId
        and t.UnitId = bp.CRMWare.UnitId
    when not matched then insert
    when matched then
    update
    set WareName = t.WareName,
        UnitName = t.UnitName,
        Quantity = t.Quantity;


end
;
