create or replace function bp.xDataLinkPreprocessResponse(
    @data xml
)
returns xml
begin
    declare @result xml;

    set @result = (
        select data
        from openxml(@data, '/*/*/*:RequestResponse')
        with(data string '.')
    );

    return @result;

end
;
