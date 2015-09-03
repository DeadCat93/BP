
create or replace function bp.[xDataLink.Request](
    XMLData STRING
)
returns xml
url 'http://crmlink.gkm.ru/xDataLink/xDataLink.asmx'
type 'SOAP:DOC'
set 'SOAP(OP=Request)'
namespace 'http://www.monolit.com/xDataLink/';
