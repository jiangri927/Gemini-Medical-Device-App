//
//  MainMenu.swift
//  Gemini Medical Device App
//
//  Created by TechnoMac-1 on 20/03/19.
//  Copyright © 2019 TechnoMac-1. All rights reserved.
//

import AWSIoT
import AWSMobileClient
import MBProgressHUD
import UIKit

class MainMenu: baseVC {
    // MARK: - Outlets

    @IBOutlet var viewHeader: UIView!
    @IBOutlet var lbl_HeaderName: UILabel!

    // MARK: - VARIABLES

    var MenuOptions = NSArray()
    var MenuImages = NSArray()
    var MenuImagesDeselected = NSArray()
    var deviceDataMainMenu = [Payload]()
    var payloadres: Payload?
    var seconds = 10
    var isFirstLoad = false
    var timer: Timer?
    var deviceListArr = [Devices]()
    // AWS
    @IBOutlet var btn_logOut: UIButton!
    @IBOutlet var buttonEditName: UIButton!
    var connected = false

    var isConnected = Bool()

    @IBOutlet var collectionView: UICollectionView!

    // MARK: - View Controller  Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        lbl_HeaderName.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tap(_:))))
        lbl_HeaderName.isUserInteractionEnabled = true
        //    lbl_HeaderName.isHidden = true

        //   temp.view1.backgroundColor = #colorLiteral(red: 0.9976231456, green: 0.7971993685, blue: 0.09706369787, alpha: 1)
        MenuOptions = ["Wi-Fi", "Status", "Updates", "Warranty", "Devices", "Statistics", "Videos", "User Manual"] // , "Log out" ]
        MenuImages = ["ic_wifi", "ic_status", "ic_update", "ic_warranty", "ic_scan_device", "ic_statistics", "ic_videos", "ic_user_manual"]
        MenuImagesDeselected = ["ic_wifi_disable", "ic_status_disable", "ic_update", "ic_warranty", "ic_scan_device", "ic_statistics", "ic_videos", "ic_user_manual"]
        // "ic_logout"]
        // ic_support
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_: Bool) {
        /// If serial number of selected device and serical number of AWS response is same then the selected device is same as the response we get of topic
        //TODO:add button
        if userDefaults.string(forKey: "deviceHeader") != nil {
            lbl_HeaderName.isHidden = false
            buttonEditName.isHidden = false
            viewHeader.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            lbl_HeaderName.text = userDefaults.string(forKey: "deviceHeader")
        } else {
            lbl_HeaderName.isHidden = true
            buttonEditName.isHidden = true
        }
        if deviceData.count == 0 {
            deviceData.removeAll()
            deviceDataMainMenu.removeAll()
            DispatchQueue.main.async {
                //   self.collectionView.reloadData()
            }
        }

        if UserDefaults.standard.string(forKey: "topic") != nil, deviceData.count > 0, deviceData[0].serial_num != nil {
            if userDefaults.string(forKey: "topic") == deviceData[0].serial_num {
                deviceDataMainMenu = deviceData
            }
        }
        //  AWSConfig.shared.ConfigAWSIOTManager()
        if userDefaults.string(forKey: "topic") != nil {
            scheduledTimerWithTimeInterval()
        }
        commonClass.DefaultDeviceSubscriptionDataForApp { PayLoad in
            deviceData = [PayLoad]
            self.deviceDataMainMenu = [PayLoad]
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }

        HeaderName()
        //  CallApi_Payload()
    }
    
    @IBAction func editName(_: Any) {
        
        for device in self.deviceListArr {
            
            if (userDefaults.string(forKey: "topic") == device.serialNumber) {
                
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "EditAccountVCViewController") as! EditAccountVCViewController
                vc.serialNumber = device.serialNumber!
                vc.UID = device.uID!
                vc.nickname = device.nickname!
                //self.navigationController?.pushViewController(vc, animated: true)
                self.present(vc, animated: true, completion: {})
            }
        }
    
    }

    override func viewDidAppear(_: Bool) {
        // self.collectionView.reloadData()
    }

    override func viewWillDisappear(_: Bool) {
        stopTimer()
    }

    override func viewDidLayoutSubviews() {
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            collectionView.collectionViewLayout.invalidateLayout()
            collectionView.collectionViewLayout = flowLayout
        }
    }

    // MARK: - btn back

    @IBAction func clk_back(_: Any) {
        navigationController?.popViewController(animated: true)
    }

    // MARK: - Function for default subscribed device data

    func scheduledTimerWithTimeInterval() {
        // Scheduling timer to Call the function "updateCounting" with the interval of 15 seconds
        if timer == nil {
            timer = Timer.scheduledTimer(timeInterval: TimeInterval(seconds), target: self, selector: #selector(updateCounting), userInfo: nil, repeats: true)
            
        }
        if (isFirstLoad) {
            isFirstLoad = false
            self.showBusySearching(isBusy: true, message: "Fetching for the latest updates . . .")
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

    // MARK: -  timer update

    @objc func updateCounting() {
        
        if (!isFirstLoad) {
            self.showBusySearching(isBusy: false)
        }
        if WebServiceClasses.Connectivity.isConnectedToInternet || WebServiceClasses.Connectivity.isWifiConnected {
            if AWSConfig.shared.iotManager != nil {
                HeaderName()
                if userDefaults.string(forKey: "topic") != nil {
                    commonClass.SubscriptionWithTopic(TopicA: userDefaults.string(forKey: "topic")!, Completion: { po in
                        if let data: Payload = po {
                            self.deviceDataMainMenu = [data]

                            deviceData = [data]
                            // print("Main Menu " , deviceData)
                        }
                        DispatchQueue.main.async {
                            self.collectionView.reloadData()
                        }
                    })
                }

                let currentTime = Date()
                if deviceData.count > 0 {
                    if Int(currentTime.timeIntervalSinceNow - deviceData[0].time.timeIntervalSinceNow) > seconds {
                        deviceData.removeAll()
                        deviceDataMainMenu.removeAll()
                        DispatchQueue.main.async {
                            self.collectionView.reloadData()
                        }
                    }

                } else {
                    deviceData.removeAll()
                    deviceDataMainMenu.removeAll()
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                    }
                }
            } else {
                AWSConfig.shared.ConfigAWSIOTManager()
            }
        } else {
            deviceData.removeAll()
            deviceDataMainMenu.removeAll()
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
            WebServiceClass.shared.HideProgressHud()
        }
    }

    // MARK: - CLK

    @objc func tap(_: UITapGestureRecognizer) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "DeviceListVC") as! DeviceListVC
        navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction func clk_LogOut(_: Any) {
//        deviceData.removeAll()
//        deviceDataMainMenu.removeAll()
//
//        let domain = Bundle.main.bundleIdentifier!
//        UserDefaults.standard.removePersistentDomain(forName: domain)
//        UserDefaults.standard.synchronize()
//
//        navigationController?.popToRootViewController(animated: true)
    }

    func HeaderName() {
//               let a  =     deviceListArr.filter({ (a) -> Bool in
//                   if  a.serialNumber == self.deviceDataMainMenu[0].serial_num {
//
//                    userDefaults.set(a.warrantyLength, forKey: "warrantyLength")
//                    userDefaults.set(a.warrantyStartDate, forKey: "warrantyStartDate")
//                    userDefaults.set( a.nickname, forKey: "deviceHeader")
//                     self.lbl_HeaderName.text = userDefaults.string(forKey: "deviceHeader")
//                    self.viewHeader.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
//                   }
//                   else {
//
//                }
//                   return  true
//                    })
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }

        lbl_HeaderName.text = userDefaults.string(forKey: "deviceHeader")
        let dic = ["LoginID": commonClass.getloginDetails().oBJID, "token": commonClass.getloginDetails().token]
        deviceList.DeviceNameInMenu(viewcontroller: self, progress: false, dicSendData: dic as [String: AnyObject], completionHandler: { devicesLS in

            let jsonUser = JSON(devicesLS)
            let objUserA = try! JSONDecoder().decode(ListResponce.self, from: jsonUser.rawData())
            
            if objUserA.status != "Error" {
                if let devicelist = objUserA.devices {
                    self.deviceListArr = devicelist
                }
            } else {
                self.deviceListArr.removeAll()
            }
            
//            self.deviceListArr.contains(where: { (a) -> Bool in
//                if a.serialNumber == self.deviceDataMainMenu[0].serial_num {
//                    self.lbl_HeaderName.text = a.nickname
//                }
//                return true
//            })
            if self.deviceListArr.count > 0, self.deviceDataMainMenu.count > 0 {
                let a = self.deviceListArr.filter { (a) -> Bool in
                    if a.serialNumber == self.deviceDataMainMenu[0].serial_num {
                        self.lbl_HeaderName.isHidden = false
                        userDefaults.set(a.warrantyLength, forKey: "warrantyLength")
                        userDefaults.set(a.warrantyStartDate, forKey: "warrantyStartDate")
                        userDefaults.set(a.nickname, forKey: "deviceHeader")
                        //  self.lbl_HeaderName.text = userDefaults.string(forKey: "deviceHeader")
                        self.viewHeader.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                        return true
                    } else {
                        userDefaults.removeObject(forKey: "warrantyLength")
                        userDefaults.removeObject(forKey: "warrantyStartDate")
                        //  userDefaults.removeObject(forKey: "deviceHeader")

                        //  self.lbl_HeaderName.isHidden = true
                        return false
                    }
                }
                print(a)
            } else {
                if self.deviceListArr.count > 0 {
                    let b = self.deviceListArr.contains(where: { (res) -> Bool in
                        if userDefaults.string(forKey: "topic") != res.serialNumber {
                            print(">>>>>>>>>>>>>>>>>>>>> Not contain")
                        } else {
                            print(">>>>>>>>>>>>>>>>>>> contains ")
                        }
                        return true
                    })
                    let temo = self.deviceListArr.contains { $0.serialNumber == userDefaults.string(forKey: "topic") }
                    print(temo)
                    if !temo {
                        userDefaults.removeObject(forKey: "warrantyLength")
                        userDefaults.removeObject(forKey: "warrantyStartDate")
                        userDefaults.removeObject(forKey: "deviceHeader")
                        userDefaults.removeObject(forKey: "topic")

                        self.lbl_HeaderName.isHidden = true
                    }
//                    let a  =     self.deviceListArr.filter({ (a) -> Bool in
//                        if  a.serialNumber == userDefaults.string(forKey: "topic") {
//                            self.lbl_HeaderName.isHidden = false
//                            userDefaults.set(a.warrantyLength, forKey: "warrantyLength")
//                            userDefaults.set(a.warrantyStartDate, forKey: "warrantyStartDate")
//                            userDefaults.set( a.nickname, forKey: "deviceHeader")
//                            self.lbl_HeaderName.text = userDefaults.string(forKey: "deviceHeader")
//                            self.viewHeader.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
//                            return true
//                        }else {
//                            userDefaults.removeObject(forKey: "warrantyLength")
//                            userDefaults.removeObject(forKey: "warrantyStartDate")
//                            userDefaults.removeObject(forKey: "deviceHeader")
//                            userDefaults.removeObject(forKey: "topic")
//
//
//                            self.lbl_HeaderName.isHidden = true
//                            return  false
//                        }
//
//                    })
                    print(b)
                } else {
                    userDefaults.removeObject(forKey: "warrantyLength")
                    userDefaults.removeObject(forKey: "warrantyStartDate")
                    userDefaults.removeObject(forKey: "deviceHeader")
                    userDefaults.removeObject(forKey: "topic")

                    self.lbl_HeaderName.isHidden = true
                }
            }
            self.collectionView.reloadData()
            print(devicesLS)
        }) { err in
            print(err)
        }
    }

    /// -----------------------------

    // ------------------------------

    // MARK: - User wants to connect or disconnect from AWSIoT
}

extension
MainMenu: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return (MenuOptions.count)
        } else { return 1 }
    }

    func numberOfSections(in _: UICollectionView) -> Int {
        return 2
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MainCell
        if indexPath.section == 0 {
            if indexPath.item <= 7 {
                if deviceDataMainMenu.count > 0 {
                    //    lbl_HeaderName.isHidden = false
                    viewHeader.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                    cell.img_Menu_Options.image = UIImage(named: MenuImages[indexPath.item] as! String)
                    cell.alpha = 1
                    cell.img_Menu_Options.alpha = 1

                    if indexPath.row == 2 {
                        if deviceDataMainMenu.count > 0 {
                            if deviceDataMainMenu[0].fw_up == 1 {
                                cell.badge.isHidden = false
                            } else {
                                cell.badge.isHidden = true
                            }
                        }
                    } else if indexPath.row == 3 {
                        if userDefaults.string(forKey: "topic") != nil {
                            if userDefaults.string(forKey: "warrantyLength") == "0" || userDefaults.string(forKey: "warrantyStartDate") == nil {
                                cell.badge.isHidden = false
                            } else {
                                cell.badge.isHidden = true
                            }
                        }
                    } else {
                        cell.badge.isHidden = true
                    }
                } else {
                    //  lbl_HeaderName.isHidden = true
                    viewHeader.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                    cell.img_Menu_Options.image = UIImage(named: MenuImagesDeselected[indexPath.item] as! String)
                    if indexPath.row == 1 {
                        cell.alpha = 0.5
                        cell.img_Menu_Options.alpha = 0.5
                    } else {
                        cell.alpha = 1
                        cell.img_Menu_Options.alpha = 1
                    }

                    if indexPath.row == 2 {
                        if deviceDataMainMenu.count > 0 {
                            if deviceDataMainMenu[0].fw_up == 1 {
                                cell.badge.isHidden = false
                            } else {
                                cell.badge.isHidden = true
                            }
                        }
                    } else if indexPath.row == 3 {
                        if userDefaults.string(forKey: "topic") != nil {
                            if userDefaults.string(forKey: "warrantyLength") == "0" || userDefaults.string(forKey: "warrantyStartDate") == nil {
                                cell.badge.isHidden = false
                            } else {
                                cell.badge.isHidden = true
                            }
                        }
                    } else {
                        cell.badge.isHidden = true
                    }
                }

                cell.lbl_menu_Name.text = (MenuOptions[indexPath.item] as! String)
            }

        } else {
            cell.img_Menu_Options.image = #imageLiteral(resourceName: "ic_logout")
            cell.lbl_menu_Name.text = "Log Out"
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout _: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var width = CGFloat()
        var height = CGFloat()

        if indexPath.section == 0 {
            if indexPath.item <= 7 {
                if UIDevice.current.userInterfaceIdiom == .pad {
                    let padding: CGFloat = 40
                    let collectionViewSize = collectionView.frame.size.width - padding
                    width = (collectionViewSize / 2)
                    height = ((collectionViewSize / 3) + 11)
                    // return CGSize(width: (collectionViewSize/2) , height: ( (collectionViewSize/3) + 11 ))
                } else {
                    let padding: CGFloat = 50
                    let collectionViewSize = collectionView.frame.size.width - padding
                    width = (collectionViewSize / 2)
                    height = (collectionView.frame.size.height / 5)
                    //    return CGSize(width: (collectionViewSize/2) , height: collectionView.frame.size.height/5)
                }
            }

        } else if indexPath.section == 1, indexPath.row == 0 {
            width = collectionView.frame.width / 2.2
            height = collectionView.frame.size.height / 5
            //  return CGSize(width: (collectionView.frame.width - 100)/3 , height: (collectionView.frame.size.height/5) )
        }
        return CGSize(width: width, height: height)
    }

    func collectionView(_ collectionView: UICollectionView, layout _: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if section == 1 {
            let left = collectionView.frame.width - (collectionView.frame.width / 2)
            return UIEdgeInsets(top: 0, left: left, bottom: 5, right: left)
        }
        return UIEdgeInsets()
        // return  UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }

    func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, minimumLineSpacingForSectionAt _: Int) -> CGFloat {
        return 1.1
    }

    func collectionView(_: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            if indexPath.item == 0 {
                if deviceDataMainMenu.count == 0 {
                    if WebServiceClasses.Connectivity.isWifiConnected == true {
                        let str = espTouchNetworkDelegate.fetchSsid()
                        if str == "" {
                            let vc = storyboard?.instantiateViewController(withIdentifier: "WifiSearchVC") as! WifiSearchVC
                            navigationController?.pushViewController(vc, animated: true)
                        } else {
                            let vc = storyboard?.instantiateViewController(withIdentifier: "WifiSearchVC") as! WifiSearchVC
                            navigationController?.pushViewController(vc, animated: true)
                        }
                    } else {
                        let vc = storyboard?.instantiateViewController(withIdentifier: "WifiSearchVC") as! WifiSearchVC
                        navigationController?.pushViewController(vc, animated: true)
                    }
                } else {
                    Alert.showAlert(viewcontroller: self, title: AppName, message: "Device is already online")
                }
            } else if indexPath.item == 1 {
                if WebServiceClasses.Connectivity.isWifiConnected || WebServiceClasses.Connectivity.isConnectedToInternet {
                    if deviceDataMainMenu.count > 0 {
                        if deviceData.count > 0 {
                            let vc = storyboard?.instantiateViewController(withIdentifier: "StatusVc") as! StatusVc
                            navigationController?.pushViewController(vc, animated: true)
                        }
                    } else {
                        Alert.showAlert(viewcontroller: self, title: AppName, message: "No internet is available for device")
                    }
                } else {
                    commonClass.showCustomeAlert(self, messageA: "Check Internet Connectivity", MessageColor: "red")
                }
            } else if indexPath.item == 2 {
                if deviceDataMainMenu.count > 0 {
                    if deviceDataMainMenu[0].fw_up == 1 {
                        DispatchQueue.main.async {
                            AWSConfig.shared.ConnectToAWS(MQttStatus: { str in
                                WebServiceClasses.shared.HideProgressHud()
                                if str == "Connected" {
                                    if #available(iOS 10.0, *) {
                                        //                                let vc = self.storyboard?.instantiateViewController(withIdentifier: "DownloadVC") as! DownloadVC
                                        //                                self.navigationController?.pushViewController(vc, animated: true)

                                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "InstallingVC") as! InstallingVC
                                        self.navigationController?.pushViewController(vc, animated: true)

                                    } else {
                                        // Fallback on earlier versions
                                    }
                                } else if str == "" {
                                    print("Wait for MQTT connection")
                                }
                            })
                        }

                    } else {
                        Alert.showAlert(viewcontroller: self, title: AppName, message: "Your device is already updated!")
                    }
                } else {
                    Alert.showAlert(viewcontroller: self, title: AppName, message: "Device is not active..")
                    //  commonClass.showCustomeAlert(self, messageA: "Your device is updated..!", MessageColor: "Green")
                }

                //            let vc = storyboard?.instantiateViewController(withIdentifier: "VideosVC") as! VideosVC
                //            navigationController?.pushViewController(vc, animated: true)
            } else if indexPath.item == 3 {
                //            let vc = storyboard?.instantiateViewController(withIdentifier: "DeviceListVC") as! DeviceListVC
                //            navigationController?.pushViewController(vc, animated: true)

                if userDefaults.string(forKey: "topic") != nil, userDefaults.string(forKey: "deviceUID") != nil {
                    let vc = storyboard?.instantiateViewController(withIdentifier: "PurchasePlansDetailListVC") as! PurchasePlansDetailListVC
                    navigationController?.pushViewController(vc, animated: true)
                } else {
                    Alert.showAlert(viewcontroller: self, title: AppName, message: "Please select device!")
                }
            } else if indexPath.item == 4 {
                let vc = storyboard?.instantiateViewController(withIdentifier: "DeviceListVC") as! DeviceListVC
                navigationController?.pushViewController(vc, animated: true)
            } else if indexPath.item == 5 {
                let vc = storyboard?.instantiateViewController(withIdentifier: "StatisticVC") as! StatisticVC
                navigationController?.pushViewController(vc, animated: true)

//                let vc = self.storyboard?.instantiateViewController(withIdentifier: "ScanYourDevice") as! ScanYourDevice
//                self.navigationController?.pushViewController(vc, animated: true)
                //            let vc = storyboard?.instantiateViewController(withIdentifier: "SupportVC") as! SupportVC
                //            navigationController?.pushViewController(vc, animated: true)
            } else if indexPath.item == 6 {
                let vc = storyboard?.instantiateViewController(withIdentifier: "VideosVC") as! VideosVC
                navigationController?.pushViewController(vc, animated: true)
                //
            } else if indexPath.item == 7 {
                let vc = storyboard?.instantiateViewController(withIdentifier: "UserManualVC") as! UserManualVC
                navigationController?.pushViewController(vc, animated: true)
            }
        }
        if indexPath.section == 1 {
            if indexPath.item == 0 {
                //      collectionView.reloadData()
                Alert.showAlertWithHandler(viewcontroller: self, title: AppName, message: "Are you sure you want logout?", buttonsTitles: ["Yes", "Cancel"], showAsActionSheet: false) { i in
                    if i == 0 {
                        self.deviceDataMainMenu.removeAll()
                        self.deviceListArr.removeAll()

//                        deviceData.removeAll()
//                        DeviceListArr.removeAll()
//                        let domain = Bundle.main.bundleIdentifier!
//                        UserDefaults.standard.removePersistentDomain(forName: domain)
//                        UserDefaults.standard.synchronize()

                        userDefaults.removeObject(forKey: logginToken)
                        self.navigationController?.popToRootViewController(animated: true)
                    } else {}
                }
            }
        }
    }
}

class MainCell: UICollectionViewCell {
    //  @IBOutlet weak var lblHeight: NSLayoutConstraint!

    //  @IBOutlet weak var imgTrailingConstrain: NSLayoutConstraint!
    // @IBOutlet weak var imgLeadingConstrain: NSLayoutConstraint!
    @IBOutlet var img_Menu_Options: UIImageView!
    @IBOutlet var lbl_menu_Name: UILabel!

    @IBOutlet var badge: UIView!
    override func awakeFromNib() {
        FontSizeInSmallDevice()
        badge.isHidden = true
    }

    func FontSizeInSmallDevice() {
        if UIDevice.current.isIphone5S() {
            print("UIDevice.current.isIphone5S()", UIDevice.current.isIphone5S())
            // lbl_menu_Name.text = ""
            // lbl_menu_Name.font =  lbl_menu_Name.font.withSize(10)
        }
    }
}

extension UIDevice {
    func isIphone5S() -> Bool {
        switch UIScreen.main.nativeBounds.height {
        case 1136:
            print("iPhone 5 or 5S or 5C")
            return true

        default:
            return false
        }
    }
}
