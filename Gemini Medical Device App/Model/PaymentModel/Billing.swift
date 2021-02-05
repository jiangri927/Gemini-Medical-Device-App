

import Foundation
struct Billing: Codable {
    let locality: String?
    let countryName: String?
    let streetAddress: String?
    let countryCodeAlpha3: String?
    let lastName: String?
    let countryCodeNumeric: String?
    let region: String?
    let id: String?
    let company: String?
    let firstName: String?
    let postalCode: String?
    let extendedAddress: String?
    let countryCodeAlpha2: String?

    enum CodingKeys: String, CodingKey {
        case locality
        case countryName
        case streetAddress
        case countryCodeAlpha3
        case lastName
        case countryCodeNumeric
        case region
        case id
        case company
        case firstName
        case postalCode
        case extendedAddress
        case countryCodeAlpha2
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        locality = try values.decodeIfPresent(String.self, forKey: .locality)
        countryName = try values.decodeIfPresent(String.self, forKey: .countryName)
        streetAddress = try values.decodeIfPresent(String.self, forKey: .streetAddress)
        countryCodeAlpha3 = try values.decodeIfPresent(String.self, forKey: .countryCodeAlpha3)
        lastName = try values.decodeIfPresent(String.self, forKey: .lastName)
        countryCodeNumeric = try values.decodeIfPresent(String.self, forKey: .countryCodeNumeric)
        region = try values.decodeIfPresent(String.self, forKey: .region)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        company = try values.decodeIfPresent(String.self, forKey: .company)
        firstName = try values.decodeIfPresent(String.self, forKey: .firstName)
        postalCode = try values.decodeIfPresent(String.self, forKey: .postalCode)
        extendedAddress = try values.decodeIfPresent(String.self, forKey: .extendedAddress)
        countryCodeAlpha2 = try values.decodeIfPresent(String.self, forKey: .countryCodeAlpha2)
    }
}
