create or replace procedure bp.xDataLinkSetCRMOrderStatus()
begin
	declare @request xml;
	declare @response xml;
	declare @data xml;
	declare @ts datetime;

	set @ts = now();

	set @data = (
		select CRMOrderNumber,
			case status
				when 0 then 'Transfered'
				when 1 then 'Dispatched'
			end as StartusId,
			ts as OperationTime
		from bp.CRMOrder
		where ts > isnull(
				util.getUserOption('bp.orderStatusTs'),
				'1971-07-25'
			)
		for xml auto
	);

	call util.setUserOption('bp.orderStatusTs', cast(@ts as varchar(32)));

	set @request = bp.xDataLinkMakeRequest('CRMOrderStatus', 'set', @data);
	set @response = bp.[xDataLink.RequestLog](@request);

end
;
