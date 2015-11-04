create or replace function bp.getDataLog(
    @url STRING,
    @date STRING
)
returns xml
begin
    declare @result xml;
    declare @xid GUID;

    set @xid = newid();

    insert into bp.baikalLog with auto name
    select @xid as xid,
        @url + '?' +@date as url;

    set @result = bp.getData(@url, @date);

    update bp.baikalLog
    set response = @result
    where xid = @xid;

    return @result;

end
;
