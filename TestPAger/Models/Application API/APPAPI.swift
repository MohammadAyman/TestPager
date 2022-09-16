//
//  WebServes.swift
//  TestPAger
//
//  Created by MacOS on 10/09/2022.
//

import Foundation
import UIKit
class APPAPI {
    static let shared = APPAPI()
    private let ABI_URL = "https://stoot.iphonealsham.com/api/v1/user"
    //    private let ABI_URL_TOKEN = "https://stoot.iphonealsham.com/api/v1/id-token"
    
    func getIdToken(uid:String , block: @escaping (Bool) -> Void) {
        if let url = URL(string: ABI_URL) {
            self.sendRequest(url: url, uid: uid) { idToken in
                if let idToken = idToken {
                    UIApplication.shared.accessToken = idToken
                    block(true)
                    
                }else {
                    block(false)
                }
            }
        }else{
            block(false)
        }
    }
    func sendRequest(url:URL , uid:String , block: @escaping (String?) -> Void) {
        let apiKey = "Bearer " + uid
        //        URLRequest
        
        //
        //        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        //        let queryItems: [URLQueryItem] = (params?.map({ (key: String, value: String) in
        //            URLQueryItem(name: key, value: value)
        //        }))!
        //        components?.queryItems = queryItems
        //        guard let url = components?.url else {
        //            return              }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("ar", forHTTPHeaderField: "Accept-Language")
        let sessionConfiguration = URLSessionConfiguration.default // 5
        sessionConfiguration.httpAdditionalHeaders = [
            "Authorization": apiKey // 6
        ]
        let session = URLSession(configuration: sessionConfiguration) // 7
        session.dataTask(with: request) { data, respon, error in
            if error == nil {
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? Dictionary<String, AnyObject>
                    print(json)
                    if let token = json?["idToken"] as? String {
                        block(token)
                    }else {
                        block(nil)
                    }
                } catch let caught {
                    print(caught)
                    block(nil)
                }
            }else {
                print(error?.localizedDescription ?? "default value")
                block(nil)
            }
        }.resume()
        
    }
}

extension UIApplication {
    var accessToken:String? {
        set(newVal){
            UserDefaults.standard.set(newVal, forKey: "id-accessToken")
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.string(forKey: "id-accessToken")
        }
    }
}
