//
//  SupportVC.swift
//  Gemini Medical Device App
//
//  Created by TechnoMac-1 on 22/03/19.
//  Copyright © 2019 TechnoMac-1. All rights reserved.
//

import UIKit

class SupportVC: baseVC {
    // MARK: - Viewcontroller Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func clk_call(_: Any) {
        if let url = URL(string: "tel://18888764546"), UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }

    /*
     // MARK: - Navigation

     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         // Get the new view controller using segue.destination.
         // Pass the selected object to the new view controller.
     }
     */
    @IBAction func clk_back(_: Any) {
        navigationController?.popViewController(animated: true)
    }
}