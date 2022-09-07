//
//  WelcomeView.swift
//  TestPAger
//
//  Created by MacOS on 02/09/2022.
//

import UIKit

class WelcomeView: UIView {

    @IBOutlet weak var typelbl: UILabel!
    @IBOutlet var contentView: UIView!
    @IBInspectable var identifier:String?
    @IBOutlet weak var imgView: UIImageView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureXib()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureXib()
    }

    private func configureXib(){
        
        Bundle.main.loadNibNamed("WelcomeView", owner: self, options: [:])
        contentView.autoresizingMask = [.flexibleWidth , .flexibleHeight]
        contentView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(contentView)
        contentView.topAnchor .constraint(equalTo: topAnchor).isActive = true
        contentView.bottomAnchor .constraint(equalTo: bottomAnchor).isActive = true
        contentView.leftAnchor .constraint(equalTo: leftAnchor).isActive = true
        contentView.rightAnchor .constraint(equalTo: rightAnchor).isActive = true
        contentView.layoutIfNeeded()
        
    }
    override func didMoveToWindow() {
        super.didMoveToWindow()
        typelbl.text = identifier == "WView2" ?  "زائر" : typelbl.text
        typelbl.textColor  = identifier == "WView2" ?  UIColor.toHex(hex: "656565") : UIColor.toHex(hex: "FF3737")
        imgView.image =  identifier == "WView2" ? UIImage(named:"MaskGroup28") : UIImage(named: "Group1939")
        
    }
    
    @IBAction func goToLogin(_ sender: UITapGestureRecognizer) {
         LoginViewController.presentRootViewController()
    }
}

