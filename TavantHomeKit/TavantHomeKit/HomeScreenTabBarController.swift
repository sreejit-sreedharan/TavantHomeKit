//
//  HomeScreenTabBarController.swift
//  TavantHomeKit
//
//  Created by administrator on 02/07/15.
//  Copyright © 2015 tavant_sreejit. All rights reserved.
//

import UIKit
import HomeKit


class HomeScreenTabBarController: UITabBarController,HMHomeManagerDelegate,UITabBarControllerDelegate {

    var currentTabController:UIViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let RZNavScreenStoryboard : UIStoryboard = UIStoryboard(name: "Rooms+ZonesStoryboard", bundle: nil)
        
        let RZView :RZViewController = RZNavScreenStoryboard.instantiateViewControllerWithIdentifier("RZViewStoryboardID") as! RZViewController
        
        let deviceScreenStoryboard : UIStoryboard = UIStoryboard(name: "DeviceStoryboard", bundle: nil)
        let deviceScreen : UINavigationController = deviceScreenStoryboard.instantiateViewControllerWithIdentifier("DeviceStoryboardID") as! UINavigationController
        self.viewControllers = [deviceScreen,RZView]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem) {
        if let tabBarItems = tabBar.items, index = tabBarItems.indexOf(item) {
            print(index)
        }
    }

}
