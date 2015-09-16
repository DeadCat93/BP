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
