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
        
        roomTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier:cellReuseId)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 15
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellReuseId, forIndexPath: indexPath)
        
        cell.textLabel?.text = "Room"
        
        return cell
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func addNewHomeButtonPressed(sender: AnyObject) {
 
        self.addHomeWithName("MyPrimaryHome")
    }
    
    private func addHomeWithName(name: String) {
        homeManager.addHomeWithName(name) { newHome, error in
            if let error = error {
                self.displayError(error)
                return
            }
            self.updatePrimaryHome(newHome!)
            self.displayMessage("Home added", message: "\(name)")
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
