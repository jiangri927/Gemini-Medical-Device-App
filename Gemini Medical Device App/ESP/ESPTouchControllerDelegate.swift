//
//  ESPTouchControllerDelegate.swift
//  Gemini Medical Device App
//
//  Created by TechnoMac-1 on 12/04/19.
//  Copyright © 2019 TechnoMac-1. All rights reserved.
//

import Foundation
protocol ESPTouchControllerDelegate {
    func handleConnectionTimeoutAlert(resultCount: Int)
    func handleAddedResult(resultCount: Int, bssid: String!, ip: String!)
}
