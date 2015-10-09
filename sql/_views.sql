create or replace view bp.Address
as select distinct
    AddressId,
    CompanyId
from bp.CRMDespatchEx
;
