create global temporary table bp.xDataLinkLog(

    schemeName STRING,

    request xml,
    response xml,
    responsePreprocessed xml,

    id ID, xid GUID, ts TS, cts CTS,
    unique (xid), primary key (id)
)  not transactional share by all
;
comment on table bp.xDataLinkLog is 'xDataLink sync log garbageCollected'
;
