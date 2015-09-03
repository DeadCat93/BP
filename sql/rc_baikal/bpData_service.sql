call sa_make_object('service', 'bpData')
;
alter service bpData
TYPE 'RAW'
authorization off user "bp"
url on
as call bp.data(:url);
