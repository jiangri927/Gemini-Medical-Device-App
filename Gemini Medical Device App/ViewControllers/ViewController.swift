//
//  ViewController.swift
//  Gemini Medical Device App
//
//  Created by TechnoMac-1 on 20/03/19.
//  Copyright © 2019 TechnoMac-1. All rights reserved.
//

import CoreLocation
import UIKit
class ViewController: baseVC, CLLocationManagerDelegate {
    // VRIABLES
    var locationManager: CLLocationManager?

    // MARK: - Viewcontoller life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestWhenInUseAuthorization()
        locationManager?.startUpdatingLocation()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func viewWillAppear(_: Bool) {
        if userDefaults.string(forKey: logginToken) != nil {
            let vc = storyboard?.instantiateViewController(withIdentifier: "MainMenu") as! MainMenu
            navigationController?.pushViewController(vc, animated: true)
        }
    }

    // MARK: - CLick action

    @IBAction func clk_NewAccount(_: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "CreateAccount") as! CreateAccount
        navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction func clk_LoginAccount(_: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        navigationController?.pushViewController(vc, animated: true)
    }
}
