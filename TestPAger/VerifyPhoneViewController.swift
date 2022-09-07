//
//  VerifyPhoneViewController.swift
//  TestPAger
//
//  Created by MacOS on 05/09/2022.
//

import UIKit
import FirebaseAuth

class VerifyPhoneViewController: UIViewController {

    @IBOutlet weak var phoneNumlbl: UILabel!
    @IBOutlet weak var activeCodeTxField: UITextField!
    @IBOutlet weak var timerLbl: UILabel!
    @IBOutlet weak var confirmBtn: UIButton!
    
    var verificationID:String?
    var phoneNumber:String?
    var phoneNumberToLbl:String?
    var counter = 0
    var isSendAgainActive = false
    
    var timer:Timer?
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupData()
        setupView()
        localized()
        fetchData()
    }
    func setupView(){
        phoneNumlbl.text = phoneNumberToLbl
        activeCodeTxField.delegate = self
        activeCodeTxField.keyboardType = .numberPad
        activeCodeTxField.returnKeyType = .done
        activeCodeTxField.addTarget(self, action: #selector(VerifyPhoneViewController.textFieldDidChange(_:)), for: .editingChanged)
        runTimer()
    }
    func localized(){}
    func setupData(){}
    func fetchData(){}
    
    @IBAction func comfirmBtnAction(_ sender: UIButton) {
        if isSendAgainActive {
            print("isSendAgainActive == True")
            runTimer()
            enableComfirmBtn(enable: false)
        }else {
            print("isSendAgainActive == false")
            sendDataToFirebase()
        }
    }
    @objc func update() {
        counter -= 1
        timerLbl.text = "00:\(String(format:"%02i",counter))"
        if counter == 0 {
            stopTimer()
            enableComfirmBtn(enable: true)
            confirmBtn.setTitle("إعادة الإرسال", for: UIControl.State.normal)
            isSendAgainActive = true
        }
    }
}
// MARK: - TextFieldDelegate
extension VerifyPhoneViewController:UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLength = 6
        if let currentString = textField.text {
          let newString = currentString.replacingCharacters(in: Range(range, in: currentString)!, with: string)
          return newString.count <= maxLength
        }
        return true
    }
    @objc func textFieldDidChange(_ textField: UITextField) {
        enableComfirmBtn(enable: textField.text?.count == 6)
        if textField.text?.count == 6 {
            confirmBtn.setTitle("تأكيد", for: UIControl.State.normal)
        }
    }
}

// MARK: - SendDataToFirebase
extension VerifyPhoneViewController {
    func sendDataToFirebase() {
        let credential = PhoneAuthProvider.provider().credential(
            withVerificationID: verificationID!,
            verificationCode: activeCodeTxField.text!
        )
        Auth.auth().signIn(with: credential) { authResult, error in
            if let error = error {
                print(error.localizedDescription)
                if let vc = SuccessFailureAlertVController.instantiate() as? SuccessFailureAlertVController {
                    vc.isSuccess = false
                    self.present(vc, animated: true)
                }
            }else {
                SuccessFailureAlertVController.presentRootViewController()
            }
        }
    }
    func enableComfirmBtn (enable:Bool){
        if enable {
            self.view.endEditing(true)
            confirmBtn.isEnabled = true
            confirmBtn.backgroundColor = UIColor.toHex(hex: "FF3737")
            stopTimer()
            isSendAgainActive = false
        }else {
            confirmBtn.isEnabled = false
            confirmBtn.backgroundColor = UIColor.toHex(hex: "979797")
            confirmBtn.setTitle("تأكيد", for: UIControl.State.normal)
        }
    }
    func runTimer()  {
        counter = 60
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
    }
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
}
