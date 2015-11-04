create global temporary table bp.xDataLinkLog(

    request xml,
    response xml,
    responsePreprocessed xml,

    id ID, xid GUID, ts TS, cts CTS,
    unique (xid), primary key (id)
)  not transactional share by all
;
comment on table bp.xDataLinkLog is 'xDataLink sync log garbageCollected'
;

create global temporary table bp.baikalLog(

    url STRING,
    request xml,
    response xml,

    id ID, xid GUID, ts TS, cts CTS,
    unique (xid), primary key (id)
)  not transactional share by all
;
comment on table bp.baikalLog is 'Baikal sync log garbageCollected'
;
