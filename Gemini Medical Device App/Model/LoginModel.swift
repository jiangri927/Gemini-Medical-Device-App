//
//  LoginModel.swift
//  Gemini Medical Device App
//
//  Created by TechnoMac-1 on 27/03/19.
//  Copyright © 2019 TechnoMac-1. All rights reserved.
//

import Foundation
import UIKit

struct Login: Codable {
    let status: String?
    let oBJID: String?
    let token: String?
    let response: String?
    enum CodingKeys: String, CodingKey {
        case status
        case oBJID = "OBJID"
        case token
        case response
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        oBJID = try values.decodeIfPresent(String.self, forKey: .oBJID)
        token = try values.decodeIfPresent(String.self, forKey: .token)
        response = try values.decodeIfPresent(String.self, forKey: .response)
    }
}

class LoginModel {
    class func LoginWebService(viewcontroller _: UIViewController, URL: String, dicSendData: [String: AnyObject], completionHandler: @escaping (Login) -> Swift.Void, failure: @escaping (Error) -> Void) {
        WebServiceClasses.shared.requestPOSTURL(URL, progress: true, params: dicSendData, headers: nil, success: { dic in
            if dic.count != 0 {
                userDefaults.setValue(dic, forKey: loggedInUserDictKey)

                completionHandler(commonClass.getloginDetails())
            }
        }) { err in
            failure(err)
        }
    }
}
