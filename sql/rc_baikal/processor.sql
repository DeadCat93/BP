sa_make_object 'procedure', 'processor', 'bp';

alter procedure bp.processor()
begin
    declare @storage integer;
    declare @sale_dep integer;
    declare @measure integer;
    declare @id integer;
    declare @dbnumber integer;
    declare @org integer;

    set @storage = 3101;
    set @sale_dep = 1263;
    set @measure = 2078;
    set @org = 1100;

    set @dbnumber = (
        select dbnumber
        from dbo.cat_info
    );

    for processing as orders cursor for
    select o.id as c_id,
        cast(replace(o.ActionDate, 'T', ' ') as date) as c_ActionDate,
        cast(o.AddressId as integer) as c_AddressId,
        o.CRMOrderNumber as c_CRMOrderNumber,
        (
            select p.id
            from dbo.partners p join dbo.buyers b on p.id = b.partner
            where b.id = c_AddressId
        ) as c_partner
    from bp.CRMOrder o
    where status = 0
    do

        set @id = isnull(
            (
                select max(id)
                from dbo.sale_order
                where mod(id, 1000) = @dbnumber
            ),
            @dbnumber
        ) +1000;

        insert into dbo.sale_order with auto name
        select @id as id,
            @sale_dep as sdep,
            c_CRMOrderNumber as ndoc,
            greater(c_ActionDate, today()) as ddate,
            greater(c_ActionDate, today()) as sddate,
            c_partner as partner,
            0 as loadtype,
            0 as pcheck;

        insert into dbo.sordclient with auto name
        select @id as id,
            c_AddressId as client,
            @org as org,
            0 as stax,
            0 as stinc;

        insert into dbo.sordgoods with auto name
        select @id as id,
            number(*) as subid,
            0 as link,
            pg.goods,
            c_AddressId as client,
            @storage as storage,
            @measure as measure,
            @measure as pmeas,
            0 as currency,
            l.Price,
            l.Quantity as volume
        from  bp.CRMOrderLine l join dbo.partner_goods pg on l.WareId = pg.code
        where l.CRMOrder  = c_id;

        update bp.CRMOrder
        set sale_order = @id,
            status = 1
        where id = c_id;

    end for;

end
;
