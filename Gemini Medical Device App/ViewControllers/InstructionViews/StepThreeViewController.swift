//
//  StepThreeViewController.swift
//  Gemini Medical Device App
//
//  Created by Ryan Stickel on 2/25/20.
//  Copyright © 2020 Azena Medical. All rights reserved.
//

import UIKit

class StepThreeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func nextStep(_: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "StepFourViewController") as! StepFourViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func back(_: Any) {
        self.navigationController?.popViewController(animated: true)
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
