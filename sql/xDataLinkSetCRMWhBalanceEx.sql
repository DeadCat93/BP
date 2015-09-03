create or replace procedure bp.xDataLinkSetCRMWhBalanceEx(
    @ddate datetime
)
begin
    declare @request xml;
    declare @response xml;
    declare @data xml;

    set @data = (
        select WareHouseId,
            DocumentDate,
            DocumentNumber,
            PersonId,
            WareId,
            UnitId,
            Quantity
        from bp.CRMWhBalanceEx
        where ddate = @ddate
        for xml auto
    );

    set @request = bp.xDataLinkMakeRequest('CRMWhBalanceEx', 'set', @data);
    set @response = bp.[xDataLink.RequestLog](@request);

end
;
