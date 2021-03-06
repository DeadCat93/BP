create or replace function bp.xDataLinkProcessScheme(
    @schemeName STRING,
    @data xml,
    @ddate datetime default null
)
returns xml
begin
    declare @result xml;

    case @schemeName
        when 'CRMWhBalanceEx' then

            set @result = xmlelement('data',
                xmlelement('s',
                    xmlelement('d',
                        xmlattributes('CRMWhBalanceParam' as "name"),
                        bp.xDataLinkSchemeField('SkipDelete','Integer')
                    ),
                    xmlelement('d',
                        xmlattributes('CRMWhBalance' as "name"),
                        bp.xDataLinkSchemeField('WareHouseId','String'),
                        bp.xDataLinkSchemeField('DocumentDate','String'),
                        bp.xDataLinkSchemeField('DocumentNumber','String'),
                        bp.xDataLinkSchemeField('PersonId','String'),
                        xmlelement('d',
                            xmlattributes('CRMWhBalanceLine' as "name"),
                            bp.xDataLinkSchemeField('WareId','String'),
                            bp.xDataLinkSchemeField('UnitId','String'),
                            bp.xDataLinkSchemeField('Quantity','Currency')
                        )
                    )
                ),
                xmlelement('o',
                    xmlelement('d',
                        xmlattributes('CRMWhBalanceParam' as "name"),
                        xmlelement('r',
                            xmlelement('f', 0)
                        )
                    ),
                    xmlelement('d',
                        xmlattributes('CRMWhBalance' as "name"),
                        (
                            select xmlelement('r',
                                    xmlelement('f', WareHouseId),
                                    xmlelement('f', DocumentDate),
                                    xmlelement('f'),
                                    xmlelement('f'),
                                    xmlelement('d',
                                        xmlattributes('CRMWhBalanceLine' as "name"),
                                        xmlagg(
                                            xmlelement('r',
                                                xmlelement('f', WareId),
                                                xmlelement('f', UnitId),
                                                xmlelement('f', Quantity)
                                            )
                                        )
                                    )
                                )
                            from openxml(xmlelement('root', @data), '/root/CRMWhBalanceEx')
                                with(
                                    WareHouseId STRING '@WareHouseId',
                                    DocumentDate STRING '@DocumentDate',
                                    WareId STRING '@WareId',
                                    UnitId STRING '@UnitId',
                                    Quantity decimal(18,4) '@Quantity'
                                )
                            group by WareHouseId, DocumentDate
                        )
                    )

                )
            )
        when 'CRMDespatchEx' then

            set @result = xmlelement('data',
                xmlelement('s',
                    xmlelement('d',
                        xmlattributes('CRMDespatchParam' as "name"),
                        bp.xDataLinkSchemeField('WorkDate', 'Date'),
                        bp.xDataLinkSchemeField('SkipDelete', 'Integer'),
                        bp.xDataLinkSchemeField('IsSupplyConvertClients', 'Integer')
                    ),
                    xmlelement('d',
                        xmlattributes('CRMDespatch' as "name"),
                        bp.xDataLinkSchemeField('CompanyId', 'String'),
                        bp.xDataLinkSchemeField('AddressId', 'String'),
                        bp.xDataLinkSchemeField('AddressRegionType', 'String'),
                        bp.xDataLinkSchemeField('SaleChannel', 'String'),
                        bp.xDataLinkSchemeField('CRMOrderNumber', 'String'),
                        bp.xDataLinkSchemeField('CRMOrderDate', 'String'),
                        bp.xDataLinkSchemeField('DocumentTypeId', 'String'),
                        bp.xDataLinkSchemeField('DocumentNumber', 'String'),
                        bp.xDataLinkSchemeField('DocumentDate', 'Date'),
                        bp.xDataLinkSchemeField('PayDate', 'Date'),
                        bp.xDataLinkSchemeField('WareHouseId', 'String'),
                        bp.xDataLinkSchemeField('WareId', 'String'),
                        bp.xDataLinkSchemeField('Price', 'Currency'),
                        bp.xDataLinkSchemeField('Quantity', 'Currency')
                    ),
                    xmlelement('d',
                        xmlattributes('CRMClientAddress' as "name"),
                        bp.xDataLinkSchemeField('CRMClientId', 'String'),
                        bp.xDataLinkSchemeField('CompanyId', 'String'),
                        bp.xDataLinkSchemeField('CompanyName', 'String'),
                        bp.xDataLinkSchemeField('AddressId', 'String'),
                        bp.xDataLinkSchemeField('AddressName', 'String'),
                        bp.xDataLinkSchemeField('Location', 'String')
                    )
                ),
                xmlelement('o',
                    xmlelement('d',
                        xmlattributes('CRMDespatchParam' as "name"),
                        xmlelement('r',
                            xmlelement('f', @ddate),
                            xmlelement('f', 0),
                            xmlelement('f', 1)
                        )
                    ),
                    xmlelement('d',
                        xmlattributes('CRMDespatch' as "name"),
                        (
                            select xmlagg(
                                    xmlelement('r',
                                        xmlelement('f', CompanyId),
                                        xmlelement('f', AddressId),
                                        xmlelement('f'),
                                        xmlelement('f'),
                                        xmlelement('f'),
                                        xmlelement('f'),
                                        xmlelement('f', DocumentTypeId),
                                        xmlelement('f', DocumentNumber),
                                        xmlelement('f', DocumentDate),
                                        xmlelement('f', PayDate),
                                        xmlelement('f', WareHouseId),
                                        xmlelement('f', WareId),
                                        xmlelement('f', Price),
                                        xmlelement('f', Quantity)
                                    )
                                )
                            from openxml(xmlelement('root', @data), '/root/CRMDespatchEx')
                                with(
                                    CompanyId STRING '@CompanyId',
                                    AddressId STRING '@AddressId',
                                    AddressRegionType STRING '@AddressRegionType',
                                    SaleChannel STRING '@SaleChannel',
                                    CRMOrderNumber STRING '@CRMOrderNumber',
                                    CRMOrderDate STRING '@CRMOrderDate',
                                    DocumentTypeId STRING '@DocumentTypeId',
                                    DocumentNumber STRING '@DocumentNumber',
                                    DocumentDate STRING '@DocumentDate',
                                    PayDate STRING '@PayDate',
                                    WareHouseId STRING '@WareHouseId',
                                    WareId STRING '@WareId',
                                    Price decimal(18,2) '@Price',
                                    Quantity decimal(18,2) '@Quantity'
                                )

                        )
                    ),
                    xmlelement('d',
                        xmlattributes('CRMClientAddress' as "name"),
                        (
                            select xmlagg(
                                    xmlelement('r',
                                        xmlelement('f'),
                                        xmlelement('f', CompanyId),
                                        xmlelement('f', CompanyName),
                                        xmlelement('f', AddressId),
                                        xmlelement('f', AddressName),
                                        xmlelement('f', Location)
                                    )
                                )
                            from (
                                select CRMClientId,
                                    CompanyId,
                                    min(CompanyName) as CompanyName,
                                    min(AddressId) as AddressId,
                                    min(AddressName) as AddressName,
                                    min(Location) as Location
                                from openxml(xmlelement('root', @data), '/root/CRMDespatchEx')
                                    with(
                                        CRMClientId STRING '@CRMClientId',
                                        CompanyId STRING '@CompanyId',
                                        CompanyName STRING '@CompanyName',
                                        AddressId STRING '@AddressId',
                                        AddressName STRING '@AddressName',
                                        Location STRING '@Location'
                                    ) as tt
                                where tt.CompanyId is not null
                                group by tt.CRMClientId, tt.CompanyId
                            ) as t

                        )
                    )
                )
            )

    when 'CRMWarePrice' then

    set @result = xmlelement('data',
            xmlelement('s',
                xmlelement('d',
                    xmlattributes('CRMWareRangePrice' as "name"),
                    bp.xDataLinkSchemeField('PriceDate', 'Date'),
                    bp.xDataLinkSchemeField('PriceTypeId', 'String'),
                    bp.xDataLinkSchemeField('WareId', 'String'),
                    bp.xDataLinkSchemeField('UnitId', 'String'),
                    bp.xDataLinkSchemeField('Price', 'Currency')
                ),
                xmlelement('d',
                    xmlattributes('CRMWareRangeLink' as "name"),
                    bp.xDataLinkSchemeField('PriceTypeId', 'String'),
                    bp.xDataLinkSchemeField('CompanyId', 'String'),
                    bp.xDataLinkSchemeField('AddressId', 'String')
                )
            ),
            xmlelement('o',
                xmlelement('d',
                    xmlattributes('CRMWareRangePrice' as "name"),
                    (
                        select xmlagg(
                                xmlelement('r',
                                    xmlelement('f', PriceDate),
                                    xmlelement('f', PriceTypeId),
                                    xmlelement('f', WareId),
                                    xmlelement('f', UnitId),
                                    xmlelement('f', Price)
                                )
                            )
                        from openxml(xmlelement('root', @data), '/root/CRMWarePrice')
                            with(
                                PriceDate STRING '@PriceDate',
                                PriceTypeId STRING '@PriceTypeId',
                                WareId STRING '@WareId',
                                UnitId STRING '@UnitId',
                                Price STRING '@Price'
                            )
                    )
                ),
                xmlelement('d',
                    xmlattributes('CRMWareRangeLink' as "name"),
                    (
                        select xmlagg(
                                xmlelement('r',
                                    xmlelement('f', PriceTypeId),
                                    xmlelement('f', CompanyId),
                                    xmlelement('f', AddressId)
                                )
                            )
                        from openxml(xmlelement('root', @data), '/root/PriceAddress')
                            with(
                                PriceTypeId STRING '@PriceTypeId',
                                CompanyId STRING '@CompanyId',
                                AddressId STRING '@AddressId'
                            )
                    )
                )
            )
        );

    when 'CRMOrderStatus' then

        set @result = xmlelement('data',
                xmlelement('s',
                    xmlelement('d',
                        xmlattributes('CRMOrderStatus' as "name"),
                        bp.xDataLinkSchemeField('CRMOrderNumber', 'String'),
                        bp.xDataLinkSchemeField('StatusId', 'String'),
                        bp.xDataLinkSchemeField('UserName', 'String'),
                        bp.xDataLinkSchemeField('HostName', 'String'),
                        bp.xDataLinkSchemeField('OperationTime', 'String'),
                        bp.xDataLinkSchemeField('Comment', 'String')
                    )
                ),
                xmlelement('o',
                    xmlelement('d',
                        xmlattributes('CRMOrderStatus' as "name"),
                        (
                            select xmlagg(
                                    xmlelement('r',
                                        xmlelement('f', CRMOrderNumber),
                                        xmlelement('f', StatusId),
                                        xmlelement('f', ''),
                                        xmlelement('f', ''),
                                        xmlelement('f', OperationTime),
                                        xmlelement('f', '')
                                    )
                                )
                            from openxml(xmlelement('root', @data), '/root/CRMOrder')
                                with(
                                    CRMOrderNumber STRING '@CRMOrderNumber',
                                    StatusId STRING '@StatusId',
                                    OperationTime STRING '@OperationTime'
                                )
                        )
                    )
                )
            );

    end case;

    return @result;
end;
