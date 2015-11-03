grant connect to bp;
grant dba to bp;

create table bp.CRMWhBalanceEx(

    ddate datetime not null,
    WareHouseId varchar(128) not null,
    DocumentDate varchar(128),
    DocumentNumber varchar(128),
    PersonId varchar(128),

    WareId varchar(128) not null,
    UnitId varchar(128) not null,
    Quantity integer,

    unique(ddate, WareHouseId, WareId, UnitId),

    id ID, xid GUID, ts TS, cts CTS,
    unique (xid), primary key (id)
)
;

create table bp.CRMWare(

    WareId STRING not null,
    WareName STRING,
    UnitId STRING not null,
    UnitName STRING,

    Quantity decimal(18,4),

    unique(WareId, UnitId),

    id ID, xid GUID, ts TS, cts CTS,
    unique (xid), primary key (id)
)
;

create table bp.CRMDespatchEx(

    ddate datetime not null,
    bid integer not null,
    bsubid integer not null,
    CompanyId STRING,
    AddressId STRING,
    AddressRegionType STRING,
    SaleChannel STRING,
    CRMOrderNumber STRING,
    CRMOrderDate STRING,
    DocumentTypeId STRING,
    DocumentNumber STRING,
    DocumentDate STRING,
    PayDate STRING,
    WareHouseId STRING,
    WareId STRING,
    Price decimal(18,2),
    Quantity integer,
    CRMClientId STRING,
    CompanyName STRING,
    AddressName STRING,
    Location STRING,

    unique(bid, bsubid),

    id ID, xid GUID, ts TS, cts CTS,
    unique (xid), primary key (id)
)
;

create index xk_bp_CRMDespatchEx_AddressId on bp.CRMDespatchEx(AddressId);

create table bp.CRMWarePrice(

    PriceDate datetime,
    PriceTypeId integer,
    WareId STRING not null,
    UnitId STRING not null,

    Price decimal(18,2),

    unique(PriceDate, PriceTypeId, WareId),

    id ID, xid GUID, ts TS, cts CTS,
    unique (xid), primary key (id)
)
;

create table bp.CRMWarePriceAddress(

    PriceTypeId integer,
    AddressId integer,

    id ID, xid GUID, ts TS, cts CTS,
    unique (xid), primary key (id)
)
;

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
    sale_order integer,

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

create table bp.
