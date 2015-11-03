create or replace function bp.xDataLinkResultSetFromDetail(
    @data xml,
    @schema xml
)
returns xml
begin
    declare @sql STRING;
    declare @result xml;
    declare @path STRING;
    declare @columns STRING;

    declare local temporary table #schema(
        id integer,
        name STRING,

        primary key(id)
    );

    set @path = '/d/f';

    insert into #schema with auto name
    select id,
        name
    from openxml(@schema, @path)
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
        from openxml(@schema, @path)
            with(
                name STRING '@name',
                id integer '@mp:id',
                localName STRING '@mp:localname'
            )
    );

    execute immediate @sql;

    set @path = '*/d/r/*';

    for execs as statements cursor for
    select 'insert into data()' +
        ' values(' +
            list('''' +
                if localName = 'f' then
                    replace(value, '''', '''''')
                else
                    xmlValue
                endif +
                ''''
                order by id
            ) +
        ')' as c_statement,
        count(*) as c_cnt
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
        set @columns = (
            select list(name)
            from (
                select top c_cnt
                    name
                from #schema
                order by id
            ) as t
        );

        set c_statement = replace(c_statement, 'data()', 'data(' + @columns + ')');

        --message 'bp.xDataLinkResultSetFromResponse c_statement = ', c_statement to client;
        execute immediate c_statement;

    end for;

    set @sql = string(
        'set @result = (',
        'select ',
        (
            select list(name order by id)
            from #schema
        ),
        ' from data for xml auto, elements)'
    );

    execute immediate @sql;

    return @result;

end
;
