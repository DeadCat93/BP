create or replace procedure bp.xDataLinkExchange(
    @ddate datetime default today() -1,
    @syncCRMWare integer default 0,
    @syncCRMWhBalanceEx integer default 0,
    @syncCRMDespatchEx integer default 1
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

    return;
end
;
