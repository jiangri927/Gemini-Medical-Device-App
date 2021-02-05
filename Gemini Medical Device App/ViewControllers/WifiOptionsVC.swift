//
//  WifiOptionsVC.swift
//  Gemini Medical Device App
//
//  Created by TechnoMac-1 on 24/05/19.
//  Copyright © 2019 TechnoMac-1. All rights reserved.
//

import UIKit

class WifiOptionsVC: baseVC {
    // MARK: - Viewcontroller Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func clk_connectTowifi(_: Any) {
        /*let vc = storyboard?.instantiateViewController(withIdentifier: "WifiSearchCompleteVC") as! WifiSearchCompleteVC

        navigationController?.pushViewController(vc, animated: true)*/
        
        self.navigationController?.popViewController(animated: true)
        
        
        // CODE TO OPEN WIFI SETTING
//        if UIApplication.shared.canOpenURL(URL(string:"App-Prefs:root=WIFI")!) {
//
//            if #available(iOS 10.0, *) {
//                UIApplication.shared.open(URL(string:"App-Prefs:root=WIFI")!, completionHandler: { (success) in
//                    print("Settings opened: \(success)") // Prints true
//                })
//            } else {
//
//                if let settingsUrl = URL.init(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(settingsUrl) {
//                    UIApplication.shared.openURL(settingsUrl)
//                }
//
//            }
//        }
    }

    /*
     // MARK: - Navigation

     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         // Get the new view controller using segue.destination.
         // Pass the selected object to the new view controller.
     }
     */
    @IBAction func clk_SkipWifi(_: Any) {
        /*let vc = navigationController!.viewControllers[navigationController!.viewControllers.count - 7]
        let nav: UIViewController = storyboard?.instantiateViewController(withIdentifier: "AddAccountVCViewController") as! AddAccountVCViewController
        if vc.isKind(of: nav.classForCoder) {
            let Nvc = storyboard?.instantiateViewController(withIdentifier: "MainMenu") as! MainMenu
            navigationController?.pushViewController(Nvc, animated: true)
        } else {
            commonClass.popViewControllerss(viewcontroller: self, popViews: 6, animated: true)
        }*/
        
        let MainMenu: UIViewController = storyboard?.instantiateViewController(withIdentifier: "MainMenu") as! MainMenu
        
        NSLog("nav count: %d", navigationController!.viewControllers.count)
        if navigationController!.viewControllers.count > 12 {
            let vc = navigationController!.viewControllers[navigationController!.viewControllers.count - 11]
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
            }

        } else {
            for controller in navigationController!.viewControllers as Array {
                if controller.isKind(of: MainMenu.classForCoder) {
                    self.navigationController!.popToViewController(controller, animated: true)
                    break
                }
            }
        }
    }
}
