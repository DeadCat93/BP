create or replace function bp.xDataLinkMakeRequest(
    @schemeName STRING,
    @requestType STRING,
    @data xml default null,
    @ddate datetime default null
)
returns xml
begin
    declare @result xml;

    set @result = xmlelement('extdata',
        xmlattributes(util.getUserOption('xDataLink.user') as "user"),
        xmlelement('scheme',
            xmlattributes(@schemeName as "name", @requestType as "request"),
            bp.xDataLinkProcessScheme(@schemeName, @data, @ddate)
        )
    );

    set @result ='<?xml version="1.0" encoding="windows-1251"?>' + @result;

    return @result;

end
;
