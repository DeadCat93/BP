create table bp.CRMOrder(

    ActionDate STRING,
    AddressId STRING,
    CRMClientId STRING,
    CompanyId STRING,
    CreateId STRING,
    CRMDbId STRING,
    CRMOrderDate STRING,
    CRMOrderNumber STRING,
    CRMPayKindId STRING,
    CRMWareHouseId STRING,
    PersonId STRING,
    StatusId STRING,
    Summa STRING,
    WareHouseId STRING,
    DocumentTypeId STRING,
    PriceTypeId STRING,

    unique(CRMOrderNumber),

    status integer default 0,

    foreign key(sale_order) references dbo.sale_order on delete set null,

    id ID, xid GUID, ts TS, cts CTS,
    unique (xid), primary key (id)
)
;

create table bp.CRMOrderLine(

    Price STRING,
    Quantity STRING,
    UnitId STRING,
    WareHouseId STRING,
    WareId STRING,

    not null foreign key(CRMOrder) references bp.CRMOrder on delete cascade,

    id ID, xid GUID, ts TS, cts CTS,
    unique (xid), primary key (id)
)
;
