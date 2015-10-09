create or replace procedure bp.xDataLinkSetCRMWarePrice(
    @ddate datetime
)
begin
    declare @request xml;
    declare @response xml;
    declare @data xml;

    set @ddate = @ddate +1;

    set @data = (
        xmlconcat(
            (
                select *
                from (
                        select a.AddressId,
                            a.CompanyId,
                            pa.PriceTypeId
                        from bp.Address a join bp.CRMWarePriceAddress pa on a.AddressId = pa.AddressId
                    ) as PriceAddress
                for xml auto
            ),
            (
                select PriceDate,
                    PriceTypeId,
                    WareId,
                    UnitId,
                    Price
                from bp.CRMWarePrice
                where PriceDate = @ddate
                for xml auto
            )
        )
    );


    set @request = bp.xDataLinkMakeRequest('CRMWarePrice', 'set', @data, @ddate);
    set @response = bp.[xDataLink.RequestLog](@request);
    --call xp_write_file('c:\\temp\\data.xml', @data);
    --call xp_write_file('c:\\temp\\request.xml', @request);

end
;
