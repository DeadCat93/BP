create or replace procedure bp.xDataLinkExchange(
    @ddate datetime default today() -1,
    @syncCRMWare integer default 1,
    @syncCRMWhBalanceEx integer default 1,
    @syncCRMDespatchEx integer default 1,
    @syncCRMWarePrice integer default 1
)
begin

    -- get
    -- CRMWare
    if @syncCRMWare = 1 then
        call bp.xDataLinkGetCRMWare();
        commit;
    end if;

    -- set
    -- CRMWhBalanceEx
    if @syncCRMWhBalanceEx = 1 then
        call bp.xDataLinkSetCRMWhBalanceEx(@ddate);
    end if;

    -- syncCRMDespatchEx
    if @syncCRMDespatchEx = 1 then
        call bp.xDataLinkSetCRMDespatchEx(@ddate);
    end if;

    if @syncCRMWarePrice =  1 then
        call bp.xDataLinkSetCRMWarePrice(@ddate);
    end if;

    return;
end
;
