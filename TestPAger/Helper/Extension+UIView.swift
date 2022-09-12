//
//  Extension+UIView.swift
//  TestPAger
//
//  Created by Mac on 9/1/22.
//

import Foundation
import UIKit

extension UIView {
    @IBInspectable
    open var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set(value) {
            layer.cornerRadius = value
        }
    }
    
    @IBInspectable
    open var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set(value) {
            layer.borderWidth = value
        }
    }
    
    /// A property that accesses the layer.borderColor property.
    @IBInspectable
    open var borderColor: UIColor? {
        get {
            guard let v = layer.borderColor else {
                return nil
            }
            return UIColor(cgColor: v)
        }
        set(value) {
            layer.borderColor = value?.cgColor
        }
    }
    @IBInspectable
    open var shadowColor: UIColor? {
        get {
            guard let v = layer.shadowColor else {
                return nil
            }
            
            return UIColor(cgColor: v)
        }
        set(value) {
            layer.shadowColor = value?.cgColor
        }
    }
    
    /// A property that accesses the backing layer's shadowOffset.
    @IBInspectable
    open var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set(value) {
            layer.shadowOffset = value
        }
    }
    
    /// A property that accesses the backing layer's shadowOpacity.
    @IBInspectable
    open var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set(value) {
            layer.shadowOpacity = value
        }
    }
    
    /// A property that accesses the backing layer's shadowRadius.
    @IBInspectable
    open var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set(value) {
            layer.shadowRadius = value
        }
    }
    
}

extension UIStoryboard {
    
    static func main()->UIStoryboard{
        return UIStoryboard(name: "Main", bundle: nil)
    }
}

extension UIViewController {
    
    class func instantiate<T: UIViewController>() -> T {
        let storyboard = UIStoryboard.main()
        let identifier = String(describing: self)
        return storyboard.instantiateViewController(withIdentifier: identifier) as! T
    }
    
    class func presentRootViewController (){
        var topMostViewController = UIApplication.shared.sceneDelegate?.window?.rootViewController
        while let presentedViewController = topMostViewController?.presentedViewController {
            topMostViewController = presentedViewController
        }
        topMostViewController!.present(self.instantiate(), animated: true, completion: nil)
    }
    
    
    func setupNavigationBar() {
        self.navigationItem.hidesBackButton = true
        let action = UIAction(title: "", image: UIImage(systemName: "chevron.right")) { _ in
            self.navigationController?.popViewController(animated: true)
        }
        let backBtn = UIBarButtonItem(title: nil,
                                      image: nil,
                                      primaryAction: action,
                                      menu: nil)
        backBtn.tintColor = UIColor.toHex(hex: "656565")
        self.navigationItem.rightBarButtonItem = backBtn
    }
}

extension UIApplication {
    var sceneDelegate:SceneDelegate? {
        if let dlg =  currentScene?.delegate as? SceneDelegate {
            return dlg
        }
        return nil
    }
    
    func rootViewController()->UIViewController{
        var topMostViewController = UIApplication.shared.sceneDelegate?.window?.rootViewController
        while let presentedViewController = topMostViewController?.presentedViewController {
            topMostViewController = presentedViewController
        }
        return topMostViewController!
    }
    
    
}

extension UIColor {
    
    class func toHex (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}

extension SceneDelegate {
    
    var isFirstTime:Bool{
        set(newVal){
            UserDefaults.standard.set(newVal, forKey: "isFirstTime")
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.bool(forKey: "isFirstTime")
        }
    }
    
}
