call sa_make_object('service', 'console')
;
alter service console
TYPE 'RAW'
authorization off user "bp"
url on
as call bp.console(:url);
