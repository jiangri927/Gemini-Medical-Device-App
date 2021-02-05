

import Foundation
struct CreditCard: Codable {
    let token: String?
    let uniqueNumberIdentifier: String?
    let last4: String?
    let durbinRegulated: String?
    let venmoSdk: Bool?
    let customerLocation: String?
    let payroll: String?
    let commercial: String?
    let healthcare: String?
    let globalId: String?
    let countryOfIssuance: String?
    let expirationMonth: String?
    let issuingBank: String?
    let cardType: String?
    let cardholderName: String?
    let bin: String?
    let productId: String?
    let debit: String?
    let prepaid: String?
    let imageUrl: String?
    let expirationYear: String?
    let accountType: String?

    enum CodingKeys: String, CodingKey {
        case token
        case uniqueNumberIdentifier
        case last4
        case durbinRegulated
        case venmoSdk
        case customerLocation
        case payroll
        case commercial
        case healthcare
        case globalId
        case countryOfIssuance
        case expirationMonth
        case issuingBank
        case cardType
        case cardholderName
        case bin
        case productId
        case debit
        case prepaid
        case imageUrl
        case expirationYear
        case accountType
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        token = try values.decodeIfPresent(String.self, forKey: .token)
        uniqueNumberIdentifier = try values.decodeIfPresent(String.self, forKey: .uniqueNumberIdentifier)
        last4 = try values.decodeIfPresent(String.self, forKey: .last4)
        durbinRegulated = try values.decodeIfPresent(String.self, forKey: .durbinRegulated)
        venmoSdk = try values.decodeIfPresent(Bool.self, forKey: .venmoSdk)
        customerLocation = try values.decodeIfPresent(String.self, forKey: .customerLocation)
        payroll = try values.decodeIfPresent(String.self, forKey: .payroll)
        commercial = try values.decodeIfPresent(String.self, forKey: .commercial)
        healthcare = try values.decodeIfPresent(String.self, forKey: .healthcare)
        globalId = try values.decodeIfPresent(String.self, forKey: .globalId)
        countryOfIssuance = try values.decodeIfPresent(String.self, forKey: .countryOfIssuance)
        expirationMonth = try values.decodeIfPresent(String.self, forKey: .expirationMonth)
        issuingBank = try values.decodeIfPresent(String.self, forKey: .issuingBank)
        cardType = try values.decodeIfPresent(String.self, forKey: .cardType)
        cardholderName = try values.decodeIfPresent(String.self, forKey: .cardholderName)
        bin = try values.decodeIfPresent(String.self, forKey: .bin)
        productId = try values.decodeIfPresent(String.self, forKey: .productId)
        debit = try values.decodeIfPresent(String.self, forKey: .debit)
        prepaid = try values.decodeIfPresent(String.self, forKey: .prepaid)
        imageUrl = try values.decodeIfPresent(String.self, forKey: .imageUrl)
        expirationYear = try values.decodeIfPresent(String.self, forKey: .expirationYear)
        accountType = try values.decodeIfPresent(String.self, forKey: .accountType)
    }
}
