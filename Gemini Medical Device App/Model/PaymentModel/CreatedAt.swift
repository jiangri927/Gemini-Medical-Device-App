/* Technostacks */

import Foundation
struct CreatedAt: Codable {
    let date: String?
    let timezone: String?
    let timezone_type: Int?

    enum CodingKeys: String, CodingKey {
        case date
        case timezone
        case timezone_type
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        date = try values.decodeIfPresent(String.self, forKey: .date)
        timezone = try values.decodeIfPresent(String.self, forKey: .timezone)
        timezone_type = try values.decodeIfPresent(Int.self, forKey: .timezone_type)
    }
}
