//
//  Common Class.swift
//  Gemini Medical Device App
//
//  Created by TechnoMac-1 on 25/03/19.
//  Copyright © 2019 TechnoMac-1. All rights reserved.
//

import Foundation
import MaterialComponents.MaterialSnackbar
import MaterialComponents.MaterialSnackbar_ColorThemer
import SystemConfiguration

class commonClass: NSObject {
    static var delegate: linearProgressData?
    // Simple Alert
    static func showCustomeAlert(_: UIViewController, messageA: String, MessageColor: String) {
        let message = MDCSnackbarMessage()
        message.text = messageA
        let myColors: [String: UIColor] = [
            "red": .red,
            "white": .white,
            "green": UIColor(red: 70 / 255, green: 190 / 255, blue: 104 / 255, alpha: 1),
            "gray": .gray,
        ]
        MDCSnackbarMessageView.appearance().snackbarMessageViewBackgroundColor = myColors[MessageColor]
        MDCSnackbarManager.show(message)

        //   MDCSnackbarMessageDurationMax
    }

    // MARK: - Alert with   completion

    static func showCustomeAlertwithCompletion(_: UIViewController, messageA: String, MessageColor: String, Duration: TimeInterval, completionHandler: @escaping (Bool) -> Swift.Void) {
        let message = MDCSnackbarMessage()
        message.completionHandler = { flag in
            completionHandler(true)
            print("Hello, world!", flag)
        }
        message.text = messageA
        message.duration = Duration
        let myColors: [String: UIColor] = [
            "red": .red,
            "white": .white,
            "green": UIColor(red: 70 / 255, green: 190 / 255, blue: 104 / 255, alpha: 1),
            "gray": .gray,
        ]
        MDCSnackbarMessageView.appearance().snackbarMessageViewBackgroundColor = myColors[MessageColor]
        MDCSnackbarManager.show(message)

        //   MDCSnackbarMessageDurationMax
    }

    // MARK: - Alert with Action and completion

    static func showCustomeAlertWithAction(_: UIViewController, messageA: String, butonTitle: String, MessageColor: String, completionHandler: @escaping (Bool) -> Swift.Void) {
        DispatchQueue.main.async {
            let message = MDCSnackbarMessage()
            //  let textMessage = MDCSnackbarMessageCompletionHandler

            //  var colorScheme = MDCSemanticColorScheme().backgroundColor
            let myColors: [String: UIColor] = [
                "red": .red,
                "white": .white,
                "green": UIColor(red: 70 / 255, green: 190 / 255, blue: 104 / 255, alpha: 1),
                "gray": .gray,
            ]
            let action = MDCSnackbarMessageAction()

            let actionHandler = { () in
                // let answerMessage = MDCSnackbarMessage()
                print("okay Clicked")
            }
            message.completionHandler = { flag in
                print("Hello, world!", flag)
                completionHandler(true)
            }
            //   colorScheme  = .red
            message.text = messageA
            action.handler = actionHandler
            action.title = butonTitle
            message.action = action

            MDCSnackbarMessageView.appearance().snackbarMessageViewBackgroundColor = myColors[MessageColor]
            //         MDCSnackbarColorThemer.applySemanticColorScheme(colorScheme as! MDCColorScheming)
            MDCSnackbarManager.show(message)
        }
    }

    static func validateEmail(enteredEmail: String) -> Bool {
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: enteredEmail)
    }

    static func isPasswordValid(_ password: String) -> Bool {
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}")
        return passwordTest.evaluate(with: password)
    }

    static func addCurrentUserDictToDefaults(dict: NSDictionary) {
        let mutDict = NSMutableDictionary(dictionary: dict)

        let dict = mutDict as! [String: Any]
        let userDictWithOutNull = dict.nullKeyRemoval()

        userDefaults.set(mutDict, forKey: loggedInUserDictKey)
        print(userDefaults.dictionary(forKey: loggedInUserDictKey) as Any)
    }

    static func getloginDetails() -> Login {
        let dicdata = userDefaults.dictionary(forKey: loggedInUserDictKey) as Any
        let jsonUser = JSON(dicdata)
        let objUser = try! JSONDecoder().decode(Login.self, from: jsonUser.rawData())
        return objUser
    }

    static func popViewControllerss(viewcontroller: UIViewController, popViews: Int, animated: Bool = true) {
        if viewcontroller.navigationController!.viewControllers.count > popViews {
            let vc = viewcontroller.navigationController!.viewControllers[viewcontroller.navigationController!.viewControllers.count - popViews - 1]
            viewcontroller.navigationController?.popToViewController(vc, animated: animated)
        }
    }

    static func SubscriptionWithTopic(TopicA: String, Completion: @escaping (Payload) -> Swift.Void) {
        if TopicA != "" {
            DispatchQueue.main.async {
                AWSConfig.shared.ConnectToAWS(MQttStatus: { str in
                    WebServiceClasses.shared.HideProgressHud()
                    if str == "Connected" {
                        AWSConfig.shared.subscribeTopic(topicA: TopicA, comlpetion: { po in
                            //   print(po)
                            // var delegate : linearProgressData?

                            if let data: Payload = po {
                                deviceData = [data]
                                //       print("Device in common class",deviceData)
                                if deviceData[0].updating != nil {
                                    delegate?.ProgressStatus(Double(deviceData[0].updating!))
                                }
                                if deviceData[0].update_status != nil {
                                    delegate?.ProgressComplete(deviceData[0].update_status!)
                                }
                                Completion(data)

                                //       print("with topic Time Only", deviceData[0].updating , deviceData[0].update_status)
                            }

                        })
                    } else {
                        print("Wait for MQTT connection")
                    }
                })
            }
        }
    }

    static func DefaultDeviceSubscriptionDataForApp(Completion: @escaping (Payload) -> Swift.Void) {
        if WebServiceClasses.Connectivity.isConnectedToInternet || WebServiceClasses.Connectivity.isWifiConnected {
            if userDefaults.object(forKey: "deviceUID") != nil &&
                userDefaults.object(forKey: "topic") != nil {
                DispatchQueue.main.async {
                    AWSConfig.shared.ConnectToAWS(MQttStatus: { str in
                        WebServiceClasses.shared.HideProgressHud()
                        if str == "Connected" {
                            AWSConfig.shared.subscribeTopic(topicA: userDefaults.string(forKey: "topic")!, comlpetion: { po in
                                //  print(po)

                                if let data: Payload = po {
                                    deviceData = [data]
                                    //         print("Device in common class",deviceData)
                                    if deviceData[0].updating != nil {
                                        delegate?.ProgressStatus(Double(deviceData[0].updating!))
                                    }
                                    if deviceData[0].update_status != nil {
                                        delegate?.ProgressComplete(deviceData[0].update_status!)
                                    }
                                    Completion(data)

                                    //  print("Time Only", deviceData[0].updating , deviceData[0].update_status)
                                }

                            })
                        } else {
                            print("Wait for MQTT connection")
                        }
                    })
                }
            }
        } else {
            WebServiceClass.shared.HideProgressHud()
            commonClass.showCustomeAlert(UIViewController(), messageA: "Check Internet Connectivity", MessageColor: "green")
        }
    }
}

public class Reachabilities {
    class func isConnectedToNetwork() -> Bool {
        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)

        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) { zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }

        var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
        if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
            return false
        }

        // Working for Cellular and WIFI
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        let ret = (isReachable && !needsConnection)

        return ret
    }
}

extension Dictionary {
    func nullKeyRemoval() -> Dictionary {
        var dict = self

        let keysToRemove = Array(dict.keys).filter { dict[$0] is NSNull }
        for key in keysToRemove {
            dict.removeValue(forKey: key)
        }

        return dict
    }
}

extension Date {
    /// Returns the amount of years from another date
    func years(from date: Date) -> Int {
        return Calendar.current.dateComponents([.year], from: date, to: self).year ?? 0
    }

    /// Returns the amount of months from another date
    func months(from date: Date) -> Int {
        return Calendar.current.dateComponents([.month], from: date, to: self).month ?? 0
    }

    /// Returns the amount of weeks from another date
    func weeks(from date: Date) -> Int {
        return Calendar.current.dateComponents([.weekOfMonth], from: date, to: self).weekOfMonth ?? 0
    }

    /// Returns the amount of days from another date
    func days(from date: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: date, to: self).day ?? 0
    }

    /// Returns the amount of hours from another date
    func hours(from date: Date) -> Int {
        return Calendar.current.dateComponents([.hour], from: date, to: self).hour ?? 0
    }

    /// Returns the amount of minutes from another date
    func minutes(from date: Date) -> Int {
        return Calendar.current.dateComponents([.minute], from: date, to: self).minute ?? 0
    }

    /// Returns the amount of seconds from another date
    func seconds(from date: Date) -> Int {
        return Calendar.current.dateComponents([.second], from: date, to: self).second ?? 0
    }

    /// Returns the a custom time interval description from another date
    func offset(from date: Date) -> String {
        if years(from: date) > 0 { return "\(years(from: date))y" }
        if months(from: date) > 0 { return "\(months(from: date))M" }
        if weeks(from: date) > 0 { return "\(weeks(from: date))w" }
        if days(from: date) > 0 { return "\(days(from: date))d" }
        if hours(from: date) > 0 { return "\(hours(from: date))h" }
        if minutes(from: date) > 0 { return "\(minutes(from: date))m" }
        if seconds(from: date) > 0 { return "\(seconds(from: date))s" }
        return ""
    }
}

extension String {
    func maxLength(length: Int) -> String {
        var str = self
        let nsString = str as NSString
        if nsString.length >= length {
            str = nsString.substring(with:
                NSRange(
                    location: 0,
                    length: nsString.length > length ? length : nsString.length
                ))
        }
        return str
    }
}

// if WebServiceClasses.Connectivity.isConnectedToInternet || WebServiceClasses.Connectivity.isWifiConnected{}else {
//    WebServiceClass.shared.HideProgressHud()
//    commonClass.showCustomeAlert(UIViewController(), messageA: "Check Internet Connectivity", MessageColor: "green")
// }
