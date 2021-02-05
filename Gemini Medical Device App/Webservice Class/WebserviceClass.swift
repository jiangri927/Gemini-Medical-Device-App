//
//  WebserviceClass.swift
//  Gemini Medical Device App
//
//  Created by TechnoMac-1 on 25/03/19.
//  Copyright © 2019 TechnoMac-1. All rights reserved.
//

import Foundation
import UIKit
// import MBProgressHUD
// import SVProgressHUD

let urlBase = "https://geminilaser.com/g2/"
// let classURL = "http://192.168.0.160/api_proximity/"//urlRecipeAPi
// let delegate = UIApplication.shared.delegate as! AppDelegate
var count = 0
var timer: Timer?
var window: UIWindow?
// var navController: UINavigationController?

// var verifyObj = VerifyCode.init()

class WebServiceClass: NSObject {
    static let shared = WebServiceClass()
    var isShow = false
    var objappDelegate = UIApplication.shared.delegate as! AppDelegate
    //   var hud = MBProgressHUD()
    func webService(webService: WebServiceClass) -> WebServiceClass {
        return webService
    }

    // MARK: - get method

    func jsonCallGET(classURL: NSString, completionHandler: @escaping (_ result: Any?, _ error: Error?) -> Swift.Void) {
        AddProgressHud()
        let urlString = "\(urlBase)\(classURL)"
        var request = URLRequest(url: URL(string: urlString)!)
        let session = URLSession.shared
        request.httpMethod = "GET"
        session.dataTask(with: request) { data, _, error in
            if error != nil {
                print(error!.localizedDescription)
                return
            }
            do {
                let jsonResult: NSDictionary? = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary
                print("Synchronous\(String(describing: jsonResult))")

                if jsonResult?.value(forKey: "status") as! NSInteger == 0 {
                    self.HideProgressHud()
                    completionHandler(jsonResult?.object(forKey: "data"), error)
                } else {
                    self.HideProgressHud()
                    completionHandler(nil, error)
                }
            } catch {
                self.HideProgressHud()
                print(error.localizedDescription)
            }

        }.resume()
    }

    // MARK: - POST method

    func jsonCallwithData(dicData: Any, ClassUrl: String, completionHandler: @escaping (NSMutableDictionary?, Error?) -> Swift.Void) { if Reachabilities.isConnectedToNetwork() == true {
        AddProgressHud()

        let url = URL(string: urlBase + ClassUrl)!
        let session = URLSession.shared
        var request: URLRequest = URLRequest(url: url)
        print("url:-", url, "\n Request query is : ", dicData)
        request.httpMethod = "POST"
        request.setValue("multipart/form-data; boundary=\(UUID().uuidString)", forHTTPHeaderField: "Content-Type")
        request.timeoutInterval = 20

        print("dict data \(dicData)")
        print("json data \(JSON(dicData))")
//        if UserDefaults.standard.value(forKey:userdefaultAuthHeader) != nil
//        {
//            //loginstring
//            let BaseLoginString = UserDefaults.standard.value(forKey: userdefaultAuthHeader) as! String
//            request.setValue("\(BaseLoginString)", forHTTPHeaderField: "Authorization")
//        }
        var bodyData: Data

        do {
            bodyData = try JSONSerialization.data(withJSONObject: dicData, options: JSONSerialization.WritingOptions(rawValue: 0)) as Data

            request.httpBody = bodyData
        } catch {
            print(error)
        }

        let task = session.dataTask(with: request) { data, response, error in

            if error != nil {
                print(error!.localizedDescription)
                self.HideProgressHud()
                self.showFailureMessage(error: error! as NSError)
                return
            }
            do {
                print("res \(String(describing: response))")
                let jsonResult: NSDictionary? = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary

                // let msg = jsonResult?.value(forKey: APIMessageParam) as! String
                print("Synchronous\(String(describing: jsonResult))")

                DispatchQueue.main.async {
                    //  self.hud.hide(animated: true)
                    self.HideProgressHud()
                }
                completionHandler(jsonResult?.mutableCopy() as? NSMutableDictionary, error)
                //                if(jsonResult?.value(forKey: "code") as! NSInteger == 200)
                //                {
                //                   self.HideProgressHud()
                //
                //                    DispatchQueue.main.async {
                //
                //                        if self.isShow {
                //                            CommonClass.showAlert((delegate.window?.rootViewController)!, message:((jsonResult?.value(forKey: "message") as! NSString) as String), butonTitle: "ok")
                //                        }
                //                    }
                //                 //   completionHandler(jsonResult?.mutableCopy() as? NSMutableDictionary,error)
                //                }
                //       else
                //                {
                //
                //
                //
                /// /                    let alertController = UIAlertController(title: appName, message: (jsonResult?.value(forKey: "message") as! NSString) as String, preferredStyle: .alert)
                /// /                    let OKAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default)
                /// /                    {
                /// /                        (action: UIAlertAction) in
                /// /                        print("You have pressed ok button")
                /// /                    }
                /// /                    alertController.addAction(OKAction)
                /// /
                //                    self.HideProgressHud()
                /// /                    DispatchQueue.main.async
                /// /                        {
                /// /                            let window = UIApplication.shared.keyWindow;
                /// /                            var vc = window?.rootViewController
                /// /                            while (vc?.presentedViewController != nil)
                /// /                            {
                /// /                                vc = vc?.presentedViewController;
                /// /                            }
                /// /                            DispatchQueue.main.async {
                /// /                                vc?.present(alertController , animated: true, completion: nil)
                /// /                            }
                /// /                    }
                /// /
                //                }
            } catch {
                self.HideProgressHud()
                print(error.localizedDescription)
            }
        }
        task.resume()

    } else {
//        CommonClass.showCustomeAlert(UIViewController(), messageA: "Device is not connected to the internet", butonTitle: "red")
    }
    }

    // MARK: - Special function for service call json get

    func jsonCallwithDataServiceCall(dicData: Any, ClassUrl: String, completionHandler: @escaping (NSMutableDictionary?, Error?) -> Swift.Void) { if Reachabilities.isConnectedToNetwork() == true {
        AddProgressHud()

        let url = URL(string: urlBase + ClassUrl)!
        let session = URLSession.shared
        var request: URLRequest = URLRequest(url: url)
        print("url:-", url, "\n Request query is : ", dicData)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.timeoutInterval = 20

        print("dict data \(dicData)")
        print("json data \(JSON(dicData))")

        var bodyData: Data

        do {
            bodyData = try JSONSerialization.data(withJSONObject: dicData, options: JSONSerialization.WritingOptions(rawValue: 0)) as Data

            request.httpBody = bodyData
        } catch {
            print(error)
        }

        let task = session.dataTask(with: request) { data, response, error in

            if error != nil {
                print(error!.localizedDescription)

                self.showFailureMessage(error: error! as NSError)
                return
            }
            do {
                print("res \(String(describing: response))")
                let jsonResult: NSDictionary? = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary

                // let msg = jsonResult?.value(forKey: APIMessageParam) as! String
                print("Synchronous\(String(describing: jsonResult))")

                DispatchQueue.main.async {
                    //  self.hud.hide(animated: true)
                    //  self.HideProgressHud()
                }
                completionHandler(jsonResult?.mutableCopy() as? NSMutableDictionary, error)
                //                if(jsonResult?.value(forKey: "code") as! NSInteger == 200)
                //                {
                //                   self.HideProgressHud()
                //
                //                    DispatchQueue.main.async {
                //
                //                        if self.isShow {
                //                            CommonClass.showAlert((delegate.window?.rootViewController)!, message:((jsonResult?.value(forKey: "message") as! NSString) as String), butonTitle: "ok")
                //                        }
                //                    }
                //                 //   completionHandler(jsonResult?.mutableCopy() as? NSMutableDictionary,error)
                //                }
                //       else
                //                {
                //
                //
                //
                /// /                    let alertController = UIAlertController(title: appName, message: (jsonResult?.value(forKey: "message") as! NSString) as String, preferredStyle: .alert)
                /// /                    let OKAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default)
                /// /                    {
                /// /                        (action: UIAlertAction) in
                /// /                        print("You have pressed ok button")
                /// /                    }
                /// /                    alertController.addAction(OKAction)
                /// /
                //                    self.HideProgressHud()
                /// /                    DispatchQueue.main.async
                /// /                        {
                /// /                            let window = UIApplication.shared.keyWindow;
                /// /                            var vc = window?.rootViewController
                /// /                            while (vc?.presentedViewController != nil)
                /// /                            {
                /// /                                vc = vc?.presentedViewController;
                /// /                            }
                /// /                            DispatchQueue.main.async {
                /// /                                vc?.present(alertController , animated: true, completion: nil)
                /// /                            }
                /// /                    }
                /// /
                //                }
            } catch {
                self.HideProgressHud()
                print(error.localizedDescription)
            }
        }
        task.resume()

    } else {
//        CommonClass.showCustomeAlert(UIViewController(), messageA: "Device is not connected to the internet", butonTitle: "red")
    }
    }

    // MARK: - POST method for image call

    func jsonCallWithImage(imageData: [Data?], DicData: NSDictionary?, imagename: String?, strfieldName: String, urlClass: String, completionHandler: @escaping (NSMutableDictionary?, Error?) -> Swift.Void) {
        AddProgressHud()
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration, delegate: nil, delegateQueue: nil)
        let BoundaryConstant = "----------V2ymHFg03ehbqgZCaKO6jy"

        let FileParamConstant: String = strfieldName

        let url = URL(string: "\(urlBase)\(urlClass)")
        var request: URLRequest = URLRequest(url: url!)
        request.httpMethod = "POST"
        let contentType = "multipart/form-data; boundary=\(BoundaryConstant)"
        request.setValue(contentType, forHTTPHeaderField: "Content-Type")
        //  filename=\"\(image).png\"\r\n"
        // filename=\"image.png\"\r\n"
        //   filename=\"audio.m4a\"\r\n"
        //   let dic = DicData?.value(forKey: "type")
        var body = Data()
        for imag in imageData {
            if imag != nil {
                let image: String = imagename!
                body.append("--\(BoundaryConstant)\r\n".data(using: String.Encoding.utf8)!)
                body.append("Content-Disposition: form-data; name=\"\(FileParamConstant)\";  filename=\"\(image).png\"\r\n".data(using: String.Encoding.utf8)!)
                body.append("Content-Type: image/jpeg\r\n\r\n".data(using: String.Encoding.utf8)!)
                body.append(imag!)
                body.append("\r\n".data(using: String.Encoding.utf8)!)
            }
        }

        if DicData != nil {
            for (key, value) in DicData! {
                body.append("--\(BoundaryConstant)\r\n".data(using: String.Encoding.utf8)!)
                body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: String.Encoding.utf8)!)
                body.append("\(value)\r\n".data(using: String.Encoding.utf8)!)
            }
        }
        //        for (key, value) in DicData! {
        //         body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: String.Encoding.utf8)!)
        //
        //            body.append("\(value)\r\n\r\n\r\n".data(using: String.Encoding.utf8)!)
        //        }

        //        if audioData != nil
        //        {
        //            let audio: String = audioname!
        //            body.append("--\(BoundaryConstant)\r\n".data(using: String.Encoding.utf8)!)
        //            body.append("Content-Disposition: form-data; name=\"\(FileParamConstant)\"; filename=\"\(audio).m4a\"\r\n".data(using: String.Encoding.utf8)!)
        //            body.append("Content-Type: audio/x-m4a\r\n\r\n".data(using: String.Encoding.utf8)!)
        //            body.append(audioData!)
        //            body.append("\r\n".data(using: String.Encoding.utf8)!)
        //        }
        body.append("--\(BoundaryConstant)--\r\n".data(using: String.Encoding.utf8)!)
        request.httpBody = body
        let postLength = "\(UInt(body.count))"
        request.setValue(postLength, forHTTPHeaderField: "Content-Length")
        // set URL
        request.url = url
        request.timeoutInterval = 50
        let task = session.dataTask(with: request) { data, _, error in

            if error != nil {
                print(error!.localizedDescription)
                self.HideProgressHud()
                self.showFailureMessage(error: error! as NSError)
                return
            }
            do {
                let jsonResult: NSDictionary? = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary
                print("Synchronous\(String(describing: jsonResult))")

                self.HideProgressHud()
                completionHandler(jsonResult as? NSMutableDictionary, error)
                //                if((jsonResult?.value(forKey: "users")) != nil)
                //                {
                //                   self.HideProgressHud()
                //                    completionHandler(jsonResult?.mutableCopy() as? NSMutableDictionary,error)
                //                }
                //                else if((jsonResult?.value(forKey: "categories")) != nil)
                //                {
                //                    self.HideProgressHud()
                //                    completionHandler(jsonResult?.mutableCopy() as? NSMutableDictionary,error)
                //                }
                //                else if((jsonResult?.value(forKey: "items")) != nil)
                //                {
                //                    self.HideProgressHud()
                //                    completionHandler(jsonResult?.mutableCopy() as? NSMutableDictionary,error)
                //                }
                //                else
                //                {
                //                    let alertController = UIAlertController(title: "Alert", message: (jsonResult?.value(forKey: "message") as! NSString) as String, preferredStyle: .alert)
                //                    let OKAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default)
                //                    {
                //                        (action: UIAlertAction) in print("You have pressed ok button")
                //                    }
                //                    alertController.addAction(OKAction)
                //
                //                    self.HideProgressHud()
                //                    DispatchQueue.main.async
                //                        {
                //                            let window = UIApplication.shared.keyWindow;
                //                            var vc = window?.rootViewController
                //                            while (vc?.presentedViewController != nil)
                //                            {
                //                                vc = vc?.presentedViewController;
                //                            }
                //                            DispatchQueue.main.async {
                //                                vc?.present(alertController , animated: true, completion: nil)
                //                            }
                //                    }
                //                }
            } catch {
                self.HideProgressHud()
                print(error.localizedDescription)
            }
        }
        task.resume()
    }

    func jsonCallWith(images _: [UIImage]?, strFieldName _: String?, url _: String?, withCompletion _: @escaping (_ Dicationary: [AnyHashable: Any]?, _ error: Error?) -> Void) {}

    func jsonCall(withMultipleImagesImage productImages: [UIImage]?, withfieldName strfieldName: String?, classURL urlClass: String?, witCompilation completion: @escaping (_ Dictionary: [AnyHashable: Any]?, _ error: Error?) -> Void) {
        AddProgressHud()
        // NSError *error;
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration, delegate: nil, delegateQueue: nil)
        // the boundary string : a random string, that will not repeat in post data, to separate post data fields.
        let BoundaryConstant = "----------V2ymHFg03ehbqgZCaKO6jy"
        // string constant for the post parameter 'file'. My server uses this name: `file`. Your's may differ
        let FileParamConstant = strfieldName
        // the server url to which the image (or the media) is uploaded. Use your server url here
        let url = URL(string: "\(urlBase)\(urlClass ?? "")")
        print("url is \(String(describing: url))")

        let request = NSMutableURLRequest()
//        if userDefaults.value(forKey: userdefaultAuthHeader) != nil {
//            //request.setValue(userDefaults.value(forKey: userdefaultAuthHeader) as? String, forHTTPHeaderField: "Authorization")
//        }
        request.cachePolicy = .reloadIgnoringLocalCacheData
        request.httpShouldHandleCookies = false
        request.httpMethod = "POST"
        // set Content-Type in HTTP header
        let contentType = "multipart/form-data;boundary=\(BoundaryConstant)"
        request.addValue(contentType, forHTTPHeaderField: "Content-Type")
        // request.setValue(contentType, forHTTPHeaderField: "Content-Type")
        // post body
        let body = NSMutableData()
        var count = 0
        for image: UIImage in productImages! {
            count += 1
            let imageData = UIImage.jpegData(image)
            // UIImagePNGRepresentation(image)
            if imageData != nil {
                if let anEncoding = "--\(BoundaryConstant)\r\n".data(using: .utf8) {
                    body.append(anEncoding)
                }
                if let anEncoding = "Content-Disposition: form-data; name=\"\(String(describing: FileParamConstant!))\"; filename=\"image.png\"\r\n ".data(using: .utf8) {
                    body.append(anEncoding)
                }
                if let anEncoding = "Content-Type: image/png\r\n\r\n".data(using: .utf8) {
                    body.append(anEncoding)
                }
//                if let aData = imageData {
//                    body.append(aData)
//                }
                if let anEncoding = "\r\n".data(using: .utf8) {
                    body.append(anEncoding)
                }
            }
        }
        if let anEncoding = "--\(BoundaryConstant)--\r\n".data(using: .utf8) {
            body.append(anEncoding)
        }
        // setting the body of the post to the reqeust
        request.httpBody = body as Data
        // set the content-length
        // let postLength = "\(UInt((body as Data).count))"
        // request.setValue(postLength, forHTTPHeaderField: "Content-Length")

        // set URL
        request.url = url!
        print("re url \(request.url!)")
        var postDataTask: URLSessionDataTask?

        postDataTask = session.dataTask(with: request as URLRequest) { data, _, error in

            if error == nil {
                var dicjson: [AnyHashable: Any]?
                DispatchQueue.main.async {
                    //      self.hud.hide(animated: true)
                }
                print("\(String(data: data!, encoding: .utf8) ?? "")")
                if let aData = data {
                    dicjson = try! JSONSerialization.jsonObject(with: aData, options: []) as? [AnyHashable: Any]
                }
                completion(dicjson, error)
            } else {
                print("erro \(String(describing: error?.localizedDescription))")
                DispatchQueue.main.async {
                    //      self.hud.hide(animated: true)
                }
                completion(nil, error)
                // GlobalClass.showAlertwithTitle("Server Error", message: error?.description)
            }
        }

        postDataTask?.resume()
    }

    // MARK: - upload only Image

    func UploadImage(imageData: Data?, audioData: Data?, imagename: String?, audioname: String?, strfieldName: String, ClassUrl: String, completionHandler: @escaping (NSMutableDictionary?, Error?) -> Swift.Void) {
        AddProgressHud()
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration, delegate: nil, delegateQueue: nil)
        let BoundaryConstant = "----------V2ymHFg03ehbqgZCaKO6jy"

        let FileParamConstant: String = strfieldName

        let url = URL(string: urlBase + ClassUrl)!
        var request: URLRequest = URLRequest(url: url)
        request.httpMethod = "POST"
        let contentType = "multipart/form-data; boundary=\(BoundaryConstant)"
        request.setValue(contentType, forHTTPHeaderField: "Content-Type")
        //  filename=\"\(image).png\"\r\n"
        // filename=\"image.png\"\r\n"
        //   filename=\"audio.m4a\"\r\n"
        var body = Data()
        if imageData != nil {
            let image: String = imagename!
            body.append("--\(BoundaryConstant)\r\n".data(using: String.Encoding.utf8)!)
            body.append("Content-Disposition: form-data; name=\"\(FileParamConstant)\";  filename=\"\(image).png\"\r\n".data(using: String.Encoding.utf8)!)
            body.append("Content-Type: image/jpeg\r\n\r\n".data(using: String.Encoding.utf8)!)
            body.append(imageData!)
            body.append("\r\n".data(using: String.Encoding.utf8)!)
        }

        if audioData != nil {
            let audio: String = audioname!
            body.append("--\(BoundaryConstant)\r\n".data(using: String.Encoding.utf8)!)
            body.append("Content-Disposition: form-data; name=\"\(FileParamConstant)\"; filename=\"\(audio).m4a\"\r\n".data(using: String.Encoding.utf8)!)
            body.append("Content-Type: audio/x-m4a\r\n\r\n".data(using: String.Encoding.utf8)!)
            body.append(audioData!)
            body.append("\r\n".data(using: String.Encoding.utf8)!)
        }
        body.append("--\(BoundaryConstant)--\r\n".data(using: String.Encoding.utf8)!)
        request.httpBody = body
        let postLength = "\(UInt(body.count))"
        request.setValue(postLength, forHTTPHeaderField: "Content-Length")
        // set URL
        request.url = url
        request.timeoutInterval = 50
        let task = session.dataTask(with: request) { data, _, error in

            if error != nil {
                print(error!.localizedDescription)
                self.HideProgressHud()
                self.showFailureMessage(error: error! as NSError)
                return
            }
            do {
                let jsonResult: NSDictionary? = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary
                print("Synchronous\(String(describing: jsonResult))")

                if (jsonResult?.value(forKey: "users")) != nil {
                    self.HideProgressHud()
                    completionHandler(jsonResult?.mutableCopy() as? NSMutableDictionary, error)
                } else if (jsonResult?.value(forKey: "categories")) != nil {
                    self.HideProgressHud()
                    completionHandler(jsonResult?.mutableCopy() as? NSMutableDictionary, error)
                } else if (jsonResult?.value(forKey: "items")) != nil {
                    self.HideProgressHud()
                    completionHandler(jsonResult?.mutableCopy() as? NSMutableDictionary, error)
                } else {
                    let alertController = UIAlertController(title: "Alert", message: (jsonResult?.value(forKey: "message") as! NSString) as String, preferredStyle: .alert)
                    let OKAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
                    {
                        (_: UIAlertAction) in print("You have pressed ok button")
                    }
                    alertController.addAction(OKAction)

                    self.HideProgressHud()
                    DispatchQueue.main.async
                    {
                        let window = UIApplication.shared.keyWindow
                        var vc = window?.rootViewController
                        while vc?.presentedViewController != nil {
                            vc = vc?.presentedViewController
                        }
                        DispatchQueue.main.async {
                            vc?.present(alertController, animated: true, completion: nil)
                        }
                    }
                }
            } catch {
                self.HideProgressHud()
                print(error.localizedDescription)
            }
        }
        task.resume()
    }

    // MARK: - failure message method

    func showFailureMessage(error: NSError) {
        if error.localizedDescription.range(of: "The request timed out.") != nil {
            displayMyAlertMessage(Title: "Alert", userMessage: "The request timed out, please verify your internet connection and try again.")
        } else if error.localizedDescription.range(of: "The server can not find the requested page") != nil || error.localizedDescription.range(of: "A server with the specified hostname could not be found.") != nil {
            displayMyAlertMessage(Title: "Alert", userMessage: "Unable to reach to the server, please try again after few minutes")
        } else if error.localizedDescription.range(of: "The network connection was lost.") != nil {
            displayMyAlertMessage(Title: "Alert", userMessage: "The network connection was lost, please try again.")
        } else if error.localizedDescription.range(of: "The Internet connection appears to be offline.") != nil {
            displayMyAlertMessage(Title: "Alert", userMessage: "The Internet connection appears to be offline.")
        } else if error.localizedDescription.range(of: "JSON text did not start with array or object and option to allow fragments not set.") != nil {
            displayMyAlertMessage(Title: "Alert", userMessage: "Server error!")
        } else {
            displayMyAlertMessage(Title: "Alert", userMessage: "Unable to connect, please try again!")
        }
    }

    // MARK: - alert method

    func displayMyAlertMessage(Title: String, userMessage: String) {
        let myAlert = UIAlertController(title: Title, message: userMessage, preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil)
        myAlert.addAction(okAction)

        let window = UIApplication.shared.keyWindow
        var vc = window?.rootViewController
        while vc?.presentedViewController != nil {
            vc = vc?.presentedViewController
        }
        DispatchQueue.main.async {
            vc?.present(myAlert, animated: true, completion: nil)
        }
    }

    // MARK: - MBProgressHUD Method

    func AddProgressHud() {
        DispatchQueue.main.async {
            if let _ = UIApplication.shared.delegate as? AppDelegate {
//                SVProgressHUD.show()
//                SVProgressHUD.setDefaultStyle(.custom)
//                SVProgressHUD.setDefaultMaskType(.custom)
//                SVProgressHUD.setForegroundColor(UIColor.init(red:255.0/255.0, green:148.0/255.0 ,blue:42.0/255.0, alpha:0.5))
//                SVProgressHUD.setBackgroundColor(UIColor.init(red:241.0/255.0, green:249.0/255.0 ,blue:235.0/255.0, alpha:0.2))
//                SVProgressHUD.setBackgroundLayerColor(UIColor.init(red:246.0/255.0, green:246.0/255.0 ,blue:246.0/255.0, alpha:0.5))
//
            }
        }

        //        DispatchQueue.main.async {
        //            if let _ = UIApplication.shared.delegate as? AppDelegate{
        //             //MBProgressHUD.showAdded(to: window, animated: true)
        //
        //                self.hud = MBProgressHUD.showAdded(to: (delegate.window?.rootViewController?.view!)!, animated: true)
        //
        //                self.hud.mode = .indeterminate
        //                self.hud.label.text = "Loading..."
        //                self.hud.minSize = CGSize(width: 150, height: 100)
        //
        //            }
        //        }
    }

    func HideProgressHud() {
        DispatchQueue.main.async {
            if let app = UIApplication.shared.delegate as? AppDelegate, let _ = app.window {
                DispatchQueue.main.async {
                    //   SVProgressHUD.dismiss()
                }
            }
        }
    }
}

extension NSMutableData {
    func appendString(string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
        append(data!)
    }
}
