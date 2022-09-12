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
        FirebaseLogin.shared.loginWithGoogle()
    }
    
    func loginWithFaceBook() {
        FirebaseLogin.shared.loginWithFaceBook()
    }
    func loginWithTwitter(){
        FirebaseLogin.shared.loginWithTwitter()
    }
    func loginWithPhone() {
        if validateTextFiled() {
            FirebaseLogin.shared.loginWith(phone: returnPhoneToLbl(), vController: self)
        }else {
            print("Please Enter Your Phone Number")
            
            let alert =  UIAlertController(title: "Wrong Number !", message:"Please Enter Correct Phone Number ", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel))
            alert.show()
        }
    }
    func validateTextFiled()-> Bool {
        if  phoneTextField.text?.count ?? 0 > 7 {
            return true
        }else {
            return false
        }
    }
//    func returnPhone()->String {
//        return self.phoneCodelbl.text!.appending(phoneTextField.text!)
//    }
    func returnPhoneToLbl()->String {
        return self.phoneCodelbl.text!.appending("-"+phoneTextField.text!)
    }
    
}
