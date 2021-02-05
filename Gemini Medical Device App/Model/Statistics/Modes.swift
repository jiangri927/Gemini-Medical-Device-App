
import Foundation
struct Modes: Codable {
    let mode_810: String?
    let mode_980: String?
    let mode_Dual: String?

    enum CodingKeys: String, CodingKey {
        case mode_810 = "Mode_810"
        case mode_980 = "Mode_980"
        case mode_Dual = "Mode_Dual"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        mode_810 = try values.decodeIfPresent(String.self, forKey: .mode_810)
        mode_980 = try values.decodeIfPresent(String.self, forKey: .mode_980)
        mode_Dual = try values.decodeIfPresent(String.self, forKey: .mode_Dual)
    }
}
