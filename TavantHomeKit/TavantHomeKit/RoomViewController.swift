//
//  RoomViewController.swift
//  TavantHomeKit
//
//  Created by administrator on 02/07/15.
//  Copyright © 2015 tavant_sreejit. All rights reserved.
//

import UIKit
import HomeKit

class RoomViewController: UIViewController,HMHomeManagerDelegate,HMAccessoryDelegate {
    
    let cellReuseId:String = "CellID"
    
    //Declare properties here ...
    @IBOutlet weak var roomTableView: UITableView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        homeManager.delegate = self
        // self.addHomeWithName("MyPrimaryHome1")
        roomTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier:cellReuseId)
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return homeObjectModel.rooms.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellReuseId, forIndexPath: indexPath)
        let currentRoom = homeObjectModel.rooms[indexPath.row] as HMRoom
        cell.textLabel?.text = currentRoom.name
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        let controller:UIViewController = UIViewController()
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func tableView(tableView: UITableView,
        commitEditingStyle editingStyle: UITableViewCellEditingStyle,
        forRowAtIndexPath indexPath: NSIndexPath) {
            
            if editingStyle == .Delete{
                
                let roomToBeDeleted = homeObjectModel.rooms[indexPath.row] as HMRoom
                home!.removeRoom(roomToBeDeleted) { error in
                    
                    if error != nil{

                    } else {
                        self.homeObjectModel.remove(roomToBeDeleted)
                        self.roomTableView.reloadData()
                    }
                    
                }
                
            }
            
    }
    

    func addNewRoom() {
        
        // self.addHomeWithName("MyPrimaryHome")
        presentAddAlertWithAttributeType(NSLocalizedString("Room", comment: "Room"),
            placeholder: NSLocalizedString("Living Room", comment: "Living Room")) { roomName in
                self.addRoomWithName(roomName)
        }
        
        
    }
    
    private func addHomeWithName(name: String) {
        homeManager.addHomeWithName(name) { newHome, error in
            if let error = error {
                self.displayError(error)
                return
            }
            self.homeStoreManager.home = newHome
            self.updatePrimaryHome(newHome!)
            self.displayMessage("Home added", message: "\(name)")
        }
        
    }
    
    private func addRoomWithName(name: String) {
        print(home!.rooms)
        home!.addRoomWithName(name) { newRoom, error in
            if let error = error {
                self.displayError(error)
                return
            }
            self.homeObjectModel.append(newRoom!)
            self.roomTableView.reloadData()
        }
    }
    
    // To update the home manager class with the updated homes available
    func homeManagerDidUpdateHomes(manager: HMHomeManager) {
        //Test code for removing a home ...
        //        let homesArray = homeManager.homes
        //        if homesArray.count > 0{
        //            let oldHome = homesArray[0]
        //            self.removeHome(oldHome)
        //        }
        print(manager.primaryHome)
        self.homeStoreManager.home = manager.primaryHome
        //Get list of rooms ...
        if let tempHome:HMHome = home{
            self.homeObjectModel.rooms = tempHome.rooms
        }
        self.roomTableView.reloadData()
        print("Updated Home Manager Successfully")
    }
    
    func removeHome(inHome:HMHome){
        
        homeManager.removeHome(inHome){ error in
            if let error = error {
                self.displayError(error)
                return
            }
        }
    }
}
