grant connect to bp;
grant dba to bp;

sa_make_object 'view', 'CRMWare', 'bp';

alter view bp.CRMWare
as
select pg.code as WareId,
    'ШТ' as UnitId,
    pg.goods as id
from dbo.partner_goods pg
where pg.partner in(47010)
and pg.code is not null
;

sa_make_object 'view', 'CRMWareHouse', bp;

alter view bp.CRMWareHouse
as
select
    1 as WareHouseId,
    s.id
from dbo.storages s
where s.id in (3101)
;

sa_make_object 'view', 'sellers', bp;

alter view bp.sellers
as
select s.id
from dbo.sellers s
where s.partner in(47010)
;

sa_make_object 'view', 'pricelist', bp;

alter view bp.pricelist
as
select pl.id
from dbo.pricelist pl
where pl.id = 10007
;
