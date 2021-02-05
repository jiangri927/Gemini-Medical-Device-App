//
//  ESPTouchNetworkDelegate.swift
//  Gemini Medical Device App
//
//  Created by TechnoMac-1 on 12/04/19.
//  Copyright © 2019 TechnoMac-1. All rights reserved.
//

import Foundation
import SystemConfiguration.CaptiveNetwork

class ESPTouchNetworkDelegate: NSObject {
    func tryOpenNetworkPermission() {
        ESP_NetUtil.tryOpenNetworkPermission()
    }

    func fetchSsid() -> String {
        if let ssidInfo = fetchNetInfo() {
            return ssidInfo.value(forKey: "SSID") as! String
        }
        return "Not Connected to Wifi"
    }

    func fetchBssid() -> String {
        if let bssidInfo = fetchNetInfo() {
            return bssidInfo.value(forKey: "BSSID") as! String
        }
        return "Not Connected to Wifi"
    }

    func fetchNetInfo() -> NSDictionary? {
        if let interfaceNames: NSArray = CNCopySupportedInterfaces() {
            var SSIDInfo: NSDictionary?
            for interfaceName in interfaceNames {
                if let x = CNCopyCurrentNetworkInfo(interfaceName as! CFString) {
                    SSIDInfo = x
                }
            }

            return SSIDInfo
        }
        return nil
    }
}
