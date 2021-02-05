//
//  AppDelegate.swift
//  Gemini Medical Device App
//
//  Created by TechnoMac-1 on 20/03/19.
//  Copyright © 2019 TechnoMac-1. All rights reserved.
//

import AWSIoT
import AWSMobileClient
import Braintree
import Crashlytics
import Fabric
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    let urlScheme = "com.azena.gemini.payments"
    //com.technostacks.development.payments
    func application(_: UIApplication, didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        Fabric.with([Crashlytics.self])

        AWSConfig.shared.ConfigAWSIOTManager()

        // Override point for customization after application launch.

        BTAppSwitch.setReturnURLScheme(urlScheme)

        return true
    }

    func AWSConnection() {
        DispatchQueue.main.async {
            AWSConfig.shared.ConnectToAWS(MQttStatus: { str in
                WebServiceClasses.shared.HideProgressHud()
                if str == "Connected" {
                    print("Connected MQTT ")
                    if #available(iOS 10.0, *) {
                        //                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "DownloadVC") as! DownloadVC
                        //                        self.navigationController?.pushViewController(vc, animated: true)
                    } else {
                        // Fallback on earlier versions
                    }
                } else {
                    print("Wait for MQTT connection")
                }
            })
        }
    }

    func applicationWillResignActive(_: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func application(_: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any]) -> Bool {
        if url.scheme?.localizedCaseInsensitiveCompare(urlScheme) == .orderedSame {
            return BTAppSwitch.handleOpen(url, options: options)
        }
        return false
    }

    // If you support iOS 7 or 8, add the following method.
    func application(_: UIApplication, open url: URL, sourceApplication: String?, annotation _: Any) -> Bool {
        if url.scheme?.localizedCaseInsensitiveCompare(urlScheme) == .orderedSame {
            return BTAppSwitch.handleOpen(url, sourceApplication: sourceApplication)
        }
        return false
    }
}
