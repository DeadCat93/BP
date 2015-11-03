create or replace procedure bp.postBaikalData(
    @url STRING default 'http://10.25.2.16/rc_baikal9/bpPost'
)
begin
    declare @ts datetime;
    declare @cts datetime;
    declare @request xml;
    declare @response xml;

    set @cts = now();
    set @ts = isnull(
        util.getUserOption('bp.orderPostTs'),
        '1971-07-25'
    );

    set @request = xmlelement('data',
        (
            select *
            from bp.CRMOrder
            where ts > @ts
            for xml auto
        ),
        (
            select *
            from bp.CRMOrderLine
            where ts > @ts
            for xml auto
        )
    );

    message 'bp.postBaikalData @request = ', @request;

    set @response = util.httpsPost (
        @url,
        'Cat:Cat',
        'file="dummy"',
        @request
    );

    call util.setUserOption('bp.orderPostTs', cast(@cts as varchar(32)));


end
;
