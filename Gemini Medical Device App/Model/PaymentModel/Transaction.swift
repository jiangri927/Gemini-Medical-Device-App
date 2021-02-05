/* Technostacks */

import Foundation
struct Transaction: Codable {
    let processorAuthorizationCode: String?
    let avsPostalCodeResponseCode: String?
    let gatewayRejectionReason: String?
    let subscriptionId: String?
    let currencyIsoCode: String?
    let refundedTransactionId: String?
    let subMerchantAccountId: String?
    let merchantAccountId: String?
    let avsStreetAddressResponseCode: String?
    let discounts: [String]?
    let globalId: String?
    let partialSettlementTransactionGlobalIds: [String]?
    let status: String?
    let createdAt: CreatedAt?
    let shipping: Shipping?
    let processorResponseText: String?
    let type: String?
    let channel: String?
    let planId: String?
    let processorSettlementResponseCode: String?
    let shippingDetails: ShippingDetails?
    let id: String?
    let subscriptionDetails: SubscriptionDetails?
    let authorizationExpiresAt: AuthorizationExpiresAt?
    let recurring: Bool?
    let disbursementDetails: DisbursementDetails?
    let taxExempt: Bool?
    let subscription: Subscription?
    let creditCard: CreditCard?
    let addOns: [String]?
    let disputes: [String]?
    let authorizedTransactionId: String?
    let descriptor: Descriptor?
    let billing: Billing?
    let authorizationAdjustments: [String]?
    let partialSettlementTransactionIds: [String]?
    let cvvResponseCode: String?
    let statusHistory: [StatusHistory]?
    let taxAmount: String?
    let processorResponseType: String?
    let processorSettlementResponseText: String?
    let refundGlobalIds: [String]?
    let customFields: String?
    let networkTransactionId: String?
    let customer: Customer?
    let customerDetails: CustomerDetails?
    let amount: String?
    let refundId: String?
    let orderId: String?
    let shippingAmount: String?
    let additionalProcessorResponse: String?
    let refundedTransactionGlobalId: String?
    let purchaseOrderNumber: String?
    let shipsFromPostalCode: String?
    let avsErrorResponseCode: String?
    let authorizedTransactionGlobalId: String?
    let creditCardDetails: CreditCardDetails?
    let threeDSecureInfo: String?
    let updatedAt: UpdatedAt?
    let masterMerchantAccountId: String?
    let discountAmount: String?
    let voiceReferralNumber: String?
    let processorResponseCode: String?
    let billingDetails: BillingDetails?
    let refundIds: [String]?
    let paymentInstrumentType: String?
    let serviceFeeAmount: String?
    let settlementBatchId: String?
    let escrowStatus: String?

    enum CodingKeys: String, CodingKey {
        case processorAuthorizationCode
        case avsPostalCodeResponseCode
        case gatewayRejectionReason
        case subscriptionId
        case currencyIsoCode
        case refundedTransactionId
        case subMerchantAccountId
        case merchantAccountId
        case avsStreetAddressResponseCode
        case discounts
        case globalId
        case partialSettlementTransactionGlobalIds
        case status
        case createdAt
        case shipping
        case processorResponseText
        case type
        case channel
        case planId
        case processorSettlementResponseCode
        case shippingDetails
        case id
        case subscriptionDetails
        case authorizationExpiresAt
        case recurring
        case disbursementDetails
        case taxExempt
        case subscription
        case creditCard
        case addOns
        case disputes
        case authorizedTransactionId
        case descriptor
        case billing
        case authorizationAdjustments
        case partialSettlementTransactionIds
        case cvvResponseCode
        case statusHistory
        case taxAmount
        case processorResponseType
        case processorSettlementResponseText
        case refundGlobalIds
        case customFields
        case networkTransactionId
        case customer
        case customerDetails
        case amount
        case refundId
        case orderId
        case shippingAmount
        case additionalProcessorResponse
        case refundedTransactionGlobalId
        case purchaseOrderNumber
        case shipsFromPostalCode
        case avsErrorResponseCode
        case authorizedTransactionGlobalId
        case creditCardDetails
        case threeDSecureInfo
        case updatedAt
        case masterMerchantAccountId
        case discountAmount
        case voiceReferralNumber
        case processorResponseCode
        case billingDetails
        case refundIds
        case paymentInstrumentType
        case serviceFeeAmount
        case settlementBatchId
        case escrowStatus
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        processorAuthorizationCode = try values.decodeIfPresent(String.self, forKey: .processorAuthorizationCode)
        avsPostalCodeResponseCode = try values.decodeIfPresent(String.self, forKey: .avsPostalCodeResponseCode)
        gatewayRejectionReason = try values.decodeIfPresent(String.self, forKey: .gatewayRejectionReason)
        subscriptionId = try values.decodeIfPresent(String.self, forKey: .subscriptionId)
        currencyIsoCode = try values.decodeIfPresent(String.self, forKey: .currencyIsoCode)
        refundedTransactionId = try values.decodeIfPresent(String.self, forKey: .refundedTransactionId)
        subMerchantAccountId = try values.decodeIfPresent(String.self, forKey: .subMerchantAccountId)
        merchantAccountId = try values.decodeIfPresent(String.self, forKey: .merchantAccountId)
        avsStreetAddressResponseCode = try values.decodeIfPresent(String.self, forKey: .avsStreetAddressResponseCode)
        discounts = try values.decodeIfPresent([String].self, forKey: .discounts)
        globalId = try values.decodeIfPresent(String.self, forKey: .globalId)
        partialSettlementTransactionGlobalIds = try values.decodeIfPresent([String].self, forKey: .partialSettlementTransactionGlobalIds)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        createdAt = try values.decodeIfPresent(CreatedAt.self, forKey: .createdAt)
        shipping = try values.decodeIfPresent(Shipping.self, forKey: .shipping)
        processorResponseText = try values.decodeIfPresent(String.self, forKey: .processorResponseText)
        type = try values.decodeIfPresent(String.self, forKey: .type)
        channel = try values.decodeIfPresent(String.self, forKey: .channel)
        planId = try values.decodeIfPresent(String.self, forKey: .planId)
        processorSettlementResponseCode = try values.decodeIfPresent(String.self, forKey: .processorSettlementResponseCode)
        shippingDetails = try values.decodeIfPresent(ShippingDetails.self, forKey: .shippingDetails)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        subscriptionDetails = try values.decodeIfPresent(SubscriptionDetails.self, forKey: .subscriptionDetails)
        authorizationExpiresAt = try values.decodeIfPresent(AuthorizationExpiresAt.self, forKey: .authorizationExpiresAt)
        recurring = try values.decodeIfPresent(Bool.self, forKey: .recurring)
        disbursementDetails = try values.decodeIfPresent(DisbursementDetails.self, forKey: .disbursementDetails)
        taxExempt = try values.decodeIfPresent(Bool.self, forKey: .taxExempt)
        subscription = try values.decodeIfPresent(Subscription.self, forKey: .subscription)
        creditCard = try values.decodeIfPresent(CreditCard.self, forKey: .creditCard)
        addOns = try values.decodeIfPresent([String].self, forKey: .addOns)
        disputes = try values.decodeIfPresent([String].self, forKey: .disputes)
        authorizedTransactionId = try values.decodeIfPresent(String.self, forKey: .authorizedTransactionId)
        descriptor = try values.decodeIfPresent(Descriptor.self, forKey: .descriptor)
        billing = try values.decodeIfPresent(Billing.self, forKey: .billing)
        authorizationAdjustments = try values.decodeIfPresent([String].self, forKey: .authorizationAdjustments)
        partialSettlementTransactionIds = try values.decodeIfPresent([String].self, forKey: .partialSettlementTransactionIds)
        cvvResponseCode = try values.decodeIfPresent(String.self, forKey: .cvvResponseCode)
        statusHistory = try values.decodeIfPresent([StatusHistory].self, forKey: .statusHistory)
        taxAmount = try values.decodeIfPresent(String.self, forKey: .taxAmount)
        processorResponseType = try values.decodeIfPresent(String.self, forKey: .processorResponseType)
        processorSettlementResponseText = try values.decodeIfPresent(String.self, forKey: .processorSettlementResponseText)
        refundGlobalIds = try values.decodeIfPresent([String].self, forKey: .refundGlobalIds)
        customFields = try values.decodeIfPresent(String.self, forKey: .customFields)
        networkTransactionId = try values.decodeIfPresent(String.self, forKey: .networkTransactionId)
        customer = try values.decodeIfPresent(Customer.self, forKey: .customer)
        customerDetails = try values.decodeIfPresent(CustomerDetails.self, forKey: .customerDetails)
        amount = try values.decodeIfPresent(String.self, forKey: .amount)
        refundId = try values.decodeIfPresent(String.self, forKey: .refundId)
        orderId = try values.decodeIfPresent(String.self, forKey: .orderId)
        shippingAmount = try values.decodeIfPresent(String.self, forKey: .shippingAmount)
        additionalProcessorResponse = try values.decodeIfPresent(String.self, forKey: .additionalProcessorResponse)
        refundedTransactionGlobalId = try values.decodeIfPresent(String.self, forKey: .refundedTransactionGlobalId)
        purchaseOrderNumber = try values.decodeIfPresent(String.self, forKey: .purchaseOrderNumber)
        shipsFromPostalCode = try values.decodeIfPresent(String.self, forKey: .shipsFromPostalCode)
        avsErrorResponseCode = try values.decodeIfPresent(String.self, forKey: .avsErrorResponseCode)
        authorizedTransactionGlobalId = try values.decodeIfPresent(String.self, forKey: .authorizedTransactionGlobalId)
        creditCardDetails = try values.decodeIfPresent(CreditCardDetails.self, forKey: .creditCardDetails)
        threeDSecureInfo = try values.decodeIfPresent(String.self, forKey: .threeDSecureInfo)
        updatedAt = try values.decodeIfPresent(UpdatedAt.self, forKey: .updatedAt)
        masterMerchantAccountId = try values.decodeIfPresent(String.self, forKey: .masterMerchantAccountId)
        discountAmount = try values.decodeIfPresent(String.self, forKey: .discountAmount)
        voiceReferralNumber = try values.decodeIfPresent(String.self, forKey: .voiceReferralNumber)
        processorResponseCode = try values.decodeIfPresent(String.self, forKey: .processorResponseCode)
        billingDetails = try values.decodeIfPresent(BillingDetails.self, forKey: .billingDetails)
        refundIds = try values.decodeIfPresent([String].self, forKey: .refundIds)
        paymentInstrumentType = try values.decodeIfPresent(String.self, forKey: .paymentInstrumentType)
        serviceFeeAmount = try values.decodeIfPresent(String.self, forKey: .serviceFeeAmount)
        settlementBatchId = try values.decodeIfPresent(String.self, forKey: .settlementBatchId)
        escrowStatus = try values.decodeIfPresent(String.self, forKey: .escrowStatus)
    }
}
