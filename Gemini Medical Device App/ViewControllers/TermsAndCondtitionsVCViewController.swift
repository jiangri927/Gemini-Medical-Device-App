//
//  TermsAndCondtitionsVCViewController.swift
//  Gemini Medical Device App
//
//  Created by TechnoMac-1 on 14/06/19.
//  Copyright © 2019 TechnoMac-1. All rights reserved.
//

import UIKit

class TermsAndCondtitionsVCViewController: baseVC {
    // MARK: - Outlets

    @IBOutlet var btn_Continue: UIButton!
    @IBOutlet var btnAgree: UISwitch!

    // MARK: - Viewcontroller Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        btn_Continue.alpha = 0.30
        btn_Continue.isEnabled = false
        // Do any additional setup after loading the view.
    }

    @IBAction func clk_continue(_: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "ScanYourDevice") as! ScanYourDevice
        navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction func btn_Agree(_: Any) {
        if btnAgree.isOn {
            btn_Continue.alpha = 1
            btn_Continue.isEnabled = true
        } else {
            btn_Continue.alpha = 0.30
            btn_Continue.isEnabled = false
        }
    }

    @IBAction func clk_Back(_: Any) {
        navigationController?.popViewController(animated: true)
    }
}
