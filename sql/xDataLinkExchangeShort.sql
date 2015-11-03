create or replace procedure bp.xDataLinkExchangeShort()
begin

    call bp.xDataLinkGetCRMOrder();

    call bp.xDataLinkSetCRMOrderStatus();

    return;

end
;
