create or replace function bp.xDataLinkResultSetFromResponse(
    @data xml,
    @schemeName STRING default null
)
returns xml
begin
    declare @sql STRING;
    declare @result xml;
    declare @path STRING;

    declare local temporary table #schema(
        id integer,
        name STRING,

        primary key(id)
    );

    set @path = string(
        '/extdata/scheme/data/s/d',
        if @schemeName is not null then
            '[@name="' + @schemeName + '"]'
        endif,
        '/*'
    );

    insert into #schema with auto name
    select id,
        name
    from openxml(@data, @path)
        with(
            name STRING '@name',
            id integer '@mp:id'
        );

    set @sql = (
        select string(
                'declare local temporary table data(',
                list(name + if localName = 'f' then ' STRING' else ' xml' endif order by id),
                ')'
            )
        from openxml(@data, @path)
            with(
                name STRING '@name',
                id integer '@mp:id',
                localName STRING '@mp:localname'
            )
    );

    message 'bp.xDataLinkResultSetFromResponse @sql = ', @sql to client;
    execute immediate @sql;

    set @path = string(
        '/extdata/scheme/data/o/d',
        if @schemeName is not null then
            '[@name="' + @schemeName + '"]'
        endif,
        '/r/*'
    );

    for execs as statements cursor for
    select 'insert into data values(' +
            list('''' +
                if localName = 'f' then
                    replace(value, '''', '''''')
                else
                    xmlValue
                endif +
                ''''
                order by id
            ) +
            ')' as c_statement
    from openxml(@data, @path)
        with(
            value STRING '.',
            xmlValue xml '@mp:xmltext',
            id integer '@mp:id',
            parentId integer '../@mp:id',
            localName STRING '@mp:localname'
        )
    group by parentId
    do
        message 'bp.xDataLinkResultSetFromResponse c_statement = ', c_statement to client;
        execute immediate c_statement;

    end for;

    set @result = (
        select *
        from data
        for xml auto, elements
    );

    return @result;

end
;
