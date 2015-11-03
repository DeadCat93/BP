create event bp.bpProcessor
schedule bpProcessor
between '6:06AM'  and '23:01PM'
every 10 minutes on  ('Mon','Tue','Wed','Thu','Fri','Sat','Sun')
handler
begin

    call bp.processor();

exception
when others then
    call util.errorHandler('slv.slv_syncAutoFix', SQLSTATE, errormsg());
    rollback;

end
;
