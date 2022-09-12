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
    private let ABI_URL = "https://stoot.iphonealsham.com/api/v1"
    private let ABI_URL_TOKEN = "https://stoot.iphonealsham.com/api/v1/id-token"
    
    func getIdToken(uid:String , block: @escaping (Bool) -> Void) {
        let prame = ["uid":uid]
        if let url = URL(string: ABI_URL_TOKEN) {
            self.sendRequest(url: url, params: prame) { idToken in
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
    func sendRequest(url:URL , params: Dictionary<String, String>? , block: @escaping (String?) -> Void) {
        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        let queryItems: [URLQueryItem] = (params?.map({ (key: String, value: String) in
            URLQueryItem(name: key, value: value)
        }))!
        components?.queryItems = queryItems
        guard let url = components?.url else {
            return              }
        
        URLSession.shared.dataTask(with: url) { data, respon, error in
            if error == nil {
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? Dictionary<String, AnyObject>
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
