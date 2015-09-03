sa_make_object 'procedure', 'data', 'bp';

alter procedure bp.data(
    @url long varchar
)
begin
    declare @sql long varchar;
    declare @ddate varchar(24);
    declare @result xml;

    set @ddate = http_variable('date');

    set @sql = string(
        'set @result = (select * from bp.',
        @url, '(''', @ddate,  ''') ',
        'for xml auto, elements)'
    );

    --message 'bp.data @sql = ', @sql;

    execute immediate @sql;

    select @result;

end
;
