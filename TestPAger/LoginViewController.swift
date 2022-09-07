//
//  LoginViewController.swift
//  TestPAger
//
//  Created by MacOS on 03/09/2022.
//

import UIKit
import MMBAlertsPickers
import Firebase
import GoogleSignIn
import FirebaseAuth
import FirebaseFirestore
import FBSDKLoginKit

class LoginViewController: UIViewController {
    @IBOutlet weak var flagImg: UIImageView!
    @IBOutlet weak var phoneCodelbl: UILabel!
    @IBOutlet weak var phoneTextField: UITextField!
    let provider = OAuthProvider(providerID: "twitter.com")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController!.providesPresentationContextTransitionStyle = true
        self.navigationController!.definesPresentationContext = true
        
    }
    @IBAction func showPhoneCodes(_ sender: UITapGestureRecognizer) {
        let alert = UIAlertController(style: .actionSheet, title: "Phone Codes")
        alert.addLocalePicker(type: .phoneCode) { [self] info in
            // action with selected object
            self.phoneCodelbl.text = info?.phoneCode
            self.flagImg.image = info?.flag
        }
        alert.show()
    }
    @IBAction func backClicked(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true)
    }
    @IBAction func loginClicked(_ sender: UIButton) {
        switch sender.tag {
        case 1 : loginWithGoogle()
        case 2 : loginWithFaceBook()
        case 3 : loginWithTwitter()
        default: loginWithPhone()
        }
    }
    
}


extension LoginViewController {
    
    func loginWithGoogle() {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.signIn(with: config, presenting: self) { user, error in
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
            Auth.auth().signIn(with: credential) { authResult, error in
                if let error = error {
                    print(error.localizedDescription)
                    self.showFailureAlert()
                }else {
                    SuccessFailureAlertVController.presentRootViewController()
                    print(authResult?.user.email ?? "default value")
                    print(authResult?.user.displayName ?? "default value")
                    
                }
            }
        }
    }
    func loginWithFaceBook() {
        let fbLoginManager = LoginManager()
        fbLoginManager.logIn(permissions:["public_profile", "email"], from: self) { result, error in
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
            Auth.auth().signIn(with: credential) { authResult, error in
                if let error = error {
                    print(error.localizedDescription)
                    self.showFailureAlert()
                }else {
                    SuccessFailureAlertVController.presentRootViewController()
                    print(authResult?.user.uid ?? "default value")
                }
            }
        }
    }
    func loginWithTwitter(){
        provider.getCredentialWith(nil) { credential, error in
            if error != nil {
                print(error?.localizedDescription ?? "default value")
                
                // Handle error.
            }
            if credential != nil {
                Auth.auth().signIn(with: credential!) { authResult, error in
                    if error != nil {
                        // Handle error.
                        print(error?.localizedDescription ?? "default value")
                        self.showFailureAlert()

                    }else {
                        SuccessFailureAlertVController.presentRootViewController()
                        print(authResult?.additionalUserInfo?.profile!["name"] ?? "default value")
                        print(authResult?.user.uid ?? "default value")
                    }
                }
            }
        }
        
        
    }
    func loginWithPhone() {
        if validateTextFiled() {
            PhoneAuthProvider.provider().verifyPhoneNumber(returnPhone(), uiDelegate: nil) { verificationID, error in
                if let error = error {
                    self.showFailureAlert()
                    print(error.localizedDescription)
                }else {
                    if verificationID != nil {
                        if  let vc =  VerifyPhoneViewController.instantiate() as? VerifyPhoneViewController {
                            vc.verificationID = verificationID
                            vc.phoneNumber = self.returnPhone()
                            vc.phoneNumberToLbl = self.returnPhoneToLbl()
                            self.navigationController?.pushViewController(vc, animated: true)
                        }
                    }
                }
            }
        }else {
            print("Please Enter Your Phone Number")
            
           let alert =  UIAlertController(title: "Wrong Number !", message:"Please Enter Correct Phone Number ", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel))
            alert.show()
        }
    }
    func validateTextFiled()-> Bool {
        if  phoneTextField.text?.count ?? 0 > 7 {
            print("true")
            return true
        }else {
            print("false")
            return false
        }
    }
    func returnPhone()->String {
        return self.phoneCodelbl.text!.appending(phoneTextField.text!)
    }
    func returnPhoneToLbl()->String {
        return self.phoneCodelbl.text!.appending("-"+phoneTextField.text!)
    }
    func showFailureAlert (){
        if let vc =  SuccessFailureAlertVController.instantiate() as? SuccessFailureAlertVController {
            vc.isSuccess = false
            self.present(vc, animated: true)
        }
        

    }
}
