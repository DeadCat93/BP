sa_make_object 'procedure', 'CRMOrderStatus', 'bp';

alter procedure bp.CRMOrderStatus(
    @ddate datetime default today()
)
begin

    select o.id,
        o.status,
        so.id as sale_order,
        so.status4 as sale_order_status4
    from bp.CRMOrder o left outer join dbo.sale_order so on o.sale_order = so.id
    where o.ts >= @ddate;

end
;
