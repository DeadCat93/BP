create or replace procedure bp.console(
    @command STRING
)
begin
    declare @msg STRING;
    declare @result xml;

    declare local temporary table #cmd(
        num integer,
        value STRING,

        primary key(num)
    );

    declare local temporary table #var(
        name STRING,
        value STRING,

        primary key(name)
    );

    insert into #cmd with auto name
    select line_num as num,
        row_value as value
    from dbo.sa_split_list(@command, '/');

    insert into #var with auto name
    select name,
        value
    from util.httpVariables();

    case (
            select value
            from #cmd
            where num = 1
        )
        when 'exchangePeriod' then

            trigger event exchangePeriod(
                startDate = (
                    select value
                    from #var
                    where name = 'start'
                )
            );

            set @msg = 'Exchange period started';

        else

            set @msg = 'Unknown command';

    end case;

    set @result = xmlelement('result', @msg);

    select @result;

end
;
