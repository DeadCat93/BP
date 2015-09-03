create or replace function bp.xDataLinkResultSetFromResponse(
    @data xml
)
returns xml
begin
    declare @sql STRING;
    declare @result xml;

    declare local temporary table #schema(
        id integer,
        name STRING,

        primary key(id)
    );

    insert into #schema with auto name
    select id,
        name
    from openxml(@data, '/extdata/scheme/data/s/d/f')
        with(name STRING '@name', id integer '@mp:id');

    set @sql = (
        select string(
                'declare local temporary table data(',
                list(name + ' STRING' order by id),
                ')'
            )
        from openxml(@data, '/extdata/scheme/data/s/d/f')
            with(name STRING '@name', id integer '@mp:id')
    );

    execute immediate @sql;

    for execs as statements cursor for
    select 'insert into data values(' + list('''' + replace(value, '''', '''''') + '''' order by id) + ')' as c_statement
    from openxml(@data, '/extdata/scheme/data/o/d/r/f')
        with(value STRING '.', id integer '@mp:id', parentId integer '../@mp:id')
    group by parentId
    do
        --message c_statement;
        execute immediate c_statement;

    end for;

    set @Result = (
        select *
        from data
        for xml auto, elements
    );

    return @result;

end
;
