create or replace function bp.[xDataLink.RequestLog](
    @request xml
)
returns xml
begin
    declare @result xml;
    declare @xid GUID;

    set @xid = newid();

    insert into bp.xDataLinkLog with auto name
    select @xid as xid,
        @request as request;

    set @result = bp.[xDataLink.Request](@request);

    update bp.xDataLinkLog
    set response = @result
    where xid = @xid;

    set @result = bp.xDataLinkPreprocessResponse(@result);

    update bp.xDataLinkLog
    set responsePreprocessed = @result
    where xid = @xid;

    return @result;

end
;
