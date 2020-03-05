//
//  CustomerList.swift
//  Stripe
//
//  Created by Anthony Castelli on 4/20/17.
//
//

/**
 Customers List
 https://stripe.com/docs/api/curl#list_customers
 */

public struct StripeCustomersList: StripeModel {
    public var object: String
    public var hasMore: Bool
    public var totalCount: Int?
    public var url: String?
    public var data: [StripeCustomer]?
    
    public enum CodingKeys: String, CodingKey {
        case object
        case hasMore = "has_more"
        case totalCount = "total_count"
        case url
        case data
    }
}
