create or replace procedure bp.xDataLinkSetCRMDespatchEx(
    @ddate datetime
)
begin
    declare @request xml;
    declare @response xml;
    declare @data xml;

    set @data = (
        select CompanyId,
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
        from bp.CRMDespatchEx
        where ddate = @ddate
        for xml auto
    );

    set @request = bp.xDataLinkMakeRequest('CRMDespatchEx', 'set', @data, @ddate);
    set @response = bp.[xDataLink.RequestLog](@request);

end
;
