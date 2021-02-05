
import Foundation
struct Procedures: Codable {
    let oBJID: String?
    let name: String?
    let count: String?
    var PbBar: Float {
        if count == nil {
            return 0.001
        } else {
            return Float(count ?? "0.0")!
        }
    }

    enum CodingKeys: String, CodingKey {
        case oBJID = "OBJID"
        case name = "Name"
        case count
        // case pbbar = "pbvalue"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        oBJID = try values.decodeIfPresent(String.self, forKey: .oBJID)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        count = try values.decodeIfPresent(String.self, forKey: .count)
        //     PbBar = try values.decodeIfPresent(Float.self, forKey: .pbbar)
    }
}
