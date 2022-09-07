//
//  TabBarViewController.swift
//  TestPAger
//
//  Created by MacOS on 06/09/2022.
//

import UIKit

class TabBarViewController: UITabBarController   {
    
    var arryViews  = [UIView]()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup afterding the view.
        selectedIndex = 3
 
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
        if let tabBarItems = self.tabBar.items {
            for item in tabBarItems {
                item.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -10.0)
                item.imageInsets.top = -10
            }
        }
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        var tabFrame            = tabBar.frame
        tabFrame.size.height    = 60
        tabFrame.origin.y       = view.frame.size.height - 100
        tabFrame.size.width     = tabFrame.size.width - 80
        tabFrame.origin.x       = tabFrame.origin.x + 40
        tabBar.frame            = tabFrame
        self.tabBar.cornerRadius = tabFrame.size.height / 2
    }

}
extension TabBarViewController : UITabBarControllerDelegate {
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {



    }
}
