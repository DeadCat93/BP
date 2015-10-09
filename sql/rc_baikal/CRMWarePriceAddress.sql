sa_make_object 'procedure', 'CRMWarePriceAddress', 'bp';

alter procedure bp.CRMWarePriceAddress(
    @ddate datetime default today()
)
begin

    select b.id as AddressId,
        pl.id as PriceTypeId
    from dbo.buyers b join dbo.partners p on b.partner = p.id
        join dbo.partner_plist ppl on ppl.partner = p.id
        join bp.pricelist pl on ppl.plist = pl.id;

end;
