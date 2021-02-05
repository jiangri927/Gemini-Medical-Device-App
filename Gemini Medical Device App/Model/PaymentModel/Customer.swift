

import Foundation
struct Customer: Codable {
    let id: String?
    let company: String?
    let firstName: String?
    let lastName: String?
    let email: String?
    let website: String?
    let phone: String?
    let fax: String?

    enum CodingKeys: String, CodingKey {
        case id
        case company
        case firstName
        case lastName
        case email
        case website
        case phone
        case fax
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        company = try values.decodeIfPresent(String.self, forKey: .company)
        firstName = try values.decodeIfPresent(String.self, forKey: .firstName)
        lastName = try values.decodeIfPresent(String.self, forKey: .lastName)
        email = try values.decodeIfPresent(String.self, forKey: .email)
        website = try values.decodeIfPresent(String.self, forKey: .website)
        phone = try values.decodeIfPresent(String.self, forKey: .phone)
        fax = try values.decodeIfPresent(String.self, forKey: .fax)
    }
}
