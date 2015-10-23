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
        '/f'
    );

    insert into #schema with auto name
    select id,
        name
    from openxml(@data, @path)
        with(name STRING '@name', id integer '@mp:id');

    set @sql = (
        select string(
                'declare local temporary table data(',
                list(name + ' STRING' order by id),
                ')'
            )
        from openxml(@data, @path)
            with(name STRING '@name', id integer '@mp:id')
    );

    execute immediate @sql;

    set @path = string(
        '/extdata/scheme/data/o/d',
        if @schemeName is not null then
            '[@name="' + @schemeName + '"]'
        endif,
        '/r/f'
    );

    for execs as statements cursor for
    select 'insert into data values(' + list('''' + replace(value, '''', '''''') + '''' order by id) + ')' as c_statement
    from openxml(@data, @path)
        with(value STRING '.', id integer '@mp:id', parentId integer '../@mp:id')
    group by parentId
    do
        --message c_statement;
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
