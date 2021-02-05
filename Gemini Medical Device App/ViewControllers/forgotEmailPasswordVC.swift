//
//  forgotEmailPasswordVC.swift
//  Gemini Medical Device App
//
//  Created by TechnoMac-1 on 13/06/19.
//  Copyright © 2019 TechnoMac-1. All rights reserved.
//

import UIKit

class forgotEmailPasswordVC: baseVC {
    var emailA = String()

    // MARK: - outlets

    @IBOutlet var lbl: UILabel!

    // MARK: - Viewcontroller Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        lbl.text = "An email to \(emailA) has been sent."
        // Do any additional setup after loading the view.
    }

    @IBAction func clk_Back(_: Any) {
        navigationController?.popViewController(animated: true)
    }

    @IBAction func clk_returnToLogin(_: Any) {
        navigationController?.popToRootViewController(animated: true)
    }

    /*
     // MARK: - Navigation

     // In a storyboard-based application, you will often want to do a little preparation before navigation
       override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         // Get the new view controller using segue.destination.
         // Pass the selected object to the new view controller.
     }
     */
}
