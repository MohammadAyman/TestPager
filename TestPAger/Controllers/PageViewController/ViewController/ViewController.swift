//
//  ViewController.swift
//  TestPAger
//
//  Created by Mac on 8/31/22.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var descriptionLbl1: UILabel!
    @IBOutlet weak var descriptionLbl2: UILabel!
    @IBOutlet weak var mainPhoto: UIImageView!
    @IBOutlet weak var dismisBtn: UIButton!
    @IBOutlet weak var letGoBtn: UIButton!
    var pageData : PageData?
    var arryLbl = [UILabel]()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupData()
        setupView()
        localized()
        fetchData()
    }
    
    func setupView(){
        
    }
    func localized(){}
    func setupData(){
        arryLbl = [descriptionLbl ,descriptionLbl1 , descriptionLbl2 ]
        confinViewController()
    }
    func fetchData(){
    }
    
    @IBAction func dismisBtnClicked(_ sender: UIButton) {
        WelcomeViewController.presentRootViewController()
    }
}
extension ViewController {
    
    func confinViewController(){
        titleLbl.text = pageData?.title
        mainPhoto.image = UIImage(named: pageData?.imgName ?? "")
        letGoBtn.isHidden = !(pageData?.pageNumber == 2)
        dismisBtn.isEnabled = !(pageData?.pageNumber == 2)
        dismisBtn.alpha = pageData?.pageNumber == 2 ? 0 : 1
        if let arryTxet = pageData?.description?.components(separatedBy: ",") {
            arryLbl.last?.alpha = arryTxet.count == 2 ? 0 : 1
            for item in 1...arryTxet.count-1{
                arryLbl[item].text = arryTxet[item]
            }
        }
    }
}

struct PageData{
    var title:String?
    var description :String?
    var imgName :String?
    var pageNumber:Int?
    }
