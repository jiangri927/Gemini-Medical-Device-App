//
//  WifiSearchCompleteVC.swift
//  Gemini Medical Device App
//
//  Created by TechnoMac-1 on 20/03/19.
//  Copyright © 2019 TechnoMac-1. All rights reserved.
//

import CoreLocation
import UIKit
var espTouchNetworkDelegate = ESPTouchNetworkDelegate()

private var reachability: Reachability!
class WifiSearchCompleteVC: baseVC, CLLocationManagerDelegate {
    var locationManager: CLLocationManager?
    var bssid: String?
    var resultCount = 1
    var espController = ESPTouchController()
    @IBOutlet var txt_ssid: UITextField!

    @IBOutlet var txt_password: UITextField!
    var timeInSecond = 20
    var timer: Timer?

    // MARK: - View Controller  Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        txt_ssid.delegate = self
        txt_password.delegate = self
        txt_ssid.textColor = .black
        txt_password.textColor = .black
        espController.delegate = self
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestAlwaysAuthorization()

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_: Bool) {
        espTouchNetworkDelegate.tryOpenNetworkPermission()
        let str = espTouchNetworkDelegate.fetchSsid()
        txt_ssid.text = str
        bssid = espTouchNetworkDelegate.fetchBssid()
        do {
            Network.reachability = try Reachability(hostname: "www.google.com")
            do {
                try Network.reachability?.start()
            } catch let error as Network.Error {
                print(error)
            } catch {
                print(error)
            }
        } catch {
            print(error)
        }
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged), name: .flagsChanged, object: Network.reachability)
    }

    /*
     // MARK: - Navigation

     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         // Get the new view controller using segue.destination.
         // Pass the selected object to the new view controller.
     }
     */

    @IBAction func clk_back(_: Any) {
        BackNavigation()
    }

    @IBAction func clk_connect(_: Any) {
        if IfDeviceIsAllreadyConnected() {
            if txt_ssid.text == "" {
                Alert.showAlert(viewcontroller: self, title: AppName, message: "Please Add Wifi Name..")
            } else if txt_password.text == "" {
                Alert.showAlert(viewcontroller: self, title: AppName, message: "Please Add Password...")
            } else {
                view.endEditing(true)
                if txt_ssid.text?.compare("Not Connected to Wifi").rawValue != 0 {
                    espController.delegate = self
                    commonClass.showCustomeAlert(self, messageA: "Configuring wifi...", MessageColor: "gray")
                    espController.sendSmartConfig(bssid: bssid!, ssid: txt_ssid.text!, password: txt_password.text!, resultExpected: Int32(resultCount))
                    scheduledTimer()
                }
            }
        } else {
            commonClass.showCustomeAlertwithCompletion(self, messageA: "Your device is already connected to Internet..! ", MessageColor: "green", Duration:2) { flag in
                if flag {
                    self.BackNavigation()
                }
            }
        }
    }

    // MARK: - Functions

    func IfDeviceIsAllreadyConnected() -> Bool {
        if deviceData.count > 0 {
            return false
        } else {
            return true
        }
    }

    func scheduledTimer() {
        // Scheduling timer to Call the function "updateCounting" with the interval of 15 seconds
        if timer == nil {
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateCounting), userInfo: nil, repeats: true)
        }
    }

    func stopTimer() {
        if timer != nil {
            timer!.invalidate()
            timer = nil
        }
    }

    deinit {
        stopTimer()
    }

    @objc func updateCounting() {
        if timeInSecond != 0 {
            WebServiceClasses.shared.AddProgressHud()
            timeInSecond -= 1
            print(timeInSecond)
        } else {
            WebServiceClasses.shared.HideProgressHud()
            stopTimer()
            commonClass.showCustomeAlertwithCompletion(self, messageA: "Something went wrong!", MessageColor: "red", Duration:2) { flag in
                if flag {
                    self.BackNavigation()
                }
            }
        }
    }

    @objc func reachabilityChanged(notification: Notification) {
        let reachability = notification.object as! Reachability
        if reachability.isReachable {
            if reachability.isReachableViaWiFi {
                print("Reachable via WiFi")
            } else {
                print("Reachable via Cellular")
            }
        } else {
            print("Network not reachable")
        }
    }

    func BackNavigation() {
        let MainMenu: UIViewController = storyboard?.instantiateViewController(withIdentifier: "MainMenu") as! MainMenu
        if navigationController!.viewControllers.count > 11 {
            let vc = navigationController!.viewControllers[navigationController!.viewControllers.count - 10]
            let nav: UIViewController = storyboard?.instantiateViewController(withIdentifier: "TermsAndCondtitionsVCViewController") as! TermsAndCondtitionsVCViewController

            if vc.isKind(of: nav.classForCoder) {
                let Nvc = storyboard?.instantiateViewController(withIdentifier: "MainMenu") as! MainMenu
                navigationController?.pushViewController(Nvc, animated: true)
            } else {
                for controller in navigationController!.viewControllers as Array {
                    if controller.isKind(of: MainMenu.classForCoder) {
                        self.navigationController!.popToViewController(controller, animated: true)
                        break
                    }
                }
                // if   WebServiceClasses.Connectivity.isWifiConnected == true {
                // commonClass.popViewControllerss(viewcontroller: self, popViews: 1, animated: true)
                //  }else {
                //  navigationController?.popViewController(animated: true)
                //  }
            }

        } else {
            for controller in navigationController!.viewControllers as Array {
                if controller.isKind(of: MainMenu.classForCoder) {
                    self.navigationController!.popToViewController(controller, animated: true)
                    break
                }
            }
        }

        // navigationController?.popViewController(animated: true)
    }
}

extension WifiSearchCompleteVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case txt_ssid:
            textField.resignFirstResponder()
            txt_password.becomeFirstResponder()
        default:
            txt_password.resignFirstResponder()
        }
        return true
    }
}

extension WifiSearchCompleteVC: ESPTouchControllerDelegate {
    func handleConnectionTimeoutAlert(resultCount: Int) {
        if resultCount == 0 {
            commonClass.showCustomeAlertwithCompletion(self, messageA: "Connection Timeout", MessageColor: "red", Duration:2) { flag in
                if flag {
                    commonClass.showCustomeAlert(self, messageA: "no devices found, check if your ESP is in Connection mode!", MessageColor: "red")
                }
            }
        }
    }

    func handleAddedResult(resultCount: Int, bssid: String!, ip: String!) {
        print(ip)
        if resultCount >= 0 { // bug on condition, must know why!
            espController.interruptESP()
            espController.onEspSleepStart()
            commonClass.showCustomeAlert(self, messageA: "\(bssid ?? "No Bssid") - ip: \(ip ?? "no ip")\n", MessageColor: "red")
        }

        if resultCount >= 1 {
            stopTimer()
            WebServiceClasses.shared.HideProgressHud()
            self.resultCount = self.resultCount + 1
//            commonClass.showCustomeAlert(self, messageA: "\(bssid) - ip: \(ip)\n", MessageColor: "green")
//
            // Message with BSSID  and IP      "Your device is connected to Internet \(bssid) - ip: \(ip)\n"
            commonClass.showCustomeAlertwithCompletion(self, messageA: "Your device is connected to Internet!", MessageColor: "green", Duration:2) { flag in
                if flag {
                    self.BackNavigation()
                }
            }
        }
        print(ip)
    }
}
