//
//  WiFiSearchListVC.swift
//  Gemini Medical Device App
//
//  Created by Ryan Stickel on 1/24/20.
//  Copyright © 2020 Azena Medical. All rights reserved.
//

import CoreBluetooth
import Foundation
import MBProgressHUD
import UIKit

protocol BLEStatusProtocol {
    func peripheralDisconnected()
}

class WiFiSearchListVC: UIViewController {
    @IBOutlet var tableView: UITableView!

    var provisionConfig: [String: String] = [:]
    var transport: Transport?
    var security: Security?
    var bleTransport: BLETransport?
    var peripherals: [CBPeripheral]?
    var delegate: BLEStatusProtocol?
    var activityView: UIActivityIndicatorView?
    var grayView: UIView?
    var provision: Provision!
    var ssidList: [String] = []
    var currentSsid: String?
    var wifiDetailList: [String: Espressif_WiFiScanResult] = [:]
    var versionInfo: String?
    var session: Session?
    var capabilities: [String]?
    var alertTextField: UITextField?
    var showPasswordImageView: UIImageView!
    var bleConnectTimer = Timer()
    var bleScanWifi = Timer()
    var bleDeviceConnected = false
    var processCount = 0
    @IBOutlet var headerView: UIView!
    
    // Provisioning
    private let pop = Bundle.main.infoDictionary?["ProofOfPossession"] as! String
    // WIFI
    private let baseUrl = Bundle.main.infoDictionary?["WifiBaseUrl"] as! String
    private let networkNamePrefix = Bundle.main.infoDictionary?["WifiNetworkNamePrefix"] as! String

    override func viewDidLoad() {
        super.viewDidLoad()
        // navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)

        // Do any additional setup after loading the view, typically from a nib.
        showPasswordImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        let tap = UITapGestureRecognizer(target: self, action: #selector(showPassword))
        tap.numberOfTapsRequired = 1
        showPasswordImageView.isUserInteractionEnabled = true
        showPasswordImageView.addGestureRecognizer(tap)

        /* if let bleTransport = transport as? BLETransport {
             print("Inside PVC", bleTransport.currentPeripheral!)
         } */

        tableView.tableFooterView = UIView()

        // navigationItem.backBarButtonItem?.title = ""
        // navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Info", style: .plain, target: self, action: #selector(showDeviceVersion))
        
        self.startBLEScan()
    }
    
    @objc private func startBLEScan() {
        
        let transportConfig = Provision.CONFIG_TRANSPORT_BLE
        let security = Provision.CONFIG_SECURITY_SECURITY1

        let config = [
            Provision.CONFIG_TRANSPORT_KEY: transportConfig,
            Provision.CONFIG_SECURITY_KEY: security,
            Provision.CONFIG_PROOF_OF_POSSESSION_KEY: pop,
            Provision.CONFIG_BASE_URL_KEY: baseUrl,
            Provision.CONFIG_WIFI_AP_KEY: networkNamePrefix,
        ]
        
        provisionConfig = config

        // Scan for bluetooth devices
        bleTransport = BLETransport(scanTimeout: 5.0)
        bleTransport?.scan(delegate: self)
        showBusySearching(isBusy: true, message: "Searching")
        //startWifiScan()
        bleScanWifi.invalidate()
        bleScanWifi = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(startWifiScan), userInfo: nil, repeats: true)
        
    }

    @objc private func startWifiScan() {
        if bleDeviceConnected {
            bleScanWifi.invalidate()
            if transport == nil {
                transport = SoftAPTransport(baseUrl: Utility.baseUrl)
            }
            getDeviceVersionInfo()
        }
    }

    private func showBusySearching(isBusy: Bool, message: String = "") {
        DispatchQueue.main.async {
            if isBusy {
                let loader = MBProgressHUD.showAdded(to: self.view, animated: true)
                loader.mode = MBProgressHUDMode.indeterminate
                loader.label.text = message
            } else {
                MBProgressHUD.hide(for: self.view, animated: true)
            }
        }
    }

    private func showBusy(isBusy: Bool) {
        if isBusy {
            grayView = UIView(frame: UIScreen.main.bounds)
            grayView?.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
            view.addSubview(grayView!)

            activityView = UIActivityIndicatorView(style: .gray)
            activityView?.center = view.center
            activityView?.startAnimating()

            view.addSubview(activityView!)
        } else {
            grayView?.removeFromSuperview()
            activityView?.removeFromSuperview()
        }
    }

    private func connectPeripheral() {
        //let deviceUID = userDefaults.string(forKey: "deviceUID")
        let serialID = userDefaults.string( forKey: "topic") ?? "nil"
        //let serialID = "00013"
        //showBusySearching(isBusy: false)
        //bleTransport?.connect(peripheral: peripherals![0], withOptions: nil)
        
        var peripheralFound = false
        for peripheral in self.peripherals! {

            let name = peripheral.name ?? "nil"

            print("peripheral \(name)")
            print("peripheral \(serialID)")
            
            if ((name.contains(String(describing: serialID)))) {
                peripheralFound = true
                bleTransport?.connect(peripheral: peripheral, withOptions: nil)
            }
         }
        
        if !peripheralFound {
            MBProgressHUD.hide(for: self.view, animated: true)
            let alert = UIAlertController(title: "Configuring Device", message: "Did not find scanned device.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                self.returnToSearch()
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }

    @IBAction func rescanWiFiList(_: Any) {
        if (bleDeviceConnected) {
            scanDeviceForWiFiList()
        }
    }

    private func provisionDevice(ssid: String, passphrase: String) {
        showLoader(message: "Device connecting to Wi-Fi")

        let baseUrl = provisionConfig[Provision.CONFIG_BASE_URL_KEY]
        let transportVersion = provisionConfig[Provision.CONFIG_TRANSPORT_KEY]
        if transport != nil {
            // transport is BLETransport set from BLELandingVC
            if let bleTransport = transport as? BLETransport {
                bleTransport.delegate = self
            }

            initialiseSessionAndConfigure(ssid: ssid, passPhrase: passphrase)
        } else if transportVersion == Provision.CONFIG_TRANSPORT_WIFI {
            transport = SoftAPTransport(baseUrl: baseUrl!)
            initialiseSessionAndConfigure(ssid: ssid, passPhrase: passphrase)
        } else if transport == nil {
            bleTransport = BLETransport(scanTimeout: 2.0)
            bleTransport?.scan(delegate: self)
            transport = bleTransport
        }
    }

    private func initialiseSession() {
        let securityVersion = provisionConfig[Provision.CONFIG_SECURITY_KEY]

        if securityVersion == Provision.CONFIG_SECURITY_SECURITY1 {
            if let capability = capabilities, capability.contains(Constants.noProofCapability) {
                provisionConfig[Provision.CONFIG_PROOF_OF_POSSESSION_KEY] = ""
                security = Security1(proofOfPossession: provisionConfig[Provision.CONFIG_PROOF_OF_POSSESSION_KEY]!)
                initSession()
            } else {
                /*let input = UIAlertController(title: "Proof of Possession", message: nil, preferredStyle: .alert)

                input.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: { _ in
                    self.transport?.disconnect()
                    self.navigationController?.popViewController(animated: true)
                }))
                input.addAction(UIAlertAction(title: "Done", style: .default, handler: { [weak input] _ in
                    let textField = input?.textFields![0]
                    self.provisionConfig[Provision.CONFIG_PROOF_OF_POSSESSION_KEY] = textField?.text ?? ""
                    self.security = Security1(proofOfPossession: self.provisionConfig[Provision.CONFIG_PROOF_OF_POSSESSION_KEY]!)
                    self.initSession()
                }))
                DispatchQueue.main.async {
                    input.addTextField { textField in
                        textField.text = "abcd1234"
                    }
                    self.present(input, animated: true, completion: nil)
                }*/
                self.provisionConfig[Provision.CONFIG_PROOF_OF_POSSESSION_KEY] = "abcd1234"
                self.security = Security1(proofOfPossession: self.provisionConfig[Provision.CONFIG_PROOF_OF_POSSESSION_KEY]!)
                self.initSession()
            }
        } else {
            security = Security0()
            initSession()
        }
    }

    func initSession() {
        session = Session(transport: transport!,
                          security: security!)
        session!.initialize(response: nil) { error in
            DispatchQueue.main.async {
                MBProgressHUD.hide(for: self.view, animated: true)
            }
            guard error == nil else {
                print("Error in establishing session \(error.debugDescription)")
                self.showStatusScreen()
                return
            }
            if let capability = self.capabilities, capability.contains(Constants.wifiScanCapability) {
                self.scanDeviceForWiFiList()
            } else {
                self.showTextFieldUI()
            }
        }
    }

    func scanDeviceForWiFiList() {
        if session!.isEstablished {
            DispatchQueue.main.async {
                self.showLoader(message: "Scanning for Wi-Fi")
                let scanWifiManager: ScanWifiList = ScanWifiList(session: self.session!)
                scanWifiManager.delegate = self
                scanWifiManager.startWifiScan()
            }
        }
    }

    func initialiseSessionAndConfigure(ssid: String, passPhrase: String) {
        if transport!.isDeviceConfigured() {
            if session!.isEstablished {
                let provision = Provision(session: session!)

                provision.configureWifi(ssid: ssid,
                                        passphrase: passPhrase) { status, error in
                    guard error == nil else {
                        print("Error in configuring wifi : \(error.debugDescription)")
                        return
                    }
                    if status == Espressif_Status.success {
                        self.applyConfigurations(provision: provision)
                    }
                }
            } else {
                print("Session is not established")
            }
        } else {
            showError(errorMessage: "Peripheral device could not be configured.")
        }
    }

    func getDeviceVersionInfo() {
        showBusySearching(isBusy: false)
        showLoader(message: "Connecting Device")
        transport?.SendConfigData(path: (transport?.utility.versionPath)!, data: Data("ESP".utf8), completionHandler: { response, error in
            guard error == nil else {
                print("Error reading device version info")
                DispatchQueue.main.async {
                    MBProgressHUD.hide(for: self.view, animated: true)
                }
                self.showConnectionFailure()
                return
            }
            do {
                if let result = try JSONSerialization.jsonObject(with: response!, options: .mutableContainers) as? NSDictionary {
                    self.transport?.utility.deviceVersionInfo = result
                    if let prov = result[Constants.provKey] as? NSDictionary, let capabilities = prov[Constants.capabilitiesKey] as? [String] {
                        self.capabilities = capabilities
                        self.initialiseSession()
                    }
                }
            } catch {
                self.initialiseSession()
                print(error)
            }
        })
    }

    /*@objc func showDeviceVersion() {
         let deviceVersionVC = storyboard?.instantiateViewController(withIdentifier: Constants.deviceInfoStoryboardID) as! DeviceInfoViewController
         deviceVersionVC.utility = transport!.utility
         navigationController?.pushViewController(deviceVersionVC, animated: true)
     }*/

    private func applyConfigurations(provision: Provision) {
        provision.applyConfigurations(completionHandler: { status, error in
            guard error == nil else {
                self.showError(errorMessage: "Error in applying configurations : \(error.debugDescription)")
                return
            }
            print("Configurations applied ! \(status)")
            /*DispatchQueue.main.async {
                MBProgressHUD.hide(for: self.view, animated: true)
                self.startBLEScan()
            }*/
        },
        wifiStatusUpdatedHandler: { wifiState, failReason, error in
            DispatchQueue.main.async {
                self.showBusy(isBusy: false)
                MBProgressHUD.hide(for: self.view, animated: true)

                var retry = false
                var title = "Configuring Device"
                var message = "Your Gemini has been successfully connected"
                if error != nil {
                    message = "Error in getting wifi state : \(error.debugDescription)"
                } else if wifiState == Espressif_WifiStationState.connected {
                    title = "Congratulations!"
                    message = "Your Gemini has been successfully connected"
                } else if wifiState == Espressif_WifiStationState.disconnected {
                    message = "Please check the device indicators for connection status."
                } else {
                    if failReason == Espressif_WifiConnectFailedReason.authError {
                        message = "Device connection failed.\nReason : Wifi password incorrect.\nPlease type the correct Wifi password for \(self.currentSsid ?? "the Selected") network"
                        retry = true
                    } else if failReason == Espressif_WifiConnectFailedReason.networkNotFound {
                        message = "Device connection failed.\nReason : Network not found.\nPlease reset device to factory settings and retry."
                    } else {
                        message = "Device connection failed.\nReason : \(failReason).\nPlease reset device to factory settings and retry."
                    }
                }

                if (!retry) {
                    MBProgressHUD.hide(for: self.view, animated: true)
                    let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                        self.backNavigation()
                    }))
                    self.present(alert, animated: true, completion: nil)
                } else {
                    MBProgressHUD.hide(for: self.view, animated: true)
                    let alert = UIAlertController(title: "Configuring Device", message: message, preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                        //self.backNavigation()
                        
                        //self.presentEnterPasscode(ssid: self.currentSsid!)
                        
                        self.bleTransport?.disconnect()
                        self.bleDeviceConnected = false
                        self.peripherals?.removeAll()
                        self.startBLEScan()
                        //self.connectPeripheral()
                    }))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        })
    }
    
    /*@IBAction func backNavigation() {
        let MainMenu: UIViewController = storyboard?.instantiateViewController(withIdentifier: "MainMenu") as! MainMenu
        for controller in navigationController!.viewControllers as Array {
            if controller.isKind(of: MainMenu.classForCoder) {
                self.navigationController!.popToViewController(controller, animated: true)
                break
            }
        }
    }*/
    
    @IBAction func returnToSearch() {
        self.bleTransport?.disconnect()
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func backNavigation() {
        
        let MainMenu: UIViewController = storyboard?.instantiateViewController(withIdentifier: "MainMenu") as! MainMenu
        
        NSLog("nav count: %d", navigationController!.viewControllers.count)
        if navigationController!.viewControllers.count > 12 {
            let vc = navigationController!.viewControllers[navigationController!.viewControllers.count - 11]
            let nav: UIViewController = storyboard?.instantiateViewController(withIdentifier: "TermsAndCondtitionsVCViewController") as! TermsAndCondtitionsVCViewController

            if vc.isKind(of: nav.classForCoder) {
                let Nvc = storyboard?.instantiateViewController(withIdentifier: "MainMenu") as! MainMenu
                Nvc.isFirstLoad = true
                navigationController?.pushViewController(Nvc, animated: true)
            } else {
                for controller in navigationController!.viewControllers as Array {
                    if controller.isKind(of: MainMenu.classForCoder) {
                        let menuVC = controller as! MainMenu
                        menuVC.isFirstLoad = true
                        self.navigationController!.popToViewController(menuVC, animated: true)
                        break
                    }
                }
            }

        } else {
            for controller in navigationController!.viewControllers as Array {
                if controller.isKind(of: MainMenu.classForCoder) {
                    let menuVC = controller as! MainMenu
                    menuVC.isFirstLoad = true
                    self.navigationController!.popToViewController(menuVC, animated: true)
                    break
                }
            }
        }
    }

    func showError(errorMessage: String) {
        MBProgressHUD.hide(for: self.view, animated: true)
        let alertMessage = errorMessage
        let alertController = UIAlertController(title: "Configuring Device", message: alertMessage, preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }

    func showLoader(message: String) {
        DispatchQueue.main.async {
            let loader = MBProgressHUD.showAdded(to: self.view, animated: true)
            loader.mode = MBProgressHUDMode.indeterminate
            loader.label.text = message
            loader.backgroundView.blurEffectStyle = .dark
            loader.bezelView.backgroundColor = UIColor.white
        }
    }

    func setWifiIconImageFor(cell: WifiListTableViewCell, ssid: String) {
        let rssi = wifiDetailList[ssid]?.rssi ?? -70
        if rssi > Int32(-50) {
            cell.signalImageView.image = UIImage(named: "wifi_symbol_strong")
        } else if rssi > Int32(-60) {
            cell.signalImageView?.image = UIImage(named: "wifi_symbol_good")
        } else if rssi > Int32(-67) {
            cell.signalImageView?.image = UIImage(named: "wifi_symbol_fair")
        } else {
            cell.signalImageView?.image = UIImage(named: "wifi_symbol_weak")
        }
        if wifiDetailList[ssid]?.auth != Espressif_WifiAuthMode.open {
            cell.authenticationImageView.image = UIImage(named: "wifi_security")
            cell.authenticationImageView.isHidden = false
        } else {
            cell.authenticationImageView.isHidden = true
        }
    }

    func showTextFieldUI() {
        DispatchQueue.main.async {
            //self.tableView.isHidden = true
            //self.headerView.isHidden = true
        }
    }

    private func joinOtherNetwork() {
        let input = UIAlertController(title: "", message: nil, preferredStyle: .alert)

        input.addTextField { textField in
            textField.placeholder = "Network Name"
            self.addHeightConstraint(textField: textField)
        }

        input.addTextField { textField in
            self.configurePasswordTextfield(textField: textField)
            self.addHeightConstraint(textField: textField)
        }
        input.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: { _ in
        }))
        input.addAction(UIAlertAction(title: "Connect", style: .default, handler: { [weak input] _ in
            let ssidTextField = input?.textFields![0]
            let passphrase = input?.textFields![1]

            if let ssid = ssidTextField?.text, ssid.count > 0 {
                self.provisionDevice(ssid: ssid, passphrase: passphrase?.text ?? "")
            }
        }))
        DispatchQueue.main.async {
            self.present(input, animated: true, completion: nil)
        }
    }

    func showStatusScreen() {
        DispatchQueue.main.async {
            /* let successVC = self.storyboard?.instantiateViewController(withIdentifier: "successViewController") as! SuccessViewController
             successVC.statusText = "Error establishing session.\n Check if Proof of Possession(POP) is correct!"
             self.navigationController?.present(successVC, animated: true, completion: nil) */
            MBProgressHUD.hide(for: self.view, animated: true)
            let alertController = UIAlertController(title: "Problem Connecting Device", message: "Error establishing session.\n Check if Proof of Possession(POP) is correct!", preferredStyle: UIAlertController.Style.alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }
    }

    @objc func showPassword() {
        if let secureEntry = alertTextField?.isSecureTextEntry {
            alertTextField?.togglePasswordVisibility()
            if secureEntry {
                showPasswordImageView.image = UIImage(named: "hide_password")
            } else {
                showPasswordImageView.image = UIImage(named: "show_password")
            }
        }
    }

    private func addHeightConstraint(textField: UITextField) {
        let heightConstraint = NSLayoutConstraint(item: textField, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 30)
        textField.addConstraint(heightConstraint)
        textField.font = UIFont.systemFont(ofSize: 18.0)
    }

    private func configurePasswordTextfield(textField: UITextField) {
        alertTextField = textField
        textField.placeholder = "Password"
        textField.isSecureTextEntry = true
        showPasswordImageView.image = UIImage(named: "show_password")
        textField.rightView = showPasswordImageView
        textField.rightViewMode = .always
    }

    private func configurePassphraseTextField() {
        // alertTextField = passphraseTextfield
        // passphraseTextfield.placeholder = "Password"
        // passphraseTextfield.isSecureTextEntry = true
        showPasswordImageView.image = UIImage(named: "show_password")
        let rightView = UIView(frame: CGRect(x: 0, y: 0, width: showPasswordImageView.frame.width + 10, height: showPasswordImageView.frame.height))
        rightView.addSubview(showPasswordImageView)
        // passphraseTextfield.rightView = rightView
        // passphraseTextfield.rightViewMode = .always
    }

    private func showConnectionFailure() {
        DispatchQueue.main.async {
            MBProgressHUD.hide(for: self.view, animated: true)
            let alert = UIAlertController(title: "Failure", message: "Connection to device failed.\n Please make sure you are connected to the Wi-Fi network of device.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .destructive, handler: { _ in
                self.navigationController?.popViewController(animated: true)
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }

    @objc func bleConnectionTimeout() {
        if !bleDeviceConnected {
            bleTransport?.disconnect()
            bleConnectTimer.invalidate()
            bleDeviceNotConfigured(title: "Error!", message: "Communication failed. Device may not be supported. ")
        }
    }

    func bleDeviceConfigured() {
        showBusy(isBusy: false)
        transport = bleTransport
    }

    func bleDeviceNotConfigured(title: String, message: String) {
        bleDeviceConnected = true
        showBusy(isBusy: false)
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
}

extension WiFiSearchListVC: BLETransportDelegate {
    func peripheralsFound(peripherals: [CBPeripheral]) {
        //showBusySearching(isBusy: false)
        self.peripherals = peripherals
        connectPeripheral()
        // bleTransport?.connect(peripheral: peripherals[0], withOptions: nil)
        // getDeviceVersionInfo()

        //bleTransport?.connect(peripheral: peripherals[0], withOptions: nil)
        // bleDeviceConnected = false
        // bleConnectTimer.invalidate()
        // bleConnectTimer = Timer.scheduledTimer(timeInterval: 20, target: self, selector: #selector(bleConnectionTimeout), userInfo: nil, repeats: false)
    }

    func peripheralsNotFound(serviceUUID _: UUID?) {
        //showError(errorMessage: "No devices found!")
        MBProgressHUD.hide(for: self.view, animated: true)
        let alert = UIAlertController(title: "No devices found!", message: "Please make sure your Gemini unit is ON and the Wifi button is pressed for 5 seconds to enable device registration.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { _ in
            self.returnToSearch()
        }))
        self.present(alert, animated: true, completion: nil)
    }

    func peripheralConfigured(peripheral _: CBPeripheral) {
        bleDeviceConnected = true
        bleDeviceConfigured()
    }

    func peripheralNotConfigured(peripheral _: CBPeripheral) {
        showError(errorMessage: "Device could not be configured.")
    }

    func peripheralDisconnected(peripheral: CBPeripheral, error _: Error?) {
        MBProgressHUD.hide(for: self.view, animated: true)
        //showError(errorMessage: "Peripheral device disconnected")
        self.bleDeviceConnected = false
        if delegate == nil {
            //bleTransport?.connect(peripheral: peripheral, withOptions: nil)
            //getDeviceVersionInfo()
        } else {
            delegate?.peripheralDisconnected()
        }
    }

    func bluetoothUnavailable() {}
}

extension WiFiSearchListVC: ScanWifiListProtocol {
    func wifiScanFinished(wifiList: [String: Espressif_WiFiScanResult]?, error: Error?) {
        if wifiList?.count != 0, wifiList != nil {
            
            /*for wifi in wifiList {
                
                
                
            }*/
            
            wifiDetailList = wifiList!
            ssidList = Array(wifiList!.keys)
            DispatchQueue.main.async {
                self.tableView.isHidden = false
                // self.ssidTextfield.isHidden = true
                // self.passphraseTextfield.isHidden = true
                //self.headerView.isHidden = false
                self.tableView.reloadData()
            }
            
        } else {
            showTextFieldUI()
            if error != nil {
                print("Unable to fetch wifi list :\(String(describing: error))")
            }
            
            var message = ""
            
            if self.processCount == 0 {
                message = "Oops, we encountered an issue connecting, let's try again!"
            } else if self.processCount == 1 {
                message = "We encountered a connection issue that will require technical support. But don’t worry we are always available and will be able to talk to you. Please call 1-888-230-1420"
            } else {
                message = "We encountered a connection issue that will require technical support. But don’t worry we are always available and will be able to talk to you. Please call 1-888-230-1420"
            }
            
            DispatchQueue.main.async {
                MBProgressHUD.hide(for: self.view, animated: true)
                let alert = UIAlertController(title: "Wifi Scan Failed", message: message, preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                    if self.processCount == 0 {
                        self.processCount = 1
                        self.bleTransport?.disconnect()
                        self.bleDeviceConnected = false
                        self.peripherals?.removeAll()
                        self.startBLEScan()
                    } else if self.processCount == 1 {
                        self.returnToSearch()
                    } else {
                        self.returnToSearch()
                    }
                }))
                self.present(alert, animated: true, completion: nil)

            }
        }
        DispatchQueue.main.async {
            MBProgressHUD.hide(for: self.view, animated: true)
        }
    }
}

extension WiFiSearchListVC: UITableViewDelegate {
    func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row >= ssidList.count {
            //joinOtherNetwork()
        } else {
            let ssid = ssidList[indexPath.row]

            self.presentEnterPasscode(ssid: ssid)
        }
    }

    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        return 60.0
    }
    
    func presentEnterPasscode(ssid: String) {
        
        if wifiDetailList[ssid]?.auth != Espressif_WifiAuthMode.open {
            
            self.currentSsid = ssid
            let messsage = "Please enter the password for \(ssid)"
            let input = UIAlertController(title: ssid, message: messsage, preferredStyle: .alert)

            input.addTextField { textField in
                self.configurePasswordTextfield(textField: textField)
                self.addHeightConstraint(textField: textField)
            }
            input.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: { _ in
                MBProgressHUD.hide(for: self.view, animated: true)
            }))
            input.addAction(UIAlertAction(title: "Connect", style: .default, handler: { [weak input] _ in
                MBProgressHUD.hide(for: self.view, animated: true)
                let textField = input?.textFields![0]
                guard let passphrase = textField?.text else {
                    return
                }
                if passphrase.count > 0 {
                    self.provisionDevice(ssid: ssid, passphrase: passphrase)
                }
            }))
            let loader = MBProgressHUD.showAdded(to: self.view, animated: true)
            loader.mode = MBProgressHUDMode.indeterminate
            loader.label.text = "Enter Password"
            present(input, animated: true, completion: nil)
        } else {
            provisionDevice(ssid: ssid, passphrase: "")
        }
        
    }
}

extension WiFiSearchListVC: UITableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return ssidList.count + 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "wifiListCell", for: indexPath) as! WifiListTableViewCell
        tableView.backgroundColor = UIColor.black
        cell.backgroundColor = cell.contentView.backgroundColor;
        
        if indexPath.row >= ssidList.count {
            cell.ssidLabel.text = ""
            cell.signalImageView.image = nil
        } else {
            cell.ssidLabel.text = ssidList[indexPath.row]
            setWifiIconImageFor(cell: cell, ssid: ssidList[indexPath.row])
        }
        return cell
    }
}

extension WiFiSearchListVC: BLEStatusProtocol {
    func peripheralDisconnected() {
        MBProgressHUD.hide(for: view, animated: true)
        if !(session?.isEstablished ?? false) {
            showStatusScreen()
        }
    }
}

extension UITextField {
    func togglePasswordVisibility() {
        isSecureTextEntry = !isSecureTextEntry

        if let existingText = text, isSecureTextEntry {
            /* When toggling to secure text, all text will be purged if the user
             continues typing unless we intervene. This is prevented by first
             deleting the existing text and then recovering the original text. */
            deleteBackward()

            if let textRange = textRange(from: beginningOfDocument, to: endOfDocument) {
                replace(textRange, withText: existingText)
            }
        }

        /* Reset the selected text range since the cursor can end up in the wrong
         position after a toggle because the text might vary in width */
        if let existingSelectedTextRange = selectedTextRange {
            selectedTextRange = nil
            selectedTextRange = existingSelectedTextRange
        }
    }
}
