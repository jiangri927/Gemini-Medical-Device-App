//
//  ScanningCompletedVC.swift
//  Gemini Medical Device App
//
//  Created by TechnoMac-1 on 20/03/19.
//  Copyright © 2019 TechnoMac-1. All rights reserved.
//

import UIKit

class ScanningCompletedVC: baseVC, isBarcodeValidate {
    func BarcodeIsWrong(flag: Bool) {
        self.flag = flag
        if flag {
            navigationController?.popViewController(animated: true)
        }
    }

    @IBOutlet var lbl_Scaning: UILabel!
    var code = String()
    var flag = false

    // MARK: - View Controller  Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        if code != "" {
            //  lbl_Scaning.text = code
        }

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_: Bool) {
        if flag {
            navigationController?.popViewController(animated: true)
        }
    }

    override func viewDidAppear(_: Bool) {
        if !flag {
            let vc = storyboard?.instantiateViewController(withIdentifier: "AddAccountVCViewController") as! AddAccountVCViewController
            vc.code = code
            vc.delegate = self
            navigationController?.pushViewController(vc, animated: true)
        }
    }

    override func viewDidDisappear(_: Bool) {
        code = ""
    }
}
