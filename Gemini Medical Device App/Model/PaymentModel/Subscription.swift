/* Technostacks */

import Foundation
struct Subscription: Codable {
    let billingPeriodStartDate: String?
    let billingPeriodEndDate: String?

    enum CodingKeys: String, CodingKey {
        case billingPeriodStartDate
        case billingPeriodEndDate
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        billingPeriodStartDate = try values.decodeIfPresent(String.self, forKey: .billingPeriodStartDate)
        billingPeriodEndDate = try values.decodeIfPresent(String.self, forKey: .billingPeriodEndDate)
    }
}
