//
//  DeviceListVC.swift
//  Gemini Medical Device App
//
//  Created by TechnoMac-1 on 01/04/19.
//  Copyright © 2019 TechnoMac-1. All rights reserved.
//

import UIKit
var DeviceListArr = [Devices]()
class DeviceListVC: baseVC {
    var devicePayload = [[Payload]]()
    var devicePayLoadAll = [Payload]()
    var names = [String]()
    var seconds = 15
    var timer: Timer?
    @IBOutlet var tblView: UITableView!

    // MARK: - ViewController life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        scheduledTimerWithTimeInterval()
        // callAPi()
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        callAPi()
        print(">>>>>>>>>>>>>>> ")
        //    DefaultDeviceSubscriptionData()
    }

    override func viewWillDisappear(_: Bool) {
        if DeviceListArr.count > 0 {
            for i in DeviceListArr {
                AWSConfig.shared.UnsubscribeTopics(topicA: i.serialNumber!)
            }
        }
        stopTimer()
    }

    // MARK: - Clicks

    @IBAction func clk_back(_: Any) {
        if deviceData.count > 0 {
            if deviceData[0].serial_num == userDefaults.string(forKey: "topic") {
            } else {
                deviceData.removeAll()
            }
        } else {}
        let Menuvc = storyboard?.instantiateViewController(withIdentifier: "MainMenu") as! MainMenu
        let vcA = navigationController!.viewControllers[navigationController!.viewControllers.count - 3]
        if vcA.isKind(of: Menuvc.classForCoder) {
            navigationController?.popToViewController(vcA, animated: true)

        } else {
            navigationController?.popViewController(animated: true)
        }
    }

    @IBAction func clk_addNewDevcie(_: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "ScanYourDevice") as! ScanYourDevice
        navigationController?.pushViewController(vc, animated: true)
    }

    // MARK: - Function for default subscribed device data

    func scheduledTimerWithTimeInterval() {
        // Scheduling timer to Call the function "updateCounting" with the interval of 15 seconds
        if timer == nil {
            timer = Timer.scheduledTimer(timeInterval: TimeInterval(5), target: self, selector: #selector(updateCounting), userInfo: nil, repeats: true)
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
        if seconds != 0 {
            seconds -= 1
            print(seconds)
        } else {
            seconds = 15
            MAintainDeviceStatusOnline()
        }
    }

    func DefaultDeviceSubscriptionData() {
        // deviceData.removeAll()

        if userDefaults.object(forKey: "deviceUID") != nil &&
            userDefaults.object(forKey: "topic") != nil {
            DispatchQueue.main.async {
                commonClass.DefaultDeviceSubscriptionDataForApp { PayLoad in
                    deviceData = [PayLoad]
                    DispatchQueue.main.async {
                        self.tblView.reloadData()
                    }
                }
            }
        }
        userDefaults.synchronize()
        // self.tblView.reloadData()
    }

    // MARK: - Functions

    // MARK: - API Call Functions

    func callAPi() {
        let dic = ["LoginID": commonClass.getloginDetails().oBJID, "token": commonClass.getloginDetails().token]
        deviceList.DeviceListWebService(viewcontroller: self, progress: true, dicSendData: dic as [String: AnyObject], completionHandler: { devicesLS in
            
            let jsonUser = JSON(devicesLS)
            let objUserA = try! JSONDecoder().decode(ListResponce.self, from: jsonUser.rawData())
            var arr: [Devices]? = nil
            if let devicelist = objUserA.devices {
                arr = devicelist
            }
            
            //let arr: [Devices] = devicesLS

            if objUserA.status == "Error" {
                if (objUserA.response == "No devices found") {
                    DeviceListArr.removeAll()
                }
                DeviceListArr.removeAll()
            } else {
                if DeviceListArr == arr {
                } else {
                    DeviceListArr = arr!
                }
            }
//            DispatchQueue.main.async {
//                if  deviceListArr.count > 0 {
//                    for i in  deviceListArr {
//
//                        commonClass.SubscriptionWithTopic(TopicA: i.serialNumber!, Completion: { (Payload) in
//                            debugPrint("SubScribe multiple Topics")
//                            debugPrint("SubScribe multiple Topics Multiple Device response", Payload.serial_num)
//                            self.devicePayLoadAll = [Payload]
//
//
//                            if self.devicePayLoadAll.count == 0 {
//                                if deviceData.count > 0 {
//                                    self.devicePayload.append(self.devicePayLoadAll)
//                                    let name = self.devicePayLoadAll[0].serial_num
//                                    self.names.append(name!)
//                                }
//
//                            }else {
//
//
//
//                                if self.devicePayLoadAll.count > 0 {
//                                    let name = self.devicePayLoadAll[0].serial_num
//                                    if !self.names.contains(name!) {
//                                        self.names.append(name!)
//                                        self.devicePayload.append(self.devicePayLoadAll)
//                                    }
//                                }
//
//
//
//                            }
//
//
//
//                            if self.devicePayLoadAll.count > 0 {
//                                for a in  deviceListArr {
//
//                                    if  self.devicePayLoadAll.contains(where: { a.serialNumber == $0.serial_num}) {
//                                        //  self.devicePayload.append(deviceData)
//                                        a.isOnline = true
//                                    }else {
//                                        //  a.isOnline  = false
//                                    }
//                                }
//
//                            }
//
//
//                            DispatchQueue.main.async {
//
//                                self.tblView.reloadData()
//                            }
//                        })
//                    }
//
//
//                }
//            }
            self.MAkeDeviceOnline()
            self.tblView.reloadData()

            print(devicesLS)
        }) { err in
            print(err)
        }
    }

    // MARK: - Check Data from multiple payload response and make label green (Make it online )

    func MAkeDeviceOnline() {
        if DeviceListArr.count > 0 {
            for i in DeviceListArr {
                commonClass.SubscriptionWithTopic(TopicA: i.serialNumber!, Completion: { Payload in
                    debugPrint("SubScribe multiple Topics")
                    debugPrint("SubScribe multiple Topics Multiple Device response", Payload.serial_num)
                    self.devicePayLoadAll = [Payload]

                    if self.devicePayLoadAll.count == 0 {
                        if deviceData.count > 0 {
                            self.devicePayload.append(self.devicePayLoadAll)
                            let name = self.devicePayLoadAll[0].serial_num
                            self.names.append(name!)
                        }

                    } else {
                        if self.devicePayLoadAll.count > 0 {
                            let name = self.devicePayLoadAll[0].serial_num
                            if !self.names.contains(name!) {
                                self.names.append(name!)
                                self.devicePayload.append(self.devicePayLoadAll)
                            }
                        }
                    }

                    if self.devicePayLoadAll.count > 0 {
                        for a in DeviceListArr {
                            if self.devicePayLoadAll.contains(where: { a.serialNumber == $0.serial_num }) {
                                //  self.devicePayload.append(deviceData)
                                a.isOnline = true
                            } else {
                                //  a.isOnline  = false
                            }
                        }
                    }

                    DispatchQueue.main.async {
                        self.tblView.reloadData()
                    }
                })
            }
        }
    }

    // MARK: - MAINTAIN live status of  device which are  listed in API

    func MAintainDeviceStatusOnline() {
        let temp = Date()

        for a in DeviceListArr {
            //    a.isOnline =   devicePayload.contains(where: { a.serialNumber == $0[0].serial_num})
            //     print("device \(a.isOnline , a.serialNumber , devicePayload.contains(where: { a.serialNumber == $0[0].serial_num}))")
            a.isOnline = devicePayload.contains(where: { (ad) -> Bool in
                let flag: Bool?
                if a.serialNumber == ad[0].serial_num {
                    flag = temp.timeIntervalSinceNow - ad[0].time.timeIntervalSinceNow > 15 ? false : true
                    print("flag:", flag)
                } else {
                    return false
                }
                return flag ?? false

            })
            // a.isOnline = devicePayload.contains(where: {temp.timeIntervalSinceNow - $0[0].time.timeIntervalSinceNow > 10 ? true : false})
        }
        devicePayload.removeAll()
        DispatchQueue.main.async {
            self.tblView.reloadData()
        }
        //        if deviceData.count > 0  && deviceListArr.count > 0 {
        //            for a in self.deviceListArr {
        //
        //                if  deviceData.contains(where: { a.serialNumber == $0.serial_num}) {
        //
        //                    a.isOnline = true
        //                }else {
        //                    a.isOnline  = false
        //                }
        //            }
        //
        //        }
    }

    func DeleteDeviceName(serialNumber: String, UID: String) {
        let dic = [
            "SerialNumber": serialNumber,
            "UID": UID,
            "LoginID": UserDefaults.standard.string(forKey: loginObjId),
            "token": UserDefaults.standard.string(forKey: logginToken),
        ]

        DeleteDevice.DeviceNameDeleteWebService(viewcontroller: self, progress: true, dicSendData: dic as [String: AnyObject], completionHandler: { Test in
            print(Test)
            commonClass.showCustomeAlert(self, messageA:"Device successfully deleted", MessageColor: "red")
            WebServiceClass.shared.AddProgressHud()
            self.callAPi()

            self.tblView.reloadData()
        }) { err in
            print(err.localizedDescription)
        }
    }
}

extension DeviceListVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return DeviceListArr.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! deviceCellClass
        cell.selectionStyle = .none
        DispatchQueue.main.async {
            cell.lbl_DeviceName.text = DeviceListArr[indexPath.row].nickname?.count == 0 ? "N/A" : DeviceListArr[indexPath.row].nickname

            //  if self.devicePayLoadAll.count > 0 &&  deviceListArr.count > 0 {
            if DeviceListArr.count > 0 {
                if let flage = DeviceListArr[indexPath.row].isOnline {
                    if flage == true {
                        cell.view_Device.backgroundColor = #colorLiteral(red: 0.04705882353, green: 0.9803921569, blue: 0.05490196078, alpha: 1)
                    } else {
                        cell.view_Device.backgroundColor = #colorLiteral(red: 1, green: 0, blue: 0, alpha: 1)
                    }

                } else {
                    cell.view_Device.backgroundColor = #colorLiteral(red: 1, green: 0, blue: 0, alpha: 1)
                }

            } else {
                cell.view_Device.backgroundColor = #colorLiteral(red: 1, green: 0, blue: 0, alpha: 1)
            }
        }

        return cell
    }

    func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        let abc = DeviceListArr[indexPath.row].uID
        let topicA = DeviceListArr[indexPath.row].serialNumber!

        userDefaults.removeObject(forKey: "deviceUID")
        userDefaults.removeObject(forKey: "topic")
        userDefaults.set(abc, forKey: "deviceUID")

        userDefaults.set(topicA, forKey: "topic")
        userDefaults.set(DeviceListArr[indexPath.row].warrantyLength, forKey: "warrantyLength")
        userDefaults.set(DeviceListArr[indexPath.row].warrantyStartDate, forKey: "warrantyStartDate")

        AWSConfig.shared.UnSubScribe()
        print(topic)
        topic = userDefaults.string(forKey: "topic")!
        DefaultDeviceSubscriptionData()
        userDefaults.set(DeviceListArr[indexPath.row].nickname, forKey: "deviceHeader")
        if DeviceListArr[indexPath.row].isOnline == true {
            let Menuvc = storyboard?.instantiateViewController(withIdentifier: "MainMenu") as! MainMenu
            let vcA = navigationController!.viewControllers[navigationController!.viewControllers.count - 3]
            if vcA.isKind(of: Menuvc.classForCoder) {
                navigationController?.popToViewController(vcA, animated: true)

            } else {
                navigationController?.popViewController(animated: true)
            }
            //               self.navigationController?.popViewController(animated: true)
            //            let vc = storyboard?.instantiateViewController(withIdentifier: "StatusVc") as! StatusVc
            //            navigationController?.pushViewController(vc, animated: true)
        } else {
            if deviceData.count > 0 {
                if deviceData[0].serial_num == userDefaults.string(forKey: "topic") {
                } else {
                    deviceData.removeAll()
                }
            } else {}
            let Menuvc = storyboard?.instantiateViewController(withIdentifier: "MainMenu") as! MainMenu
            let vcA = navigationController!.viewControllers[navigationController!.viewControllers.count - 3]
            if vcA.isKind(of: Menuvc.classForCoder) {
                navigationController?.popToViewController(vcA, animated: true)

            } else {
                navigationController?.popViewController(animated: true)
            }
        }
    }

    // Swipe Device list cell
    @available(iOS 11.0, *)
    func tableView(_: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        /*let contextItem = UIContextualAction(style: .normal, title: "Edit") { _, _, boolValue in

            boolValue(true) // pass true if you want the handler to allow the action
            print("Edit call")
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "EditAccountVCViewController") as! EditAccountVCViewController
            vc.serialNumber = DeviceListArr[indexPath.row].serialNumber!
            vc.UID = DeviceListArr[indexPath.row].uID!
            vc.nickname = DeviceListArr[indexPath.row].nickname!
            self.navigationController?.pushViewController(vc, animated: true)
        }*/
        //    contextItem.backgroundColor = .red
        let contextItemDelete = UIContextualAction(style: .normal, title: "Delete") { _, _, boolValue in
            boolValue(true) // pass true if you want the handler to allow the action
            print("Trailing Action style .normal")

            Alert.showAlertWithHandler(viewcontroller: self, title: AppName, message: "Are you sure you want to delete device ?", okButtonTitle: "Yes", cancelButtionTitle: "No") { index in
                switch index {
                case AlertAction.Ok:
                    WebServiceClass.shared.AddProgressHud()
                    self.DeleteDeviceName(serialNumber: DeviceListArr[indexPath.row].serialNumber!, UID: DeviceListArr[indexPath.row].uID!)

                case AlertAction.Cancel:
                    print("NO button pressed")
                }
            }
        }
        contextItemDelete.backgroundColor = .red
        //       contextItem.backgroundColor = .blue
        let swipeActions = UISwipeActionsConfiguration(actions: [contextItemDelete])

        return swipeActions
    }

    @available(iOS 11.0, *)
    func tableView(_: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        /*let contextItem = UIContextualAction(style: .normal, title: "Edit") { _, _, boolValue in

            boolValue(true) // pass true if you want the handler to allow the action
            print("Edit call")
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "EditAccountVCViewController") as! EditAccountVCViewController
            vc.serialNumber = DeviceListArr[indexPath.row].serialNumber!
            vc.UID = DeviceListArr[indexPath.row].uID!
            vc.nickname = DeviceListArr[indexPath.row].nickname!
            self.navigationController?.pushViewController(vc, animated: true)
        }*/
        let contextItemDelete = UIContextualAction(style: .normal, title: "Delete") { contextualAction, _, boolValue in
            boolValue(true) // pass true if you want the handler to allow the action
            print("Trailing Action style .normal")

            Alert.showAlertWithHandler(viewcontroller: self, title: AppName, message: "Are you sure you want to delete device ?", okButtonTitle: "Yes", cancelButtionTitle: "No") { index in
                switch index {
                case AlertAction.Ok:
                    WebServiceClass.shared.AddProgressHud()
                    self.DeleteDeviceName(serialNumber: DeviceListArr[indexPath.row].serialNumber!, UID: DeviceListArr[indexPath.row].uID!)
                case AlertAction.Cancel:
                    print("NO button pressed")
                }
            }

            contextualAction.backgroundColor = .red
        }
        contextItemDelete.backgroundColor = .red
        //   contextItem.backgroundColor = .green
        let swipeActions = UISwipeActionsConfiguration(actions: [contextItemDelete])

        return swipeActions
    }

    func tableView(_: UITableView, willBeginEditingRowAt _: IndexPath) {
        tblView.subviews.forEach { subview in
            print("YourTableViewController: \(String(describing: type(of: subview)))")
            if String(describing: type(of: subview)) == "UISwipeActionPullView" {
                if String(describing: type(of: subview.subviews[0])) == "UISwipeActionStandardButton" {
                    var deleteBtnFrame = subview.subviews[0].frame
                    deleteBtnFrame.origin.y = 0
                    deleteBtnFrame.size.height = 50

                    // Subview in this case is the whole edit View
                    subview.frame.origin.y = subview.frame.origin.y + 0
                    subview.frame.size.height = 50
                    subview.subviews[0].frame = deleteBtnFrame
                    subview.backgroundColor = UIColor.yellow
                }
            }
        }
    }
}

class deviceCellClass: UITableViewCell {
    @IBOutlet var view_Device: UIView!
    @IBOutlet var lbl_DeviceName: UILabel!
    override func awakeFromNib() {}
}

extension Array where Element: Equatable {
    mutating func removeDuplicates() {
        var result = [Element]()
        for value in self {
            if !result.contains(value) {
                result.append(value)
            }
        }
        self = result
    }
}
