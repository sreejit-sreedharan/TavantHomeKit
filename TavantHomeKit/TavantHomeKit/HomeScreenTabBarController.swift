//
//  HomeScreenTabBarController.swift
//  TavantHomeKit
//
//  Created by administrator on 02/07/15.
//  Copyright © 2015 tavant_sreejit. All rights reserved.
//

import UIKit
import HomeKit


class HomeScreenTabBarController: UITabBarController,HMHomeManagerDelegate {

    var currentTabController:UITabBarController?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        print("\(self.tabBarController) and  \(currentTabController)")
//        var vCArray = self.viewControllers!
//        let selectedTabIndex = self.tabBarController!.selectedIndex
//        let selectedTabBarItem : UITabBarItem = self.tabBar.items![selectedTabIndex]
//
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem) {
        if let tabBarItems = tabBar.items, index = tabBarItems.indexOf(item) {
            print(index)
        }
    }
    


}
