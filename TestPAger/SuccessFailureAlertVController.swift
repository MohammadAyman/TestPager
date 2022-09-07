//
//  SuccessFailureAlertVController.swift
//  TestPAger
//
//  Created by MacOS on 05/09/2022.
//

import UIKit

class SuccessFailureAlertVController: UIViewController {
    @IBOutlet weak var logoImg: UIImageView!
    
    @IBOutlet weak var descriptionStack: UIStackView!
    @IBOutlet weak var successFailurelbl: UILabel!
    @IBOutlet weak var letGoBtn: UIButton!
    var isSuccess = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setFailureAlertVController()
        // Do any additional setup after loading the view.
    }
    @IBAction func letGoBtnAction(_ sender: UIButton) {
        if isSuccess {
            TabBarViewController.presentRootViewController()
//            self.dismiss(animated: true)
        }else {
                        self.dismiss(animated: true)

        }
        
    }
    
    
    
    
}
extension SuccessFailureAlertVController {
    
    func setFailureAlertVController(){
        if !isSuccess {
            logoImg.image = UIImage(named: "failureIcon")
            logoImg.contentMode = .scaleAspectFit
            descriptionStack.isHidden = true
            successFailurelbl.text = "فشل عملية التحقق"
            letGoBtn.setTitle("إعادة المحاولة", for: .normal)
        }
        
    }
    
}
