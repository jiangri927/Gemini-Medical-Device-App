//
//  ScanedQRDetailsVC.swift
//  Gemini Medical Device App
//
//  Created by TechnoMac-1 on 27/03/19.
//  Copyright © 2019 TechnoMac-1. All rights reserved.
//

import UIKit

class ScanedQRDetailsVC: baseVC {
    // MARK: - Variables

    var code = String()
    var serialID = String()
    var UId = String()

    // MARK: - Outlets

    @IBOutlet var lbl_str1: UILabel!
    @IBOutlet var lbl_str2: UILabel!

    // MARK: - View Controller  Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        if code != "" {
            let str = code.components(separatedBy: ",")
            lbl_str1.text = str[0]
            serialID = str[0]
            UId = str[1]
            lbl_str2.text = str[1]
        }
        // Do any additional setup after loading the view.
    }

    // MARK: -  BUTTON ACTIONS

    @IBAction func clk_back(_: Any) {
        navigationController?.popViewController(animated: true)
    }

    @IBAction func clk_registerDevice(_: Any) {
        validation()
    }

    // MARK: - Custom Functions

    func validation() {
        if code == "" {
            commonClass.showCustomeAlert(self, messageA: "Please scan barcode again", MessageColor: "red")
        } else if commonClass.getloginDetails().oBJID == "" || commonClass.getloginDetails().token == "" {
            commonClass.showCustomeAlert(self, messageA: "There is an issue with your login,  \n Please login again.", MessageColor: "red")
        } else {
            callApiToRegisterDevice()
        }
    }

    // MARK: - APICALL

    func callApiToRegisterDevice() {
        let dicdata = ["LoginID": commonClass.getloginDetails().oBJID, "token": commonClass.getloginDetails().token, "SerialNumber": serialID, "UID": UId] as [String: AnyObject]
        RegisterDeviceModel.RegisterDeviceWebService(viewcontroller: self, progress: true, DicData: dicdata, completionHandler: { _ in

            commonClass.showCustomeAlert(self, messageA: "Device registed successfully!", MessageColor: "green")

        }) { err in
            commonClass.showCustomeAlert(self, messageA: err as! String, MessageColor: "red")
        }
    }
}
