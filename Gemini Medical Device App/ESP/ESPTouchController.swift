//
//  ESPTouchController.swift
//  Gemini Medical Device App
//
//  Created by TechnoMac-1 on 12/04/19.
//  Copyright © 2019 TechnoMac-1. All rights reserved.
//

import Foundation
class ESPTouchController: NSObject, ESPTouchDelegate {
    var delegate: ESPTouchControllerDelegate?

    var results: [ESPTouchResult] = Array()
    var esptouchTask: ESPTouchTask?

    public func interruptESP() {
        esptouchTask?.interrupt()
    }

    public func sendSmartConfig(bssid: String, ssid: String, password: String, resultExpected: Int32) {
        let arrayLength: Int32 = resultExpected == 0 ? 10 : resultExpected
        results.removeAll()

        DispatchQueue.global().async {
            self.esptouchTask = ESPTouchTask(apSsid: ssid, andApBssid: bssid, andApPwd: password)
            if let task = self.esptouchTask {
                task.setEsptouchDelegate(self)
                task.execute(forResults: arrayLength)
            }
        }
    }

    func onEspSleepStart() {
        DispatchQueue.main.async {
            self.delegate?.handleConnectionTimeoutAlert(resultCount: self.results.count) // Problem
        }
    }

    func onEsptouchResultAdded(with result: ESPTouchResult!) {
        results.append(result)
        DispatchQueue.main.async {
            let ip = "\(ESP_NetUtil.descriptionInetAddr4(by: result.ipAddrData)!)"
            self.delegate?.handleAddedResult(resultCount: self.results.count, bssid: result.bssid, ip: ip) // Problem
        }
    }
}
