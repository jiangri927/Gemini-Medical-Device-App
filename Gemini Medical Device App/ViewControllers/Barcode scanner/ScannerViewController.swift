//
//  ScannerViewController.swift
//  Gemini Medical Device App
//
//  Created by TechnoMac-1 on 23/03/19.
//  Copyright © 2019 TechnoMac-1. All rights reserved.
//

import AVFoundation
import UIKit

class ScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    // MARK: - Outlets

    @IBOutlet var view_CamTop: UIView!
    @IBOutlet var view_Top: UIView!
    @IBOutlet var view_CamBottom: UIView!

    @IBOutlet var imgScanBox: UIImageView!

    @IBOutlet var infolableHEADER: UILabel!

    // MARK: - Variables

    let systemSoundId: SystemSoundID = 1016
    var flag = false
    // captureSession manages capture activity and coordinates between input device and captures outputs
    var captureSession: AVCaptureSession?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?

    // Empty Rectangle with green border to outline detected QR or BarCode
    let codeFrame: UIView = {
        let codeFrame = UIView()
        codeFrame.layer.borderColor = UIColor.red.cgColor
        codeFrame.layer.borderWidth = 1.5
        codeFrame.frame = CGRect.zero
        codeFrame.translatesAutoresizingMaskIntoConstraints = false
        return codeFrame
    }()

    // MARK: - View controller life cycle

    override func viewDidDisappear(_: Bool) {
        captureSession?.stopRunning()
    }

    override func viewDidAppear(_: Bool) {
        captureSession?.startRunning()
    }

    override func viewWillAppear(_: Bool) {
        checkCameraPermission()
    }

    // MARK: - View Controller  Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        // AVCaptureDevice allows us to reference a physical capture device (video in our case)
        let captureDevice = AVCaptureDevice.default(for: AVMediaType.video)

        if let captureDevice = captureDevice {
            do {
                captureSession = AVCaptureSession()

                // CaptureSession needs an input to capture Data from
                let input = try AVCaptureDeviceInput(device: captureDevice)
                captureSession?.addInput(input)

                // CaptureSession needs and output to transfer Data to
                let captureMetadataOutput = AVCaptureMetadataOutput()
                captureSession?.addOutput(captureMetadataOutput)

                // We tell our Output the expected Meta-data type
                captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
                captureMetadataOutput.metadataObjectTypes = [.aztec] // AVMetadataObject.ObjectType

                captureSession?.startRunning()

                // The videoPreviewLayer displays video in conjunction with the captureSession
                videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
                videoPreviewLayer?.videoGravity = .resizeAspectFill
                videoPreviewLayer?.frame = view.layer.bounds
                view.layer.addSublayer(videoPreviewLayer!)
                view.bringSubviewToFront(infolableHEADER)
                view.bringSubviewToFront(view_Top)
                view.bringSubviewToFront(imgScanBox)
                view.bringSubviewToFront(view_CamTop)
                view.bringSubviewToFront(view_CamBottom)
            } catch {
                print("Error")
            }
        }
    }

    // MARK: - Button Actions

    @IBAction func clk_flash(_: Any) {
        if !flag {
            toggleTorch(on: true)
            flag = true
        } else {
            toggleTorch(on: false)
            flag = false
        }
    }

    @IBAction func clk_back(_: Any) {
        navigationController?.popViewController(animated: true)
    }

    func toggleTorch(on: Bool) {
        guard let device = AVCaptureDevice.default(for: .video) else { return }

        if device.hasTorch {
            do {
                try device.lockForConfiguration()

                if on == true {
                    device.torchMode = .on
                } else {
                    device.torchMode = .off
                }

                device.unlockForConfiguration()
            } catch {
                print("Torch could not be used")
            }
        } else {
            print("Torch is not available")
        }
    }

    // MARK: - custome methods

    // the metadataOutput function informs our delegate (the ScannerViewController) that the captureOutput emitted a new metaData Object
    func metadataOutput(_: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from _: AVCaptureConnection) {
        if metadataObjects.count == 0 {
            print("no objects returned")
            return
        }

        let metaDataObject = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        guard let StringCodeValue = metaDataObject.stringValue else {
            return
        }

        view.addSubview(codeFrame)

        // transformedMetaDataObject returns layer coordinates/height/width from visual properties
        guard let metaDataCoordinates = videoPreviewLayer?.transformedMetadataObject(for: metaDataObject) else {
            return
        }

        // Those coordinates are assigned to our codeFrame
        codeFrame.frame = metaDataCoordinates.bounds
        //  AudioServicesPlayAlertSound(systemSoundId)
        // infolableHEADER.text = StringCodeValue
        // ScanningCompletedVC

        let vc = storyboard?.instantiateViewController(withIdentifier: "ScanningCompletedVC") as! ScanningCompletedVC
        vc.code = StringCodeValue
        navigationController?.pushViewController(vc, animated: true)
        //        let vc = storyboard?.instantiateViewController(withIdentifier: "ScanedQRDetailsVC") as! ScanedQRDetailsVC
        //        vc.code = StringCodeValue
        //        navigationController?.pushViewController(vc, animated: true)

        print(StringCodeValue)
        captureSession?.stopRunning()
    }

    func checkCameraPermission() {
        if AVCaptureDevice.authorizationStatus(for: .video) == .authorized {
            // already authorized
        } else {
            AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted: Bool) in
                if granted {
                    // access allowed
                } else {
                    // access denied
                    self.permissionPrimeCameraAccess()
                }
            })
        }
    }

    func permissionPrimeCameraAccess() {
        let alert = UIAlertController(
            title: "IMPORTANT",
            message: "Camera access required for QR Scanning",
            preferredStyle: UIAlertController.Style.alert
        )
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Allow Camera", style: .cancel, handler: { (_) -> Void in
            UIApplication.shared.openURL(URL(string: UIApplication.openSettingsURLString)!)
        }))
        present(alert, animated: true, completion: nil)
    }
}
