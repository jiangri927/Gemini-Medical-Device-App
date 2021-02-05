//
//  DeviceList.swift
//  Gemini Medical Device App
//
//  Created by TechnoMac-1 on 01/04/19.
//  Copyright © 2019 TechnoMac-1. All rights reserved.
//

import Foundation
import UIKit

struct ListResponce: Codable {
    let status: String?
    let devices: [Devices]?
    let response: String?
    enum CodingKeys: String, CodingKey {
        case status
        case devices
        case response
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        devices = try values.decodeIfPresent([Devices].self, forKey: .devices)
        response = try values.decodeIfPresent(String.self, forKey: .response)
    }
}

class Devices: Codable, Equatable {
    static func == (lhs: Devices, rhs: Devices) -> Bool {
        return lhs.serialNumber == rhs.serialNumber &&
            lhs.uID == rhs.uID &&
            lhs.nickname == rhs.nickname &&
            lhs.warrantyLength == rhs.warrantyLength &&
            lhs.warrantyStartDate == rhs.warrantyStartDate &&
            lhs.dateTime == rhs.dateTime
    }

    var serialNumber: String?
    var uID: String?
    var nickname: String?
    var warrantyStartDate: String?
    var warrantyLength: Int?
    var isOnline: Bool?
    var dateTime: Date? = nil

    enum CodingKeys: String, CodingKey {
        case serialNumber = "SerialNumber"
        case uID = "UID"
        case nickname = "Nickname"
        case warrantyStartDate = "WarrantyStartDate"
        case warrantyLength = "WarrantyLength"
        case isOnline
        case dateTime
    }

    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        serialNumber = try values.decodeIfPresent(String.self, forKey: .serialNumber)
        uID = try values.decodeIfPresent(String.self, forKey: .uID)
        nickname = try values.decodeIfPresent(String.self, forKey: .nickname)
        warrantyStartDate = try values.decodeIfPresent(String.self, forKey: .warrantyStartDate)
        warrantyLength = try values.decodeIfPresent(Int.self, forKey: .warrantyLength)
        isOnline = try values.decodeIfPresent(Bool.self, forKey: .isOnline)
    }

    init(serialNumber: String, uID: String, nickname: String, warrantyStartDate: String, warrantyLength: Int, isOnline: Bool, dateTime: Date) {
        self.serialNumber = serialNumber
        self.uID = uID
        self.nickname = nickname
        self.warrantyLength = warrantyLength
        self.warrantyStartDate = warrantyStartDate
        self.isOnline = isOnline
        self.dateTime = dateTime
    }
}

// MARK: - Device list call class ...

class deviceList {
    class func DeviceListWebService(viewcontroller: UIViewController, progress: Bool, dicSendData: [String: AnyObject], completionHandler: @escaping (Any) -> Swift.Void, failure _: @escaping (Error) -> Void) {
        WebServiceClasses.shared.requestPOSTURL("device_list.php", progress: progress, params: dicSendData, headers: nil, success: { dic in
            if dic.count != 0 {
                let jsonUser = JSON(dic)

                let objUserA = try! JSONDecoder().decode(ListResponce.self, from: jsonUser.rawData())
                if objUserA.status == "Error" {
                    //commonClass.showCustomeAlert(viewcontroller, messageA: objUserA.response ?? "No devices found", MessageColor: "red")
                    completionHandler(dic)
                    
                } else {
                    if let devicelist = objUserA.devices {
                        completionHandler(dic)
                    }
                }
            }
        }) { err in
            commonClass.showCustomeAlert(viewcontroller, messageA: err.localizedDescription, MessageColor: "red")
        }
    }

    // MARK: - Device Name  class ...

    class func DeviceNameInMenu(viewcontroller _: UIViewController, progress: Bool, dicSendData: [String: AnyObject], completionHandler: @escaping (Any) -> Swift.Void, failure _: @escaping (Error) -> Void) {
        WebServiceClasses.shared.requestPOSTURL("device_list.php", progress: progress, params: dicSendData, headers: nil, success: { dic in
            if dic.count != 0 {
                let jsonUser = JSON(dic)

                let objUserA = try! JSONDecoder().decode(ListResponce.self, from: jsonUser.rawData())
                if objUserA.status == "Error" {
                    print(objUserA.status)
                    completionHandler(dic)
                } else {
                    if let devicelist = objUserA.devices {
                        completionHandler(dic)
                    }
                }
            }
        }) { err in
            print(err.localizedDescription)
        }
    }
}

// MARK: - Edit Nick Name class

class EditNickName {
    class func DeviceNameEditWebService(viewcontroller: UIViewController, progress: Bool, dicSendData: [String: AnyObject], completionHandler: @escaping (Any) -> Swift.Void, failure _: @escaping (Error) -> Void) {
        WebServiceClasses.shared.requestPOSTURL("edit_device.php", progress: progress, params: dicSendData, headers: nil, success: { dic in
            if dic.count != 0 {
                if dic["status"] as! String == "Error" {
                    //commonClass.showCustomeAlert(viewcontroller, messageA: dic["response"] as? String ?? "No devices found", MessageColor: "red")
                } else {
                    completionHandler(dic)
                }
            }
        }) { err in
            commonClass.showCustomeAlert(viewcontroller, messageA: err.localizedDescription, MessageColor: "red")
        }
    }
}

// MARK: - Device Delete class ...

class DeleteDevice {
    class func DeviceNameDeleteWebService(viewcontroller: UIViewController, progress: Bool, dicSendData: [String: AnyObject], completionHandler: @escaping (Any) -> Swift.Void, failure _: @escaping (Error) -> Void) {
        WebServiceClasses.shared.requestPOSTURL("delete_device.php", progress: progress, params: dicSendData, headers: nil, success: { dic in
            if dic.count != 0 {
                if dic["status"] as! String == "Error" {
                    //commonClass.showCustomeAlert(viewcontroller, messageA: dic["response"] as? String ?? "No devices found", MessageColor: "red")
                } else {
                    completionHandler(dic)
                }
            }
        }) { err in
            commonClass.showCustomeAlert(viewcontroller, messageA: err.localizedDescription, MessageColor: "red")
        }
    }
}
