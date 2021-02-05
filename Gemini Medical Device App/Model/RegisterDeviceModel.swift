//
//  RegisterDeviceModel.swift
//  Gemini Medical Device App
//
//  Created by TechnoMac-1 on 27/03/19.
//  Copyright © 2019 TechnoMac-1. All rights reserved.
//

import Foundation
import UIKit
class RegisterDeviceModel {
    class func RegisterDeviceWebService(viewcontroller: UIViewController, progress: Bool, DicData: [String: AnyObject], completionHandler: @escaping (Any) -> Swift.Void, failure: @escaping (Error) -> Void) {
        WebServiceClasses.shared.requestPOSTURL("register_device.php", progress: progress, params: DicData, headers: nil, success: { Response in
            if Response.count != 0 {
                completionHandler(Response)
            } else {
                commonClass.showCustomeAlert(viewcontroller, messageA: "Something wrong! \n Please try again", MessageColor: "red")
            }
        }) { err in
            failure(err)
        }
    }
}
