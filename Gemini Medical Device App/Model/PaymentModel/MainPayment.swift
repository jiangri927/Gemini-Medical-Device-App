
import Foundation
import UIKit
struct MainPayment: Codable {
    let success: Bool?
    let transaction: Transaction?

    enum CodingKeys: String, CodingKey {
        case success
        case transaction
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        success = try values.decodeIfPresent(Bool.self, forKey: .success)
        transaction = try values.decodeIfPresent(Transaction.self, forKey: .transaction)
    }
}

class PaymentGatewayResponse {
    class func paymentMethodResponse(viewcontroller: UIViewController, nonce: String, amount: String, WarrantyLength: String, UID: String, SerialNumber: String, Completion: @escaping ([Devices]) -> Swift.Void, Error: @escaping (Error) -> Swift.Void) {
        WebServiceClasses.shared.requestPOSTURLPayment(urlString!, progress: true, params: ["paymentMethodNonce": nonce as AnyObject, "WarrantyAmount": amount as AnyObject, "WarrantyLength": WarrantyLength as AnyObject, "token": userDefaults.string(forKey: logginToken) as AnyObject, "UID": UID as AnyObject, "SerialNumber": SerialNumber as AnyObject, "LoginID": userDefaults.string(forKey: loginObjId) as AnyObject], headers: nil, success: { dic in

            let jsonUser = JSON(dic)

            let objUserA = try! JSONDecoder().decode(ListResponce.self, from: jsonUser.rawData())
            if objUserA.status == "Error" {
                commonClass.showCustomeAlert(viewcontroller, messageA: objUserA.response ?? "No devices found", MessageColor: "red")
            } else {
                if let devicelist = objUserA.devices {
                    Completion(devicelist)
                }
            }

        }) { err in
            print(err)
            Error(err)
        }
    }

    class func warrantyStatusApi(viewcontroller: UIViewController, WarrantyConfirmation: String, WarrantyLength: String, SerialNumber: String, UID: String, Completion: @escaping ([Devices]) -> Swift.Void, Error: @escaping (Error) -> Swift.Void) {
        let params = [
            "LoginID": userDefaults.string(forKey: loginObjId),
            "token": userDefaults.string(forKey: logginToken),
            "SerialNumber": SerialNumber,
            "UID": UID,
            "WarrantyConfirmation": WarrantyConfirmation,
            "WarrantyLength": WarrantyLength,
        ]
        WebServiceClasses.shared.requestPOSTURL("warranty_confirmation.php", progress: true, params: params as [String: AnyObject], headers: nil, success: { dic in

            let jsonUser = JSON(dic)

            let objUserA = try! JSONDecoder().decode(ListResponce.self, from: jsonUser.rawData())
            if objUserA.status == "Error" {
                commonClass.showCustomeAlert(viewcontroller, messageA: objUserA.response ?? "No devices found", MessageColor: "red")
            } else {
                if let devicelist = objUserA.devices {
                    Completion(devicelist)
                }
            }

        }) { err in
            Error(err)
        }
    }
}
