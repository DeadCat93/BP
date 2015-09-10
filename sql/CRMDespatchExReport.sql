create or replace procedure bp.CRMDespatchExReport(
    @ddate datetime
)
begin

    select DocumentTypeId,
        documentdate,
        documentnumber,
        paydate,
        companyname,
        location,
        (select top 1 warename from bp.CRMWare where WareId = d.WareId) as WareName,
        price,
        quantity
    from bp.CRMDespatchEx d
    where ddate = @ddate
    order by 1,2,3;

end
;
