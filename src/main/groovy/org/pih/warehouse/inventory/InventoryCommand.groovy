/**
 * Copyright (c) 2012 Partners In Health.  All rights reserved.
 * The use and distribution terms for this software are covered by the
 * Eclipse Public License 1.0 (http://opensource.org/licenses/eclipse-1.0.php)
 * which can be found in the file epl-v10.html at the root of this distribution.
 * By using this software in any fashion, you are agreeing to be bound by
 * the terms of this license.
 * You must not remove this notice, or any other, from this software.
 **/
package org.pih.warehouse.inventory

import grails.validation.Validateable
import org.pih.warehouse.core.Location
import org.pih.warehouse.core.Tag
import org.pih.warehouse.product.Category
import org.pih.warehouse.product.ProductCatalog
import org.pih.warehouse.product.ProductType
import org.pih.warehouse.shipping.Shipment


class InventoryCommand implements Validateable {

    List<Tag> tags
    List<ProductCatalog> catalogs
    List<ProductType> productTypes

    Shipment shipment
    Category category
    Location location
    String searchTerms
    List searchResults = []

    // indicates whether to display hidden products
    Boolean showHiddenProducts = Boolean.FALSE
    // indicates whether unsupported products for the warehouse should be included
    Boolean showUnsupportedProducts = Boolean.FALSE
    // indicates whether non-inventory products for the warehouse should be included
    Boolean showNonInventoryProducts = Boolean.FALSE
    // indicates whether out of stock products for the warehouse should be included
    Boolean showOutOfStockProducts = Boolean.FALSE

    // all of the resulting ProductCommands above, organized by Category
    Boolean searchPerformed = Boolean.FALSE

    Integer offset = 0
    Integer maxResults = 0
    Integer totalCount = 0


    static constraints = {
        shipment(nullable: true)
        location(nullable: true)
        searchTerms(nullable: true)
        category(nullable: true)
        showHiddenProducts(nullable: true)
        showUnsupportedProducts(nullable: true)
        showNonInventoryProducts(nullable: true)
        showOutOfStockProducts(nullable: true)
        searchPerformed(nullable: true)
    }
}
