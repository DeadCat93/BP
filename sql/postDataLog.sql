create or replace function bp.postDataLog(
    @url STRING,
    @request xml
)
returns xml
begin
    declare @result xml;
    declare @xid GUID;

    set @xid = newid();

    insert into bp.baikalLog with auto name
    select @xid as xid,
        @url as url,
        @request as request;

    set @result = util.httpsPost (
        @url,
        'Cat:Cat',
        'file="dummy"',
        @request
    );

    update bp.baikalLog
    set response = @result
    where xid = @xid;

    return @result;

end
;
