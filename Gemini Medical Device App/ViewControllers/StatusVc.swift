//
//  StatusVc.swift
//  Gemini Medical Device App
//
//  Created by TechnoMac-1 on 22/03/19.
//  Copyright © 2019 TechnoMac-1. All rights reserved.
//

import UIKit
var deviceData = [Payload]()

class StatusVc: baseVC {
    var deviceListArr = [Devices]()
    var nickName = String()
    var seconds = 10
    var timer: Timer?
    @IBOutlet var tblView: UITableView!
    var deviceDataForSingleDevice = [Payload]()

    // MARK: - Viewcontroller Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        //    callAPi()
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_: Bool) {
//        if deviceListArr.count > 0 {
//            for i in self.deviceListArr {
//                AWSConfig.shared.UnsubscribeTopics(topicA: i.serialNumber!)
//            }
//        }
//
        // DefaultDeviceSubscriptionData()
        tblView.reloadData()
        scheduledTimerWithTimeInterval()
    }

    override func viewWillDisappear(_: Bool) {
        stopTimer()
    }

    @IBAction func clk_back(_: Any) {
        let viewControllers: [UIViewController] = navigationController!.viewControllers

        for aViewController in viewControllers {
            if aViewController is MainMenu {
                navigationController!.popToViewController(aViewController, animated: true)
            }
        }
    }

    @IBAction func clk_MonitorOtherUnit(_: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "DeviceListVC") as! DeviceListVC
        let vcA = navigationController!.viewControllers[navigationController!.viewControllers.count - 2]
        if vcA.isKind(of: vc.classForCoder) {
            navigationController?.popViewController(animated: true)

        } else {
            navigationController?.pushViewController(vc, animated: true)
        }
    }

    func GreenStatus() {}

    // MARK: - APICALL

    func callAPi() {
        let dic = ["LoginID": commonClass.getloginDetails().oBJID, "token": commonClass.getloginDetails().token]
        deviceList.DeviceNameInMenu(viewcontroller: self, progress: false, dicSendData: dic as [String: AnyObject], completionHandler: { devicesLS in

            let jsonUser = JSON(devicesLS)
            let objUserA = try! JSONDecoder().decode(ListResponce.self, from: jsonUser.rawData())
            
            if objUserA.status != "Error" {
                if let devicelist = objUserA.devices {
                    self.deviceListArr = devicelist
                }
            }
            
            //self.deviceListArr = devicesLS
//            if self.deviceListArr.count > 0 {
//                userDefaults.set(self.deviceListArr[0].uID, forKey: "deviceUID")
//
//
//
//            }

//            if self.deviceListArr.count > 0 {
//                for i in self.deviceListArr {
//                    commonClass.SubscriptionWithTopic(TopicA: i.serialNumber!, Completion: { (Payload) in
//                        //    debugPrint("SubScribe multiple Topics")
//                        //    debugPrint("Multiple Device response", Payload)
//                        self.deviceData = [Payload]
//                        DispatchQueue.main.async {
//                            self.tblView.reloadData()
//                        }
//                    })
//                }
//
//
//            }
            //   self.reload(tableView: self.tblView)
            self.tblView.reloadData()
            print(devicesLS)
        }) { err in
            print(err)
        }
    }

    // MARK: - Function for default subscribed device data

    func scheduledTimerWithTimeInterval() {
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
        if seconds != 0 {
            seconds -= 1
        } else {
            tblView.reloadData()
        }
        // print(deviceData)
        print(seconds)
    }

    // MARK: - Function for default subscribed device data

    func DefaultDeviceSubscriptionData() {
        deviceDataForSingleDevice.removeAll()
        deviceData.removeAll()
        if userDefaults.object(forKey: "deviceUID") != nil &&
            userDefaults.object(forKey: "topic") != nil {
            DispatchQueue.main.async {
                AWSConfig.shared.ConnectToAWS(MQttStatus: { str in
                    WebServiceClasses.shared.HideProgressHud()
                    if str == "Connected" {
                        commonClass.SubscriptionWithTopic(TopicA: userDefaults.string(forKey: "topic")!, Completion: { po in

                            if let data: Payload = po {
                                if po.serial_num == userDefaults.string(forKey: "topic")! {
                                    self.deviceDataForSingleDevice = [data]
                                    deviceData = [data]
                                }
                            }
                            DispatchQueue.main.async {
                                //  self.reload(tableView: self.tblView)
                                self.tblView.reloadData()
                            }
                        })

                    } else {
                        print("Wait for MQTT connection")
                    }
                })
            }
        }
        print("dddddd", deviceData)
        userDefaults.synchronize()
        // self.reload(tableView: self.tblView)
        tblView.reloadData()
    }

    func reload(tableView: UITableView) {
        let contentOffset = tableView.contentOffset
        tableView.reloadData()
        tableView.layoutIfNeeded()
        tableView.setContentOffset(contentOffset, animated: false)
    }
}

extension StatusVc: UITableViewDataSource, UITableViewDelegate {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        if deviceListArr.count > 0 {
            return 6 + deviceListArr.count
        } else {
            return 6
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        // cell.configcell(with: deviceData[0])
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell1") as! HardwareData
            cell.selectionStyle = .none
            if deviceData.count > 0 {
                cell.lbl_batch.text = deviceData[0].batch ?? ""
                cell.lbl_SerialNumber.text = deviceData[0].serial_num ?? ""

                cell.lbl_accountName.text = userDefaults.string(forKey: "deviceHeader")?.maxLength(length: 10)

            } else {
                cell.lbl_batch.text = ""
                cell.lbl_SerialNumber.text = ""
                cell.lbl_accountName.text = ""
            }
            return cell
        }
        if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell2") as! HardwareData
            cell.selectionStyle = .none
            if deviceData.count > 0 {
                cell.lbl_wifiStatus.text = deviceData[0].wifi == 0 ? "Disconnected" : "Connected"
                cell.lbl_wifiStatus.textColor = deviceData[0].wifi == 0 ? UIColor.red : #colorLiteral(red: 0.4392156863, green: 0.4392156863, blue: 0.4392156863, alpha: 1)
                cell.img_Wifi.isHidden = deviceData[0].wifi == 0 ? true : false
                seconds = deviceData[0].wifi == 0 ? 3 : 30
            } else {
                cell.lbl_wifiStatus.text = ""
            }
            return cell
        }
        if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell3", for: indexPath) as! HardwareData
            cell.selectionStyle = .none
            if deviceData.count > 0 {
                cell.lbl_BetryVoltage.text = "\(deviceData[0].v ?? 1)V"
                cell.lbl_betryCurrent.text = "\(deviceData[0].i ?? 1)mA"
            } else {
                cell.lbl_BetryVoltage.text = "0 V"
                cell.lbl_betryCurrent.text = "0 mA"
            }

            return cell
        }
        if indexPath.row == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell4", for: indexPath) as! HardwareData
            cell.selectionStyle = .none
            if deviceData.count > 0 {
                cell.lbl_Cal_810Life.text = "\(deviceData[0].life810 ?? 1)"
                cell.lbl_cal_980Life.text = "\(deviceData[0].life980 ?? 1)"
            } else {
                cell.lbl_Cal_810Life.text = " "
                cell.lbl_cal_980Life.text = " "
            }
            return cell
        }
        if indexPath.row == 4 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell5", for: indexPath) as! HardwareData
            cell.selectionStyle = .none
            return cell
        }
        if indexPath.row == 5 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell6", for: indexPath) as! HardwareData
            cell.selectionStyle = .none
            if deviceData.count > 0 {
                cell.lbl_bleStatus.text = deviceData[0].ble == 0 ? "Disconnected" : "Connected"
                cell.lbl_bleStatus.textColor = deviceData[0].ble == 0 ? UIColor.red : #colorLiteral(red: 0.4392156863, green: 0.4392156863, blue: 0.4392156863, alpha: 1)
                cell.img_Ble.isHidden = deviceData[0].ble == 0 ? true : false
            } else {
                cell.lbl_bleStatus.text = " "
                cell.lbl_bleStatus.textColor = #colorLiteral(red: 0.5141925812, green: 0.5142051578, blue: 0.5141984224, alpha: 1)
            }
            return cell
        }
        if indexPath.row > 5 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell7", for: indexPath) as! StatusDeviceListCell
            cell.selectionStyle = .none

            cell.deviceName.text = deviceListArr[indexPath.row - 6].nickname?.maxLength(length: 10) ?? ""

            cell.tag = indexPath.row - 6
            if deviceDataForSingleDevice.count > 0, deviceListArr.count > 0 {
                if deviceListArr[indexPath.row - 6].serialNumber == deviceDataForSingleDevice[0].serial_num {
                    cell.view_Device.backgroundColor = #colorLiteral(red: 0.04705882353, green: 0.9803921569, blue: 0.05490196078, alpha: 1)
                } else {
                    cell.view_Device.backgroundColor = #colorLiteral(red: 1, green: 0.7972176075, blue: 0.02696928382, alpha: 1)
                }

            } else {
                cell.view_Device.backgroundColor = #colorLiteral(red: 1, green: 0.7960784314, blue: 0.02745098039, alpha: 1)
            }

            return cell
        }

        return cell
    }

    func tableView(_: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 4 {
            return 0
        } else if indexPath.row > 5 {
            return 0
        } else {
            return (UIScreen.main.bounds.height / 7.5)
        }
    }

    func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        if indexPath.row > 5 {
            let abc = deviceListArr[indexPath.row - 6].uID
            let topicA = deviceListArr[indexPath.row - 6].serialNumber!
            userDefaults.removeObject(forKey: "deviceUID")
            userDefaults.removeObject(forKey: "topic")
            userDefaults.set(abc, forKey: "deviceUID")
            nickName = deviceListArr[indexPath.row - 6].nickname ?? "No Nick Name Given"
            userDefaults.set(topicA, forKey: "topic")
            if userDefaults.string(forKey: "topic") == topicA {
            } else {
                AWSConfig.shared.UnSubScribe()
            }
            print(topic)
            topic = userDefaults.string(forKey: "topic")!
            userDefaults.set(deviceListArr[indexPath.row - 6].warrantyLength, forKey: "warrantyLength")
            userDefaults.set(deviceListArr[indexPath.row - 6].warrantyStartDate, forKey: "warrantyStartDate")
            userDefaults.set(nickName, forKey: "deviceHeader")
            DefaultDeviceSubscriptionData()
        }
    }
}

// Cell :- cell class list

class StatusDeviceListCell: UITableViewCell {
    @IBOutlet var view_Device: UIView!
    @IBOutlet var deviceName: UILabel!
    override func awakeFromNib() {}
}

class HardwareData: UITableViewCell {
    @IBOutlet var lbl_SerialNumber: UILabel!

    @IBOutlet var lbl_batch: UILabel!
    @IBOutlet var lbl_accountName: UILabel!
    @IBOutlet var lbl_wifiStatus: UILabel!

    @IBOutlet var img_Wifi: UIImageView!
    /// betry status
    @IBOutlet var lbl_betryLevel: UILabel!

    @IBOutlet var lbl_BetryVoltage: UILabel!

    @IBOutlet var lbl_betryCurrent: UILabel!

    @IBOutlet var lbl_betryToEmpty: UILabel!

    /// Calibration
    @IBOutlet var lbl_Cal_810Life: UILabel!

    @IBOutlet var lbl_cal_980Life: UILabel!

    @IBOutlet var img_Ble: UIImageView!
    @IBOutlet var lbl_bleStatus: UILabel!
    override func awakeFromNib() {}

    func configcell(with payload: Payload) {
        lbl_batch.text = payload.batch
        lbl_SerialNumber.text = payload.serial_num
        // lbl_betryLevel.text =
        //        lbl_wifiStatus.text = payload.wifi == 0 ? "not connected" : "connected"
        //        //lbl_betryLevel.text = payload.
        //        lbl_BetryVoltage.text = "\(payload.v ?? 0)V"
        //        lbl_betryCurrent.text = "\(payload.i ?? 0)mA"
        //        // lbl_betryToEmpty.text
        //        lbl_Cal_810Life.text = payload.life810?.description ?? "0"
        //        lbl_cal_980Life.text  = payload.life980?.description ?? "0"
    }
}
