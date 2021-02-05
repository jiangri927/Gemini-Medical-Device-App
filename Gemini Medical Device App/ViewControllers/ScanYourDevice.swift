//
//  ScanYourDevice.swift
//  Gemini Medical Device App
//
//  Created by TechnoMac-1 on 20/03/19.
//  Copyright © 2019 TechnoMac-1. All rights reserved.
//

import UIKit

class ScanYourDevice: baseVC {
    // MARK: - View Controller  Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func clk_Back(_: Any) {
        let vc = navigationController!.viewControllers[navigationController!.viewControllers.count - 2]
        let nav: UIViewController = storyboard?.instantiateViewController(withIdentifier: "CreateAccount") as! CreateAccount
        if vc.isKind(of: nav.classForCoder) {
            let Nvc = storyboard?.instantiateViewController(withIdentifier: "MainMenu") as! MainMenu
            navigationController?.pushViewController(Nvc, animated: true)
        } else {
            navigationController?.popViewController(animated: true)
            // commonClass.popViewControllerss(viewcontroller: self, popViews: 2, animated: true)
        }
    }

    @IBAction func clk_scanLasser(_: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "ScannerViewController") as! ScannerViewController
        navigationController?.pushViewController(vc, animated: true)
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
