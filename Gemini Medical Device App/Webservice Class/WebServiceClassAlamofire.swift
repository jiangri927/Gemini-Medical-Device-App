import Alamofire
import Foundation
import SVProgressHUD

class WebServiceClasses: NSObject {
    static let shared = WebServiceClasses()
    var alamoFireManager: SessionManager?
    var objappDelegate = UIApplication.shared.delegate as! AppDelegate

    func webService(webService: WebServiceClasses) -> WebServiceClasses {
        return webService
    }

    // MARK: - Check Connectivity

    class Connectivity {
        class var isConnectedToInternet: Bool {
            return NetworkReachabilityManager()!.isReachable
        }

        class var isWifiConnected: Bool {
            return NetworkReachabilityManager()!.isReachableOnEthernetOrWiFi
        }
    }

    // MARK: - API CALLING METHODS

    // GET METHOD
    func requestGet(_ strURL: String, success: @escaping (String) -> Void, failure: @escaping (Error) -> Void) {
        //    let todosEndpoint: String = "your_server_url" + "parameterName=\(parameters_name)"
        AddProgressHud()
        let todosEndpoint: String = strURL
        Alamofire.request(todosEndpoint, method: .get, encoding: JSONEncoding.default)
            .responseString { responseObject in
                debugPrint(responseObject)
                print(responseObject)
                //                CommonMethodsModel.HidePrgressHUD()
                self.HideProgressHud()
                if responseObject.result.isSuccess {
                    let resJson = responseObject.result.value

                    success(resJson ?? "No Value")
                }
                if responseObject.result.isFailure {
                    let error: Error = responseObject.result.error!
                    failure(error)
                }
            }
    }

    // POST METHOD
    func requestPOSTURL(_ strURL: String, progress: Bool, params: [String: AnyObject]?, headers: [String: String]?, success: @escaping (NSDictionary) -> Void, failure: @escaping (Error) -> Void) {
        let url = URL(string: baseURL + strURL)!
        let configuration = URLSessionConfiguration.default
        if progress == true {
            AddProgressHud()

            configuration.timeoutIntervalForRequest = 25
            configuration.timeoutIntervalForResource = 25
        } else {
            configuration.timeoutIntervalForRequest = 25
            configuration.timeoutIntervalForResource = 25
        }

        print(url, params)
        if Connectivity.isConnectedToInternet == true {
//             CommonMethodsModel.showProgrssHUD()

            alamoFireManager = Alamofire.SessionManager(configuration: configuration)

            alamoFireManager!.request(url, method: .post, parameters: params, encoding: URLEncoding.default, headers: headers).responseJSON { (responseObject) -> Void in

                print(responseObject)
//                CommonMethodsModel.HidePrgressHUD()
                self.HideProgressHud()
                if responseObject.result.isSuccess {
                    let resJson = responseObject.result.value as! NSDictionary

                    success(resJson)
                }
                if responseObject.result.isFailure {
                    let error: Error = responseObject.result.error!
                    failure(error)
                }
            }

        } else {
            HideProgressHud()
            commonClass.showCustomeAlert(UIViewController(), messageA: "No Internet Connection", MessageColor: "red")
        }
    }

    // MARK: - For Only Payment added this Temp method

    func requestPOSTURLPayment(_ strURL: String, progress: Bool, params: [String: AnyObject]?, headers: [String: String]?, success: @escaping (NSDictionary) -> Void, failure: @escaping (Error) -> Void) {
        let url = URL(string: strURL)!
        if progress == true {
            AddProgressHud()
        }

        print(url, params)
        if Connectivity.isConnectedToInternet == true {
            //             CommonMethodsModel.showProgrssHUD()
            Alamofire.request(url, method: .post, parameters: params, encoding: URLEncoding.httpBody, headers: headers).responseJSON { (responseObject) -> Void in

                print(responseObject)
                //                CommonMethodsModel.HidePrgressHUD()
                self.HideProgressHud()
                if responseObject.result.isSuccess {
                    let resJson = responseObject.result.value as! NSDictionary

                    success(resJson)
                }
                if responseObject.result.isFailure {
                    let error: Error = responseObject.result.error!
                    failure(error)
                }
            }

        } else {
            HideProgressHud()
            commonClass.showCustomeAlert(UIViewController(), messageA: "No Internet Connection", MessageColor: "red")
        }
    }

    // MARK: - UPLOAD IMAGE

    func requestUploadImage(_ strURL: String, imageData: Data?, params: [String: AnyObject]?, headers _: [String: String]?, success: @escaping (NSDictionary) -> Void, failure _: @escaping (Error) -> Void) {
//        let  params = ["id": "101", "name": "Navin", "timezone": "2018-07-26  03:17:06" , "image": imageData] as [String : AnyObject]
        //
        //  CommonMethodsModel.showProgrssHUD()
        let url = URL(string: baseURL + strURL)!
        let parameters = params // Optional for extra parameter

        Alamofire.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(imageData!, withName: "image", fileName: "file.jpeg", mimeType: "image/jpeg")
            print(imageData, params)
            for (key, value) in parameters! {
                multipartFormData.append(value.data(using: String.Encoding.utf8.rawValue)!, withName: key)
            } // Optional for extra parameters
        },
                         usingThreshold: UInt64(), to: url, method: .post)
        { result in
//             CommonMethodsModel.HidePrgressHUD()
            switch result {
            case let .success(upload, _, _):

                upload.uploadProgress(closure: { progress in
                    print("Upload Progress: \(progress.fractionCompleted)")
                })

                upload.responseJSON { response in
                    print(response.result.value)

                    success(response.result.value as! NSDictionary)
                }

            case let .failure(encodingError):
                print(encodingError)
            }
        }
    }

    //
//    func requestPOSTURLAddEvent(_ strURL : String, params : [[String : AnyObject]]?, headers : [String : String]?, success:@escaping (NSDictionary) -> Void, failure:@escaping (Error) -> Void){
//        let url = URL(string: baseURL + strURL)!
//        Alamofire.request(url, method: .post, parameters: params, encoding: URLEncoding.httpBody, headers: nil).responseJSON { (responceObj)-> Void  in
//            print(responceObj)
//        }
//        Alamofire.request(url, method: .post, parameters: params, encoding: URLEncoding.httpBody  ).responseJSON { (responceOject) -> Void in
//
//            print(responseObject)
//
//
//            if responseObject.result.isSuccess {
//
//                let resJson = responseObject.result.value as! NSDictionary
//                //try! JSONDecoder().decode(DataB.self, from: responseObject.data!)
//                //(responseObject.result.value!)
//                //    let OnlyData =    resJson.value(forKey: "data")
//                success(resJson )
//            }
//            if responseObject.result.isFailure {
//                let error : Error = responseObject.result.error!
//                failure(error)
//            }
//        }
//
//
//
//    }

    // MARK: - ProgessHUd

    func AddProgressHud() {
        DispatchQueue.main.async {
            if let _ = UIApplication.shared.delegate as? AppDelegate {
                SVProgressHUD.show()
                SVProgressHUD.setDefaultStyle(.custom)
                SVProgressHUD.setDefaultMaskType(.custom)
                SVProgressHUD.setForegroundColor(UIColor(red: 255.0 / 255.0, green: 148.0 / 255.0, blue: 42.0 / 255.0, alpha: 0.5))
                SVProgressHUD.setBackgroundColor(UIColor(red: 241.0 / 255.0, green: 249.0 / 255.0, blue: 235.0 / 255.0, alpha: 0.2))
                SVProgressHUD.setBackgroundLayerColor(UIColor(red: 246.0 / 255.0, green: 246.0 / 255.0, blue: 246.0 / 255.0, alpha: 0.5))
            }
        }
    }

    func HideProgressHud() {
        DispatchQueue.main.async {
            if let app = UIApplication.shared.delegate as? AppDelegate, let _ = app.window {
                DispatchQueue.main.async {
                    SVProgressHUD.dismiss()
                }
            }
        }
    }
}
