/**
 * Copyright (c) 2012 Partners In Health.  All rights reserved.
 * The use and distribution terms for this software are covered by the
 * Eclipse Public License 1.0 (http://opensource.org/licenses/eclipse-1.0.php)
 * which can be found in the file epl-v10.html at the root of this distribution.
 * By using this software in any fashion, you are agreeing to be bound by
 * the terms of this license.
 * You must not remove this notice, or any other, from this software.
 **/
package org.pih.warehouse.order

import org.pih.warehouse.auth.AuthService
import org.pih.warehouse.core.Constants
import org.pih.warehouse.core.User

class OrderType implements Serializable {

    def beforeInsert() {
        createdBy = AuthService.currentUser
        updatedBy = AuthService.currentUser
    }

    def beforeUpdate() {
        updatedBy = AuthService.currentUser
    }

    String id
    String name
    String description
    String code
    OrderTypeCode orderTypeCode

    // Audit fields
    Date dateCreated
    Date lastUpdated
    User createdBy
    User updatedBy

    Boolean isReturnOrder() {
        return code == Constants.RETURN_ORDER
    }

    Boolean isPurchaseOrder() {
        return orderTypeCode == OrderTypeCode.PURCHASE_ORDER
    }

    Boolean isPutawayOrder() {
        return code == Constants.PUTAWAY_ORDER
    }

    Boolean isTransferOrder() {
        return orderTypeCode == OrderTypeCode.TRANSFER_ORDER
    }

    static mapping = {
        id generator: 'uuid'
    }

    static constraints = {
        name(nullable: false, unique: true, maxSize: 255)
        description(nullable: true, maxSize: 255)
        code(nullable: false, unique: true, maxSize: 100)
        orderTypeCode(nullable: false)

        updatedBy(nullable: true)
        createdBy(nullable: true)
    }
}
