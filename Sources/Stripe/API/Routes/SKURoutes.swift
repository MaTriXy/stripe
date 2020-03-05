//
//  SKURoutes.swift
//  Stripe
//
//  Created by Andrew Edwards on 8/22/17.
//
//

import Vapor

public protocol SKURoutes {
    func create(id: String?, currency: StripeCurrency, inventory: StripeInventory, price: Int, product: String, active: Bool?, attributes: [String]?, image: String?, metadata: [String: String]?, packageDimensions: StripePackageDimensions?) throws -> Future<StripeSKU>
    func retrieve(id: String) throws -> Future<StripeSKU>
    func update(sku: String, active: Bool?, attributes: [String]?, currency: StripeCurrency?, image: String?, inventory: StripeInventory?, metadata: [String: String]?, packageDimensions: StripePackageDimensions?, price: Int?, product: String?) throws -> Future<StripeSKU>
    func listAll(filter: [String: Any]?) throws -> Future<SKUList>
    func delete(sku: String) throws -> Future<StripeDeletedObject>
}

extension SKURoutes {
    public func create(id: String? = nil,
                       currency: StripeCurrency,
                       inventory: StripeInventory,
                       price: Int,
                       product: String,
                       active: Bool? = nil,
                       attributes: [String]? = nil,
                       image: String? = nil,
                       metadata: [String: String]? = nil,
                       packageDimensions: StripePackageDimensions? = nil) throws -> Future<StripeSKU> {
        return try create(id: id,
                          currency: currency,
                          inventory: inventory,
                          price: price,
                          product: product,
                          active: active,
                          attributes: attributes,
                          image: image,
                          metadata: metadata,
                          packageDimensions: packageDimensions)
    }
    
    public func retrieve(id: String) throws -> Future<StripeSKU> {
        return try retrieve(id: id)
    }
    
    public func update(sku: String,
                       active: Bool? = nil,
                       attributes: [String]? = nil,
                       currency: StripeCurrency? = nil,
                       image: String? = nil,
                       inventory: StripeInventory? = nil,
                       metadata: [String: String]? = nil,
                       packageDimensions: StripePackageDimensions? = nil,
                       price: Int? = nil,
                       product: String? = nil) throws -> Future<StripeSKU> {
        return try update(sku: sku,
                          active: active,
                          attributes: attributes,
                          currency: currency,
                          image: image,
                          inventory: inventory,
                          metadata: metadata,
                          packageDimensions: packageDimensions,
                          price: price,
                          product: product)
    }
    
    public func listAll(filter: [String: Any]? = nil) throws -> Future<SKUList> {
        return try listAll(filter: filter)
    }
    
    public func delete(sku: String) throws -> Future<StripeDeletedObject> {
        return try delete(sku: sku)
    }
}

public struct StripeSKURoutes: SKURoutes {
    private let request: StripeRequest
    
    init(request: StripeRequest) {
        self.request = request
    }

    /// Create a SKU
    /// [Learn More →](https://stripe.com/docs/api/curl#create_sku)
    public func create(id: String?,
                       currency: StripeCurrency,
                       inventory: StripeInventory,
                       price: Int,
                       product: String,
                       active: Bool?,
                       attributes: [String]?,
                       image: String?,
                       metadata: [String: String]?,
                       packageDimensions: StripePackageDimensions?) throws -> Future<StripeSKU> {
        var body: [String: Any] = [:]
        
        body["currency"] = currency.rawValue
        try inventory.toEncodedDictionary().forEach { body["inventory[\($0)]"] = $1 }
        body["price"] = price
        body["product"] = product
        
        if let active = active {
            body["active"] = active
        }
        
        if let attributes = attributes {
            for i in 0..<attributes.count {
                body["attributes[\(i)]"] = attributes[i]
            }
        }

        if let image = image {
            body["image"] = image
        }
        
        if let metadata = metadata {
            metadata.forEach { key,value in
                body["metadata[\(key)]"] = value
            }
        }
        
        if let packageDimensions = packageDimensions {
            try packageDimensions.toEncodedDictionary().forEach { body["package_dimensions[\($0)]"] = $1 }
        }
        
        return try request.send(method: .POST, path: StripeAPIEndpoint.sku.endpoint, body: body.queryParameters)
    }
    
    /// Retrieve a SKU
    /// [Learn More →](https://stripe.com/docs/api/curl#retrieve_sku)
    public func retrieve(id: String) throws -> Future<StripeSKU> {
        return try request.send(method: .GET, path: StripeAPIEndpoint.skus(id).endpoint)
    }
    
    /// Update a SKU
    /// [Learn More →](https://stripe.com/docs/api/curl#update_sku)
    public func update(sku: String,
                       active: Bool?,
                       attributes: [String]?,
                       currency: StripeCurrency?,
                       image: String?,
                       inventory: StripeInventory?,
                       metadata: [String: String]?,
                       packageDimensions: StripePackageDimensions?,
                       price: Int?,
                       product: String?) throws -> Future<StripeSKU> {
        var body: [String: Any] = [:]
        
        if let active = active {
            body["active"] = active
        }
        
        if let attributes = attributes {
            for i in 0..<attributes.count {
                body["attributes[\(i)]"] = attributes[i]
            }
        }
        
        if let currency = currency {
            body["currency"] = currency.rawValue
        }
        
        if let inventory = inventory {
            try inventory.toEncodedDictionary().forEach { body["inventory[\($0)]"] = $1 }
        }
        
        if let metadata = metadata {
            metadata.forEach { key,value in
                body["metadata[\(key)]"] = value
            }
        }
        
        if let packageDimensions = packageDimensions {
            try packageDimensions.toEncodedDictionary().forEach { body["package_dimensions[\($0)]"] = $1 }
        }
        
        if let price = price {
            body["price"] = price
        }
        
        if let product = product {
            body["product"] = product
        }
        
        return try request.send(method: .POST, path: StripeAPIEndpoint.skus(sku).endpoint, body: body.queryParameters)
    }
    
    /// List all SKUs
    /// [Learn More →](https://stripe.com/docs/api/curl#list_skus)
    public func listAll(filter: [String: Any]?) throws -> Future<SKUList> {
        var queryParams = ""
        if let filter = filter {
            queryParams = filter.queryParameters
        }
        
        return try request.send(method: .GET, path: StripeAPIEndpoint.sku.endpoint, query: queryParams)
    }
    
    /// Delete a SKU
    /// [Learn More →](https://stripe.com/docs/api/curl#delete_sku)
    public func delete(sku: String) throws -> Future<StripeDeletedObject> {
        return try request.send(method: .DELETE, path: StripeAPIEndpoint.skus(sku).endpoint)
    }
}
