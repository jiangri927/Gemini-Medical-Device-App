//
//  Constant.swift
//  Gemini Medical Device App
//
//  Created by TechnoMac-1 on 25/03/19.
//  Copyright © 2019 TechnoMac-1. All rights reserved.
//

import Foundation
let AppName = "Gemini"
// let baseURL = ""
let baseURL = "https://geminilaser.com/g2/"
let userDefaults = UserDefaults.standard
let loggedInUserDictKey = "LoginDic"
var logginToken = "logginToken"
var loginObjId = "ObjId"
let loginUrl = "login.php"
let registerUrl = "register.php"
let paymenturl = "https://www.geminilaser.com/g2/braintree/process_card.php" // "http://192.168.0.164/all data/paypal_gateway/api/post.php"
let TokenURL = "https://www.geminilaser.com/g2/braintree/get_token.php"
var tokenUrlString = TokenURL.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
var urlString = paymenturl.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
