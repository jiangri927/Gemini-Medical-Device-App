//
//  EditAccountVCViewController.swift
//  Gemini Medical Device App
//
//  Created by TechnoMac-1 on 24/09/19.
//  Copyright © 2019 TechnoMac-1. All rights reserved.
//

import UIKit

class EditAccountVCViewController: baseVC {
    // MARK: - VARIABLES

    var UID = String()
    var serialNumber = String()
    var nickname = String()

    // MARK: - Outlets

    @IBOutlet var txt_editNickName: UITextField!
    @IBOutlet var btn_EditNickName: UIButton!

    // MARK: - View controller life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_: Bool) {
        txt_editNickName.text = nickname
    }
    
    // MARK: - button actions

    @IBAction func clk_Back(_: Any) {
        //navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: {})
    }

    @IBAction func clk_EditName(_: Any) {
        if txt_editNickName.text != "" {
            callAPI()
        }
    }

    // MARK: - API CALL Method

    func callAPI() {
        let dic = [
            "Nickname": txt_editNickName.text!,
            "LoginID": UserDefaults.standard.string(forKey: loginObjId),
            "token": UserDefaults.standard.string(forKey: logginToken),
            "SerialNumber": serialNumber,
            "UID": UID,
        ]
        EditNickName.DeviceNameEditWebService(viewcontroller: self, progress: true, dicSendData: dic as [String: AnyObject], completionHandler: { _ in
            //self.navigationController?.popViewController(animated: true)
            userDefaults.set(self.txt_editNickName.text, forKey: "deviceHeader")
            self.dismiss(animated: true, completion: {})
        }) { err in
            print(err.localizedDescription)
        }
    }
}
