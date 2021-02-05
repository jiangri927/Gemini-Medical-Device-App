//
//  Payload.swift
//  Gemini Medical Device App
//
//  Created by TechnoMac-1 on 16/04/19.
//  Copyright © 2019 TechnoMac-1. All rights reserved.
//

import Foundation
import UIKit
struct Payload: Codable {
    let serial_num: String?
    let batch: String?
    let geo_lat: String?
    let geo_lng: String?
    let fw_ver: String?
    let fw_up: Int?
    let wifi: Int?
    let ble: Int?
    let v: Int?
    let i: Int?
    let cal810: Int?
    let cal980: Int?
    let life810: Int?
    let life980: Int?
    let display_data: String?
    let df_data: String?
    let df_button: Int?

    var flag: Bool = false
    var time: Date = Date()
    var updating: Int?
    var update_status: Int?

    enum CodingKeys: String, CodingKey {
        case serial_num
        case batch
        case geo_lat
        case geo_lng
        case fw_ver
        case fw_up
        case wifi
        case ble
        case v = "V"
        case i = "I"
        case cal810
        case cal980
        case life810
        case life980
        case display_data
        case df_data
        case df_button
        case updating
        case update_status
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        serial_num = try values.decodeIfPresent(String.self, forKey: .serial_num)
        batch = try values.decodeIfPresent(String.self, forKey: .batch)
        geo_lat = try values.decodeIfPresent(String.self, forKey: .geo_lat)
        geo_lng = try values.decodeIfPresent(String.self, forKey: .geo_lng)
        fw_ver = try values.decodeIfPresent(String.self, forKey: .fw_ver)
        fw_up = try values.decodeIfPresent(Int.self, forKey: .fw_up)
        wifi = try values.decodeIfPresent(Int.self, forKey: .wifi)
        ble = try values.decodeIfPresent(Int.self, forKey: .ble)
        v = try values.decodeIfPresent(Int.self, forKey: .v)
        i = try values.decodeIfPresent(Int.self, forKey: .i)
        cal810 = try values.decodeIfPresent(Int.self, forKey: .cal810)
        cal980 = try values.decodeIfPresent(Int.self, forKey: .cal980)
        life810 = try values.decodeIfPresent(Int.self, forKey: .life810)
        life980 = try values.decodeIfPresent(Int.self, forKey: .life980)
        display_data = try values.decodeIfPresent(String.self, forKey: .display_data)
        df_data = try values.decodeIfPresent(String.self, forKey: .df_data)
        df_button = try values.decodeIfPresent(Int.self, forKey: .df_button)
        updating = try values.decodeIfPresent(Int.self, forKey: .updating)
        update_status = try values.decodeIfPresent(Int.self, forKey: .update_status)
    }
}

// class PayloadAPI {
//
//    class  func PayloadWebservice(viewcontroller : UIViewController , DicData: [String:Any] , completion : @escaping (Payload)->Swift.Void , Error : @escaping (Error)-> Void ){
//        let str = [
//            "geo_lat":"37.704570",
//            "geo_lng":"-121.957137",
//            "fw_ver":"1.04",
//            "fw_up":1
//            ] as [String : Any]
//        guard let jsonArray = str as? [String: Any] else {
//            return
//        }
//        let jsonObj = JSON(str)
//        let payload_res = try! JSONDecoder().decode(Payload.self, from: jsonObj.rawData())
//        print(payload_res)
//        completion(payload_res)
//    }
//
// }
struct deviceWithTime {}

struct deviceWithFlag {
    var isOnline: Bool
    var deviceA: Devices
    init(isOnline: Bool, devicesB: Devices) {
        self.isOnline = isOnline
        deviceA = devicesB
    }
}

struct TokenData: Codable {
    let token: String?

    enum CodingKeys: String, CodingKey {
        case token
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        token = try values.decodeIfPresent(String.self, forKey: .token)
    }
}

struct DataWithToken: Codable {
    let data: TokenData?

    enum CodingKeys: String, CodingKey {
        case data
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        data = try values.decodeIfPresent(TokenData.self, forKey: .data)
    }
}
