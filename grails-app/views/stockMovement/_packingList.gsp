<%@page import="org.pih.warehouse.inventory.LotStatusCode" %>
<g:set var="shipmentInstance" value="${stockMovement?.shipment}"/>
<g:set var="shipmentItemsByContainer" value="${shipmentInstance?.shipmentItems?.groupBy { it.container } }"/>
<style>
    .recalled {
        background-color: #ffcccb;
    }
</style>
<div id="packingList" class="box dialog">
    <h2>
        <img src="${resource(dir:'images/icons/silk',file:'package.png')}" alt="contents" style="vertical-align: middle"/>
        ${warehouse.message(code:'shipping.packingList.label')}
    </h2>
    <table>
        <tr>
            <th></th>
            <th><warehouse:message code="shipping.container.label"/></th>
            <g:if test="${shipmentInstance?.isFromPurchaseOrder}">
                <th><warehouse:message code="order.orderNumber.label"/></th>
            </g:if>
            <th><warehouse:message code="product.productCode.label"/></th>
            <th><warehouse:message code="product.label"/></th>
            <th class="left">
                <warehouse:message code="inventoryItem.binLocation.label" default="Bin Location"/>
                <g:if test="${shipmentInstance?.origin?.id == session.warehouse?.id}">
                    <small><warehouse:message code="location.picking.label"/></small>
                </g:if>
                <g:elseif test="${shipmentInstance?.destination?.id == session.warehouse?.id}">
                    <small><warehouse:message code="location.putaway.label"/></small>
                </g:elseif>
            </th>
            <th class="left"><warehouse:message code="default.lotSerialNo.label"/></th>
            <th class="center"><warehouse:message code="default.expires.label"/></th>
            <th class="center"><warehouse:message code="shipmentItem.quantityShipped.label"/></th>
            <g:if test="${shipmentInstance?.wasReceived()||shipmentInstance?.wasPartiallyReceived()}">
                <th class="center"><warehouse:message code="shipmentItem.quantityReceived.label" default="Received"/></th>
                <th class="center"><warehouse:message code="shipmentItem.quantityCanceled.label" default="Canceled"/></th>
            </g:if>
            <th><warehouse:message code="product.uom.label"/></th>
            <th><warehouse:message code="shipping.recipient.label"/></th>
            <th class="left"><warehouse:message code="default.comment.label"/></th>
            <th><warehouse:message code="shipmentItem.isFullyReceived.label" default="Received?"/></th>
        </tr>
        <g:if test="${shipmentInstance?.shipmentItems}">
            <g:set var="count" value="${0 }"/>
            <g:set var="previousContainer" value=""/>
            <g:each var="shipmentItem" in="${shipmentInstance.sortShipmentItemsBySortOrder()}" status="i">
                <g:set var="rowspan" value="${shipmentItemsByContainer[shipmentItem?.container]?.size() }"/>
                <g:set var="newContainer" value="${previousContainer != shipmentItem?.container }"/>
                <tr class="prop ${(count++ % 2 == 0)?'odd':'even'} ${newContainer?'new-container':''} ${shipmentItem?.hasRecalledLot?'recalled':''} shipmentItem">
                    <td>
                        <g:if test="${shipmentItem?.hasRecalledLot}">
                            <div data-toggle="tooltip" data-placement="top" title="${g.message(code:'inventoryItem.recalledLot.label')}">
                                %{-- &#x24C7; = hexadecimal circled letter R --}%
                                <b>&#x24C7;</b>
                            </div>
                        </g:if>
                    </td>
                    <g:if test="${newContainer }">
                        <td class="top left" rowspan="${rowspan}">
                            <g:set var="container" value="${shipmentItem?.container}"/>
                            <label><g:if test="${container?.parentContainer}">${container?.parentContainer?.name }&nbsp;&rsaquo;&nbsp;</g:if><g:if test="${container?.name }">${container?.name }</g:if><g:else><warehouse:message code="shipping.unpacked.label"/></g:else></label>
                            <g:if test="${showDetails}">
                                <div class="fade">
                                    <g:if test="${container?.weight || container?.width || container?.length || container?.height}">
                                        <g:if test="${container?.weight}">
                                            ${container?.weight} ${container?.weightUnits}
                                        </g:if>
                                        <g:if test="${container?.height && container?.width && container?.length }">
                                            ${container.height} ${container?.volumeUnits} x ${container.width} ${container?.volumeUnits} x ${container.length} ${container?.volumeUnits}
                                        </g:if>
                                    </g:if>
                                </div>
                            </g:if>
                        </td>
                    </g:if>
                    <g:if test="${shipmentInstance?.isFromPurchaseOrder}">
                        <td>
                            ${shipmentItem?.orderNumber}
                        </td>
                    </g:if>
                    <td>
                        ${shipmentItem?.inventoryItem?.product?.productCode}
                    </td>
                    <td class="product">
                        <g:link controller="inventoryItem" action="showStockCard" id="${shipmentItem?.inventoryItem?.product?.id}">
                            <cache:block key="${shipmentItem?.id}">
                                <format:displayNameWithColor product="${shipmentItem?.inventoryItem?.product}" showTooltip="${true}" />
                                <g:renderHandlingIcons product="${shipmentItem?.inventoryItem?.product}" />
                            </cache:block>
                        </g:link>
                    </td>
                    <td>
                        <g:if test="${shipmentInstance?.origin?.id == session.warehouse?.id}">
                            <g:if test="${shipmentItem?.binLocation}">
                                ${shipmentItem?.binLocation?.name}
                            </g:if>
                            <g:else>
                                ${g.message(code:'default.label')}
                            </g:else>
                        </g:if>
                        <g:elseif test="${shipmentInstance?.destination?.id == session?.warehouse?.id}">
                            <g:if test="${shipmentItem?.receiptItems}">
                                <g:each var="receiptItem" in="${shipmentItem?.receiptItems.sort { it.sortOrder }}">
                                    <div style="margin-bottom: 10px;" title="${receiptItem?.quantityReceived} ${receiptItem?.inventoryItem?.product?.unitOfMeasure?:'EA'}">
                                        ${receiptItem?.binLocation?.name?:g.message(code:'default.label')}
                                    </div>
                                </g:each>
                            </g:if>
                        </g:elseif>
                    </td>
                    <td class="lotNumber">
                        <g:if test="${shipmentItem?.receiptItems}">
                            <g:each var="receiptItem" in="${shipmentItem?.receiptItems.sort { it.sortOrder }}">
                                <div style="margin-bottom: 10px;" title="${receiptItem?.quantityReceived} ${receiptItem?.inventoryItem?.product?.unitOfMeasure?:'EA'}">
                                    ${receiptItem?.lotNumber}
                                </div>
                            </g:each>
                        </g:if>
                        <g:else>
                            ${shipmentItem?.inventoryItem?.lotNumber}
                        </g:else>
                    </td>
                    <td class="center expirationDate" nowrap="nowrap">
                        <g:if test="${shipmentItem?.receiptItems}">
                            <g:each var="receiptItem" in="${shipmentItem?.receiptItems.sort { it.sortOrder }}">
                                <div style="margin-bottom: 10px;" title="${receiptItem?.quantityReceived} ${receiptItem?.inventoryItem?.product?.unitOfMeasure?:'EA'}">
                                    <g:if test="${receiptItem?.expirationDate}">
                                        <span class="expirationDate">
                                            <g:formatDate date="${receiptItem?.expirationDate}" format="d MMM yyyy"/>
                                        </span>
                                    </g:if>
                                    <g:else>
                                        <span class="fade">
                                            ${warehouse.message(code: 'default.never.label')}
                                        </span>
                                    </g:else>
                                </div>
                            </g:each>
                        </g:if>
                        <g:elseif test="${shipmentItem?.inventoryItem?.expirationDate}">
                            <span class="expirationDate">
                                <g:formatDate date="${shipmentItem?.inventoryItem?.expirationDate}" format="d MMM yyyy"/>
                            </span>
                        </g:elseif>
                        <g:else>
                            <span class="fade">
                                ${warehouse.message(code: 'default.never.label')}
                            </span>
                        </g:else>
                    </td>
                    <td class="center quantity">
                        <g:formatNumber number="${shipmentItem?.quantity}" format="###,##0" />
                    </td>
                    <g:if test="${shipmentInstance?.wasReceived()||shipmentInstance?.wasPartiallyReceived()}">
                        <td class="center" style="white-space:nowrap;${shipmentItem?.quantityReceived() != shipmentItem?.quantity ? ' color:red;' : ''}">
                            <g:formatNumber number="${shipmentItem?.quantityReceived()}" format="###,##0"/>
                        </td>
                        <td class="center" style="white-space:nowrap;${shipmentItem?.quantityReceived() != shipmentItem?.quantity ? ' color:red;' : ''}">
                            <g:formatNumber number="${shipmentItem?.quantityCanceled()}" format="###,##0"/>
                        </td>
                    </g:if>
                    <td>
                        ${shipmentItem?.inventoryItem?.product?.unitOfMeasure?:warehouse.message(code:'default.each.label')}
                    </td>
                    <td class="left" nowrap="nowrap">
                        <g:if test="${shipmentItem?.receiptItems}">
                            <g:each var="receiptItem" in="${shipmentItem?.receiptItems.sort { it.sortOrder }}">
                                <div style="margin-bottom: 10px;" title="${receiptItem?.quantityReceived} ${receiptItem?.inventoryItem?.product?.unitOfMeasure?:'EA'}">
                                    ${receiptItem?.recipient?.name?:g.message(code:'default.none.label')}
                                </div>
                            </g:each>
                        </g:if>
                        <g:elseif test="${shipmentItem?.recipient }">
                            <div title="${shipmentItem?.recipient?.email}">${shipmentItem?.recipient?.name}</div>
                        </g:elseif>
                        <g:else>
                            <div class="fade"><warehouse:message code="default.none.label"/></div>
                        </g:else>
                    </td>
                    <td class="left" >
                        <g:if test="${shipmentItem?.comments}">
                            <div title="${shipmentItem?.comments.join("\r\n")}">
                                <img src="${resource(dir:'images/icons/silk',file:'note.png')}" />
                            </div>
                        </g:if>
                        <g:else>
                            <div class="fade"><warehouse:message code="default.empty.label"/></div>
                        </g:else>
                    </td>
                    <td>
                        <g:message code="default.boolean.${shipmentItem?.isFullyReceived()}"/>
                    </td>
                </tr>
                <g:set var="previousContainer" value="${shipmentItem.container }"/>
            </g:each>
        </g:if>
        <g:else>
            <tr>
                <td colspan="11" class="middle center fade empty">
                    <warehouse:message code="shipment.noShipmentItems.message"/>
                </td>
            </tr>
        </g:else>

    </table>
</div>
