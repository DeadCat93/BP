create or replace procedure bp.xDataLinkGetCRMOrder()
begin

    declare @request xml;
    declare @response xml;

    set @request = bp.xDataLinkMakeRequest('CRMOrder', 'get');
    set @response = bp.[xDataLink.RequestLog](@request);

    set @response = bp.xDataLinkResultSetFromResponse(@response, 'CRMOrder');

    select @response;

end
;
