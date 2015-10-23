create or replace procedure bp.xDataLinkSetCRMWarePrice(
    @ddate datetime
)
begin
    declare @request xml;
    declare @response xml;
    declare @data xml;

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
                    isnull(util.getUserOption('price.UnitId'), UnitId) as UnitId ,
                    Price
                from bp.CRMWarePrice
                where PriceDate = @ddate +1
                for xml auto
            )
        )
    );


    set @request = bp.xDataLinkMakeRequest('CRMWarePrice', 'set', @data, @ddate +1);
    set @response = bp.[xDataLink.RequestLog](@request);
    --call xp_write_file('c:\\temp\\data.xml', @data);
    --call xp_write_file('c:\\temp\\request.xml', @request);

end
;
