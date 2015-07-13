//
//  RZViewController.swift
//  TavantHomeKit
//
//  Created by administrator on 08/07/15.
//  Copyright © 2015 tavant_sreejit. All rights reserved.
//

import UIKit

class RZViewController: CustomSegmentController {

    
    var isRoom:Bool = true
    var roomScreen:RoomViewController?
    var zoneScreen:ZonesViewController?
    
    override func viewDidLoad() {
        
        let tempPageController:UIPageViewController = UIPageViewController(transitionStyle: .Scroll,navigationOrientation: .Horizontal,options: nil)
        self.viewControllers = [tempPageController]
        
        if roomScreen == nil{
            let roomScreenStoryboard : UIStoryboard = UIStoryboard(name: "RoomStoryboard", bundle: nil)
            roomScreen = roomScreenStoryboard.instantiateViewControllerWithIdentifier("RoomStoryBoardID") as? RoomViewController
        }
        
        if zoneScreen == nil{
            let zoneScreenStoryboard : UIStoryboard = UIStoryboard(name: "ZonesStoryboard", bundle: nil)
            zoneScreen = zoneScreenStoryboard.instantiateViewControllerWithIdentifier("ZoneStoryBoardID") as? ZonesViewController
        }
        
        super.viewDidLoad()
        
        print(self.navigationController)
        
        self.title = "Rooms+Zones"
         self.pageController = tempPageController
        self.viewControllerArray = [roomScreen!,zoneScreen!]
        self.buttonText = ["Rooms","Zones"]
        
        print(self)
        
        self.navigationBar.backgroundColor = UIColor.blueColor()
        
        tempPageController.navigationController!.navigationBar.barTintColor = UIColor(red: 249/255, green: 249/255, blue: 249/255, alpha: 1.0)
        tempPageController.navigationItem.title = "Rooms+Zones"
        let addButton:UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "addButtonPressed")
        tempPageController.navigationItem.rightBarButtonItem = addButton;
        

        // Do any additional setup after loading the view.
    }

    override func updateCurrentPageIndex(newIndex:NSInteger){
        super.updateCurrentPageIndex(newIndex)
        isRoom = (newIndex == 0) ? true:false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addButtonPressed(){
        if isRoom == true{
            //Add Room code goes here
            roomScreen?.addNewRoom()
        }
        else{
            //Add Zone code goes here
        }
    }

    func didUpdateTheCurrentPageIndex(inIndex:NSNumber){
        if inIndex == 0{
            isRoom = true
        }
        else{
            isRoom = false
        }
        
    }

}
