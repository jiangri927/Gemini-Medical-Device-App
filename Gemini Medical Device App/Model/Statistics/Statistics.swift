
import Foundation
import UIKit
struct Statistics: Codable {
    let procedures: [Procedures]?
//    var maxVal : Float {
//        let max = procedures!.max(by: { (a, b) -> Bool in
//
//            return a.PbBar < b.PbBar
//        })
//        return (max?.PbBar)!
//    }
    let modes: [Modes]?

    enum CodingKeys: String, CodingKey {
        case procedures = "Procedures"
        case modes = "Modes"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        procedures = try values.decodeIfPresent([Procedures].self, forKey: .procedures)
        modes = try values.decodeIfPresent([Modes].self, forKey: .modes)
    }
}

class StatisticsModel {
    class func StatisticsService(viewcontroller _: UIViewController, URL: String, dicSendData: [String: AnyObject], completionHandler: @escaping (Statistics) -> Swift.Void, failure: @escaping (Error) -> Void) {
        WebServiceClasses.shared.requestPOSTURL(URL, progress: true, params: dicSendData, headers: nil, success: { dic in
            let jsonUser = JSON(dic)
            let objUserA = try! JSONDecoder().decode(Statistics.self, from: jsonUser.rawData())
            completionHandler(objUserA)
        }) { err in

            failure(err)
        }
    }
}
