//
//  AWSConfig.swift
//  Gemini Medical Device App
//
//  Created by TechnoMac-1 on 16/04/19.
//  Copyright © 2019 TechnoMac-1. All rights reserved.
//

import AWSIoT
import AWSMobileClient
import Foundation

class AWSConfig {
    static let shared = AWSConfig()

    func awsConfig(AwsConfig: AWSConfig) -> AWSConfig {
        return AwsConfig
    }

    var connected = false

    var iotDataManager: AWSIoTDataManager!
    var iotManager: AWSIoTManager!
    var iot: AWSIoT!

    var isConnected = Bool()

    // MARK: - User wants to connect or disconnect from AWSIoT

    // MARK: - AWS config manager

    func ConfigAWSIOTManager() {
        if WebServiceClasses.Connectivity.isConnectedToInternet || WebServiceClasses.Connectivity.isWifiConnected {
            AWSMobileClient.sharedInstance().initialize { _, error in
                guard error == nil else {
                    print("Failed to initialize AWSMobileClient. Error: \(error!.localizedDescription)")
                    return
                }
                print("AWSMobileClient initialized.")
            }

            // Init IoT
            // Set up Cognito
            let credentialsProvider = AWSCognitoCredentialsProvider(regionType: AWSRegion, identityPoolId: CognitoIdentityPoolId)
            let iotEndPoint = AWSEndpoint(urlString: IOT_ENDPOINT)

            // Config AWS control plane
            let iotConfiguration = AWSServiceConfiguration(region: AWSRegion, credentialsProvider: credentialsProvider)

            // Config AWS data
            let iotDataConfiguration = AWSServiceConfiguration(region: AWSRegion,
                                                               endpoint: iotEndPoint,
                                                               credentialsProvider: credentialsProvider)

            AWSServiceManager.default().defaultServiceConfiguration = iotConfiguration
            iotManager = AWSIoTManager.default()
            iot = AWSIoT.default()
            AWSIoTDataManager.register(with: iotDataConfiguration!, forKey: ASWIoTDataManagerSTR)
            iotDataManager = AWSIoTDataManager(forKey: ASWIoTDataManagerSTR)
        } else {}
    }

    func ConnectToAWS(MQttStatus: @escaping (String) -> Swift.Void) {
        if WebServiceClasses.Connectivity.isConnectedToInternet || WebServiceClasses.Connectivity.isWifiConnected {
            if iotManager != nil {
                // WebServiceClasses.shared.AddProgressHud()
                isConnected = false

                func mqttEventCallback(_ status: AWSIoTMQTTStatus) {
                    DispatchQueue.main.async {
                        // connection status
                        switch status {
                        case .connecting:
                            mqttStatus = "Connecting..."
                            print("MQTT STATUS :-", mqttStatus)
                            // self.logTextView.text = mqttStatus

                            WebServiceClass.shared.HideProgressHud()
                        case .connected:
                            mqttStatus = "Connected"
                            print("MQTT STATUS :-", mqttStatus)
                            //    sender.setTitle( "Disconnect", for:UIControlState())
                            //    self.activityIndicatorView.stopAnimating()
                            self.connected = true
                            self.isConnected = true
                            let uuid = UUID().uuidString
                            let defaults = UserDefaults.standard
                            let certificateId = defaults.string(forKey: "certificateId")
                            //  self.logTextView.text = "Using certificate:\n\(certificateId!)\n\n\nClient ID:\n\(uuid)"
                            MQttStatus(mqttStatus)
                            if certificateId != nil {
                                print("Using certificate:\n\(certificateId!)\n\n\nClient ID:\n\(uuid)")
                            }

                    //   self.subscribeToWeatherUpdates()

                        case .disconnected:
                            mqttStatus = "Disconnected"
                            //    self.activityIndicatorView.stopAnimating()
                            print("MQTT STATUS :-", mqttStatus)
                            commonClass.showCustomeAlert(UIViewController(), messageA: mqttStatus, MessageColor: "red")
                            WebServiceClass.shared.HideProgressHud()
                        case .connectionRefused:
                            mqttStatus = "Connection Refused"
                            //    self.activityIndicatorView.stopAnimating()
                            print("MQTT STATUS :-", mqttStatus)
                            commonClass.showCustomeAlert(UIViewController(), messageA: mqttStatus, MessageColor: "red")
                            WebServiceClass.shared.HideProgressHud()

                        case .connectionError:
                            mqttStatus = "Connection Error"
                            //    self.activityIndicatorView.stopAnimating()
                            print("MQTT STATUS :-", mqttStatus)
                            //   commonClass.showCustomeAlert(UIViewController(), messageA: mqttStatus, MessageColor: "red")
                            WebServiceClass.shared.HideProgressHud()

                        case .protocolError:
                            mqttStatus = "Protocol Error"
                            //   self.activityIndicatorView.stopAnimating()
                            print("MQTT STATUS :-", mqttStatus)
                            commonClass.showCustomeAlert(UIViewController(), messageA: mqttStatus, MessageColor: "red")
                            WebServiceClass.shared.HideProgressHud()

                        default:
                            mqttStatus = "Unknown State"
                            //     self.activityIndicatorView.stopAnimating()
                            commonClass.showCustomeAlert(UIViewController(), messageA: mqttStatus, MessageColor: "red")
                            WebServiceClass.shared.HideProgressHud()
                            print("MQTT STATUS :-", mqttStatus)
                        }
                    }
                }

                // checks if user is connected
                if connected == false {
                    //   activityIndicatorView.startAnimating()

                    let defaults = UserDefaults.standard
                    var certificateId = defaults.string(forKey: "certificateId")
                    let uuid = UUID().uuidString

                    // If no certificate id exists
                    //          if (certificateId == nil)
                    //          {
//                let defaults = UserDefaults.standard
//                var certificateId = defaults.string( forKey: "certificateId")
//

                    let credentialsProvider = AWSCognitoCredentialsProvider(regionType: .USWest2,
                                                                            identityPoolId: "us-west-2:e6ae542d-99b7-4238-babf-69482224fabd")
                    let configuration = AWSServiceConfiguration(region: .USWest2, credentialsProvider: credentialsProvider)
                    AWSServiceManager.default().defaultServiceConfiguration = configuration

                    print(configuration?.endpoint)
                    print("Credential", configuration?.credentialsProvider.credentials())

                    if certificateId == nil {
                        DispatchQueue.main.async {
                            print("No identity available, searching bundle...")
                        }

                        // No certificate ID has been stored in the user defaults; check to see if any .p12 files
                        // exist in the bundle.
                        let myBundle = Bundle.main
                        let myImages = myBundle.paths(forResourcesOfType: "p12" as String, inDirectory: nil)
                        let uuid = UUID().uuidString

                        if myImages.count > 0 {
                            // At least one PKCS12 file exists in the bundle.  Attempt to load the first one
                            // into the keychain (the others are ignored), and set the certificate ID in the
                            // user defaults as the filename.  If the PKCS12 file requires a passphrase,
                            // you'll need to provide that here; this code is written to expect that the
                            // PKCS12 file will not have a passphrase.
                            if let data = try? Data(contentsOf: URL(fileURLWithPath: myImages[0])) {
                                DispatchQueue.main.async {
                                    print("found identity \(myImages[0]), importing...")
                                }
                                if AWSIoTManager.importIdentity(fromPKCS12Data: data, passPhrase: "", certificateId: myImages[0]) {
                                    // Set the certificate ID and ARN values to indicate that we have imported
                                    // our identity from the PKCS12 file in the bundle.
                                    defaults.set(myImages[0], forKey: "certificateId")
                                    defaults.set("from-bundle", forKey: "certificateArn")
                                    DispatchQueue.main.async {
                                        print("Using certificate: \(myImages[0]))")
                                        self.iotDataManager.connect(withClientId: uuid, cleanSession: true, certificateId: myImages[0], statusCallback: mqttEventCallback)
                                    }
                                }
                            }
                        }

                        // Creates and stores the certificate id in UserDefaults
                        let csrDictionary = ["commonName": CertificateSigningRequestCommonName, "countryName": CertificateSigningRequestCountryName, "organizationName": CertificateSigningRequestOrganizationName, "organizationalUnitName": CertificateSigningRequestOrganizationalUnitName]
                        let iotManagerA = AWSIoTManager(forKey: "MyIotDataManager")

                        // Creates keys and a certificate
                        iotManager.createKeysAndCertificate(fromCsr: csrDictionary, callback: { (response) -> Void in
                            if response != nil {
                                defaults.set(response?.certificateId, forKey: "certificateId")
                                defaults.set(response?.certificateArn, forKey: "certificateArn")
                                certificateId = response?.certificateId
                                print("response: [\(String(describing: response))]")

                                DispatchQueue.main.async {
                                    //                            self.deleteButton.setTitle( "Delete Certificate", for:UIControlState())
                                    //                            self.deleteButton.isEnabled = true
                                }

                                let attachPrincipalPolicyRequest = AWSIoTAttachPrincipalPolicyRequest()
                                attachPrincipalPolicyRequest?.policyName = PolicyName
                                attachPrincipalPolicyRequest?.principal = response?.certificateArn

                                // Attach the policy to the certificate
                                self.iot.attachPrincipalPolicy(attachPrincipalPolicyRequest!).continueWith(block: { (task) -> AnyObject? in
                                    if let error = task.error {
                                        print("failed to attach policy: \(error)")
                                    }

                                    // Connect to the AWS IoT platform
                                    if task.error == nil {
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                            //   self.logTextView.text = "Using certificate: \(certificateId!)"

                                            print("Using certificate: \(certificateId!)")
                                            self.iotDataManager.connect(withClientId: uuid, cleanSession: true, certificateId: certificateId!, statusCallback: mqttEventCallback)
                                        }
                                    }
                                    return nil
                                })
                            } else {
                                DispatchQueue.main.async {
                                    //          sender.isEnabled = true
                                    //            self.activityIndicatorView.stopAnimating()
                                    //           self.logTextView.text = "Unable to create keys and/or certificate, check values in Constants.swift"
                                    self.isConnected = true
                                    print("Unable to create keys and/or certificate, check values in Constants.swift")
                                }
                            }

                        })

                    } else { // if a certificate id does exist
                        let uuid = UUID().uuidString

                        // Connect to AWS IoT

                        iotDataManager.connect(withClientId: uuid, cleanSession: true, certificateId: certificateId!, statusCallback: mqttEventCallback)
                    }
                } else {
                    let uuid = UUID().uuidString
                    let certificateId = userDefaults.string(forKey: "certificateId")
                    // Connect to AWS IoT
                    if certificateId != nil {
                        iotDataManager.connect(withClientId: uuid, cleanSession: true, certificateId: certificateId!, statusCallback: mqttEventCallback)
                    }

                    MQttStatus(mqttStatus)
                    WebServiceClasses.shared.HideProgressHud()
                }
//        }
                // else // user is connected and wants to disconnect
//        {
//            //    activityIndicatorView.startAnimating()
//            //   logTextView.text = "Disconnecting..."
//            print("Disconnecting....")
//            DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async {
//
//                self.iotDataManager.disconnect();
//
//                DispatchQueue.main.async {
//                    //     self.activityIndicatorView.stopAnimating()
//                    self.connected = false
//                    //     sender.setTitle( "Connect", for:UIControlState())
//                    //     sender.isEnabled = true
//                    self.isConnected = true
//                }
//            }
//        }
            } else {
                ConfigAWSIOTManager()
            }
        } else {
            Alert.showAlert(viewcontroller: UIViewController(), title: AppName, message: "Please check your internet connectivity..")
        }
    }

    // MARK: - AWS channel subscription

    func subscribe(comlpetion: @escaping (Payload) -> Swift.Void) {
        let iotDataManager = AWSIoTDataManager(forKey: ASWIoTDataManagerSTR)
        //    let tabBarViewController = tabBarController as! IoTSampleTabBarController
        var dataToConvert = String()
        let tp = (userDefaults.string(forKey: "topic") ?? "00001")!
        iotDataManager.subscribe(toTopic: "\(tp)/out", qoS: .messageDeliveryAttemptedAtMostOnce, messageCallback: {
            (payload) -> Void in

            //  let stringValue = NSString(data: payload, encoding: String.Encoding.utf8.rawValue)!
            let stringData = String(data: payload, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue))
            print("received: \(stringData)")
            dataToConvert = stringData!
            let json = JSON(payload)

            // Comlpetion(stringValue as String)
            do {
                let objUserA = try JSONDecoder().decode(Payload.self, from: json.rawData())

                comlpetion(objUserA)

            } catch {
                print("Error")
            }

        })
//        if dataToConvert != "" {
//            let json = JSON(dataToConvert)
//
//            let objUserA = try! JSONDecoder().decode(Payload.self, from: json.rawData())
//            if objUserA != nil{
//                comlpetion(objUserA)
//            }
//        }
    }

    // MARK: - Topic subscribe Method

    func subscribeTopic(topicA: String, comlpetion: @escaping (Payload) -> Swift.Void) {
        let iotDataManager = AWSIoTDataManager(forKey: ASWIoTDataManagerSTR)
        //    let tabBarViewController = tabBarController as! IoTSampleTabBarController
        var dataToConvert = String()

        iotDataManager.subscribe(toTopic: "\(topicA)/out", qoS: .messageDeliveryAttemptedAtMostOnce, messageCallback: {
            (payload) -> Void in
            let stringValue = NSString(data: payload, encoding: String.Encoding.utf8.rawValue)!
            let stringData = String(data: payload, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue))
            // print("received: \(stringValue)")
            dataToConvert = stringData!
            DispatchQueue.main.async {
                //  self.subscribeSlider.value = stringValue.floatValue
            }
            // Comlpetion(stringValue as String)
            do {
                let json = JSON(payload)

                let objUserA = try JSONDecoder().decode(Payload.self, from: json.rawData())
                deviceData = [objUserA]

                comlpetion(objUserA)

            } catch {
                print("Error")
            }

        })
//        if dataToConvert != "" {
//            let json = JSON(dataToConvert)
//
//            let objUserA = try! JSONDecoder().decode(Payload.self, from: json.rawData())
//            if objUserA != nil{
//                comlpetion(objUserA)
//            }
//        }
    }

    // MARK: - Topic unsubscribe methods

    func UnSubScribe() {
        let iotDataManager = AWSIoTDataManager(forKey: ASWIoTDataManagerSTR)
        //     let tabBarViewController = tabBarController as! IoTSampleTabBarController
        let tp = userDefaults.string(forKey: "topic")!
        iotDataManager.unsubscribeTopic("\(tp)/out")
        print("Topic \(topic) Unsubscribed")
    }

    func UnsubscribeTopics(topicA: String) {
        let iotDataManager = AWSIoTDataManager(forKey: ASWIoTDataManagerSTR)
        iotDataManager.unsubscribeTopic("\(topicA)/out")
        print("Topics \(topicA) Unsubscribed")
    }

    func publish(topicA: String, deviceUId: String) {
        let iotDataManager = AWSIoTDataManager(forKey: ASWIoTDataManagerSTR)
        //    let tabBarViewController = tabBarController as! IoTSampleTabBarController

        //  iotDataManager.publishString("@@@btn_fw_update,\(userDefaults.string(forKey: "deviceUID") ?? "no device")", onTopic: "\(userDefaults.string(forKey: "topic"))", qoS:.messageDeliveryAttemptedAtMostOnce)
        //   let deviceUId = userDefaults.string(forKey: "deviceUID")!
        //   let tp = userDefaults.string(forKey: "topic")!
        iotDataManager.publishString("@@@btn_fw_update,\(deviceUId))", onTopic: topicA, qoS: .messageDeliveryAttemptedAtMostOnce)

//        iotDataManager.publishString("@@@btn_fw_update,\(userDefaults.string(forKey: "deviceUID") ?? "no device")", onTopic: "\(userDefaults.string(forKey: "topic"))/out", qoS: .messageDeliveryAttemptedAtLeastOnce) {
//            print("bool is ", iotDataManager.publishString("@@@btn_fw_update,\(userDefaults.string(forKey: "deviceUID") ?? "no device")", onTopic: "\(userDefaults.string(forKey: "topic"))/out", qoS: .messageDeliveryAttemptedAtLeastOnce))
//        }
    }
}
