//
//  FirebaseLogin.swift
//  TestPAger
//
//  Created by MacOS on 09/09/2022.
//

import Foundation
import Firebase
import GoogleSignIn
import FirebaseAuth
import FirebaseFirestore
import FBSDKLoginKit

class FirebaseLogin {
    
    static let shared = FirebaseLogin()
    
    
    private var viewController:UIViewController = UIApplication.shared.rootViewController()
    private let provider = OAuthProvider(providerID: "twitter.com")
    private var verificationID:String?
    
    
    private init(){}
    
    
    func loginWithGoogle(){
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.signIn(with: config, presenting: viewController) { user, error in
            if let error = error {
                self.showFailureAlert()
                print(error.localizedDescription)
                return
            }
            guard let authentication = user?.authentication,
                  let idToken = authentication.idToken
            else {
                return
            }
            let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                           accessToken: authentication.accessToken)
            self.authWithFirebase(credential: credential) { isSuccess in
                if isSuccess {
                    SuccessFailureAlertVController.presentRootViewController()
                }else {
                    self.showFailureAlert()
                }
            }
        }
    }
    func loginWithFaceBook(){
        let fbLoginManager = LoginManager()
        fbLoginManager.logIn(permissions:["public_profile", "email"], from: self.viewController) { result, error in
            if let error = error {
                self.showFailureAlert()
                print("Failed to login: \(error.localizedDescription)")
                return
            }
            guard let accessToken = AccessToken.current else {
                self.showFailureAlert()
                print("Failed to get access token")
                return
            }
            let credential = FacebookAuthProvider.credential(withAccessToken: accessToken.tokenString)
            self.authWithFirebase(credential: credential) { isSuccess in
                if isSuccess {
                    SuccessFailureAlertVController.presentRootViewController()
                }else {
                    self.showFailureAlert()
                }
            }
        }
    }
    func loginWithTwitter(){
        provider.getCredentialWith(nil) { credential, error in
            if error != nil {
                print(error?.localizedDescription ?? "default value")
                self.showFailureAlert()
            }
            if credential != nil {
                self.authWithFirebase(credential: credential!) { isSuccess in
                    if isSuccess {
                        SuccessFailureAlertVController.presentRootViewController()
                    }else {
                        self.showFailureAlert()
                    }
                }
            }
        }
    }
    func loginWith(phone:String ,vController:UIViewController){
        let number = phone.replacingOccurrences(of: "-", with: "")
        print(number)
        PhoneAuthProvider.provider().verifyPhoneNumber(number, uiDelegate: nil) { verificationID, error in
            if let error = error {
                self.showFailureAlert()
                print(error.localizedDescription)
            }else {
                if verificationID != nil {
                    if  let vc =  VerifyPhoneViewController.instantiate() as? VerifyPhoneViewController {
                        self.verificationID = verificationID
                        vc.phoneNumberToLbl = phone
                        vController.navigationController?.pushViewController(vc, animated: true)
                    }
                }else {
                    self.showFailureAlert()
                }
            }
        }
    }
    func verifyPhoneNumber(code:String){
        if let verID = self.verificationID {
            let credential = PhoneAuthProvider.provider().credential(
                withVerificationID: verID,
                verificationCode:code)
            self.authWithFirebase(credential: credential) { isSuccess in
                if isSuccess {
                    SuccessFailureAlertVController.presentRootViewController()
                }else {
                    self.showFailureAlert()
                    
                }
            }
        }
    }
    
    func authWithFirebase(credential:AuthCredential ,block: @escaping (Bool) -> Void)  {
        Auth.auth().signIn(with: credential) { authResult, error in
            if let error = error {
                print(error.localizedDescription)
                block(false)
            }else {
                if let uid = authResult?.user.uid {
                    APPAPI.shared.getIdToken(uid: uid) { isSuccess in
                        debugPrint(UIApplication.shared.accessToken ?? "default value")
                        DispatchQueue.main.sync{
                            block(isSuccess)
                        }
                    }
                }else {
                    block(false)
                }
            }
        }
    }
    private func showFailureAlert (){
        if let vc =  SuccessFailureAlertVController.instantiate() as? SuccessFailureAlertVController {
            vc.isSuccess = false
            viewController.present(vc, animated: true)
        }
    }
}
