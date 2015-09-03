create or replace function bp.getData(
    url STRING,
    [date] STRING
)
returns xml
url '!url'
type 'http:get'
;
