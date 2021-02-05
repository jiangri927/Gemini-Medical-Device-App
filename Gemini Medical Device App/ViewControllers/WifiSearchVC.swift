//
//  WifiSearchVC.swift
//  Gemini Medical Device App
//
//  Created by TechnoMac-1 on 20/03/19.
//  Copyright © 2019 TechnoMac-1. All rights reserved.
//

import UIKit
import MBProgressHUD

class WifiSearchVC: baseVC {
    @IBOutlet var btn_search: UIButton!

    // MARK: - View Controller  Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        let notificationCenter = NotificationCenter.default
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(appMovedToBackground),
            name: UIApplication.willEnterForegroundNotification,
            object: nil
        )
    }
    
    private func showBusySearching(isBusy: Bool, message: String = "") {
        DispatchQueue.main.async {
            if isBusy {
                let loader = MBProgressHUD.showAdded(to: self.view, animated: true)
                loader.mode = MBProgressHUDMode.indeterminate
                loader.label.text = message
            } else {
                MBProgressHUD.hide(for: self.view, animated: true)
            }
        }
    }

    @objc func appMovedToBackground() {
        print("App moved to background!")
        if WebServiceClasses.Connectivity.isConnectedToInternet == false {
            showBusySearching(isBusy: false)
        } else {
            if WebServiceClasses.Connectivity.isWifiConnected == true {
                //btn_search.isEnabled = true
                /*commonClass.showCustomeAlertwithCompletion(self, messageA: "You are connected through wifi..", MessageColor: "green", Duration:2) { flag in
                    if flag {
                        
                    }
                }*/
            } else {
                //btn_search.isEnabled = true
                showBusySearching(isBusy: false)
            }
        }
    }

    override func viewWillAppear(_: Bool) {
        print("View will Apear calls")
        //showBusySearching(isBusy: true, message: "Checking Wifi Connection")
        if WebServiceClasses.Connectivity.isWifiConnected == true {
            //btn_search.isEnabled = false
//            let vc  = self.storyboard?.instantiateViewController(withIdentifier: "WifiSearchCompleteVC") as! WifiSearchCompleteVC
//
//            self.navigationController?.pushViewController(vc, animated: true)

//            commonClass.showCustomeAlertwithCompletion(self, messageA: "You are connected through wifi..", MessageColor: "green") { (flag) in
//                if flag {

//                                   if self.topMostViewController() == self {
//
//
//                                                let vc = self.navigationController!.viewControllers[self.navigationController!.viewControllers.count - 2 ]
//                    let nav : UIViewController = self.storyboard?.instantiateViewController(withIdentifier: "MainMenu") as! MainMenu
//                                                if vc.isKind(of: nav.classForCoder) {
//                                                    self.navigationController?.popViewController(animated: true)
//                                                }else {
//
//                    self.navigationController?.pushViewController(nav, animated: true)
//                                           }
//
//                               }
            /// /
//                    let vc  = self.storyboard?.instantiateViewController(withIdentifier: "WifiSearchCompleteVC") as! WifiSearchCompleteVC
            /// /
//                       self.navigationController?.pushViewController(vc, animated: true)

            //   }
            //          }
        }
        appMovedToBackground()
    }

    override func viewWillDisappear(_: Bool) {
        NotificationCenter.default.removeObserver(self)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    @IBAction func clk_SearchWifi(_: Any) {
        /*if UIApplication.shared.canOpenURL(URL(string: "App-Prefs:root=WIFI")!) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(URL(string: "App-Prefs:root=WIFI")!, completionHandler: { success in
                    print("Settings opened: \(success)") // Prints true
                })
            } else {
                if let settingsUrl = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(settingsUrl) {
                    UIApplication.shared.openURL(settingsUrl)
                }
            }
        }*/
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "WiFiSearchListVC") as! WiFiSearchListVC

        self.navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction func clk_Skip(_: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "WifiOptionsVC") as! WifiOptionsVC
        navigationController?.pushViewController(vc, animated: true)
    }

//        let vc  = storyboard?.instantiateViewController(withIdentifier: "WifiSearchCompleteVC") as! WifiSearchCompleteVC
//
//        navigationController?.pushViewController(vc, animated: true)
}

extension UIViewController {
    func topMostViewController() -> UIViewController {
        if presentedViewController == nil {
            return self
        }
        if let navigation = presentedViewController as? UINavigationController {
            if let visibleController = navigation.visibleViewController {
                return visibleController.topMostViewController()
            }
        }
        if let tab = presentedViewController as? UITabBarController {
            if let selectedTab = tab.selectedViewController {
                return selectedTab.topMostViewController()
            }
            return tab.topMostViewController()
        }
        return presentedViewController!.topMostViewController()
    }
}

extension UIApplication {
    func topMostViewController() -> UIViewController? {
        return keyWindow?.rootViewController?.topMostViewController()
    }
}
