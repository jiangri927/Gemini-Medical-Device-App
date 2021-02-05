//
//  AwsConstants.swift
//  Gemini Medical Device App
//
//  Created by TechnoMac-1 on 10/04/19.
//  Copyright © 2019 TechnoMac-1. All rights reserved.
//

import AWSCore
import Foundation

/*
 The only thing you need to enter for this app to run are the 5 constants below,
 if it does not work make sure your policy document is correct for your identity pool
 and IoT 'thing'

 NOTE: It is mandatory for these to be set for this application to run
 */

// let CognitoIdentityPoolId = "yourRegion:________________"
// let IOT_ENDPOINT = "https://______.iot.yourRegion.amazonaws.com"
let AWSRegion = AWSRegionType.USWest2
let CognitoIdentityPoolId = "us-west-2:e6ae542d-99b7-4238-babf-69482224fabd"
let IOT_ENDPOINT = "http://a1f3ynjyzalf3r-ats.iot.us-west-2.amazonaws.com"
let PolicyName = "Gemini2MobileAppIotPolicy"
let CertificateSigningRequestCountryName = "USA"

// If using only for development purposes you can leave these as is
let CertificateSigningRequestCommonName = "Gemini 2 Mobile App"
let CertificateSigningRequestOrganizationName = "Azena Medical, LLC"
let CertificateSigningRequestOrganizationalUnitName = "Azena Team"
let ASWIoTDataManagerSTR = "MyIotDataManager"

// mqtt flag for connection status in ConnectViewController
var mqttStatus = "Disconnected"

var topic: String = userDefaults.string(forKey: "topic")!
//  var topic: String = "00001"
