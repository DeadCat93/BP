create or replace function bp.xDataLinkSchemeField(
    @name STRING,
    @type STRING
)
returns xml
begin
    declare @result xml;

    set @result = xmlelement('f',
        xmlattributes(@name as "name", @type as "type")
    );

    return @result;
end
;
