call sa_make_object('service', 'bpPost')
;
alter service bpPost
TYPE 'RAW'
authorization off user "bp"
url on
as call bp.[post]();
