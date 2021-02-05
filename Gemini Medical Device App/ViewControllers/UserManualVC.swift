//
//  UserManualVC.swift
//  Gemini Medical Device App
//
//  Created by TechnoMac-1 on 22/03/19.
//  Copyright © 2019 TechnoMac-1. All rights reserved.
//

import UIKit
import WebKit
class UserManualVC: baseVC, WKNavigationDelegate {
    @IBOutlet var webviewHolder: UIView!
    var wkWebView: WKWebView = {
        let v = WKWebView()

        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    // MARK: - Viewcontroller Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        wkWebView.navigationDelegate = self

        view.addSubview(wkWebView)
        // pin to all 4 edges
        webviewHolder.bringSubviewToFront(wkWebView)
        wkWebView.topAnchor.constraint(equalTo: webviewHolder.topAnchor, constant: 0.0).isActive = true
        wkWebView.bottomAnchor.constraint(equalTo: webviewHolder.bottomAnchor, constant: 0.0).isActive = true
        wkWebView.leadingAnchor.constraint(equalTo: webviewHolder.leadingAnchor, constant: 0.0).isActive = true
        wkWebView.trailingAnchor.constraint(equalTo: webviewHolder.trailingAnchor, constant: 0.0).isActive = true
        // Do any additional setup after loading the view.

        if let url = URL(string: "https://www.geminilaser.com/g2/manual/Gemini%202%20User%20Manual.pdf") {
            wkWebView.load(URLRequest(url: url))
        }
    }

    @IBAction func clk_back(_: Any) {
        navigationController?.popViewController(animated: true)
    }
}
