//
//  DeviceDetailTableViewController.swift
//  TavantHomeKit
//
//  Created by tavant_sreejit on 7/7/15.
//  Copyright © 2015 tavant_sreejit. All rights reserved.
//

import UIKit
import HomeKit

/// Contains a method for notifying the delegate that the accessory was saved.
protocol ModifyAccessoryDelegate {
    func accessoryViewController(accessoryViewController: DeviceDetailViewController, didSaveAccessory accessory: HMAccessory)
}

class DeviceDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, HMAccessoryDelegate,HMHomeDelegate {
    
    // MARK: Properties
    
    // Update this if the acessory failed in any way.
    private var didEncounterError = false
    
    private var selectedIndexPath: NSIndexPath?
    private var selectedRoom: HMRoom!
    
    
    
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var tableview: UITableView!
    private lazy var activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
    
    private let saveAccessoryGroup = dispatch_group_create()
    
    private var editingExistingAccessory = false
    
    // Strong reference, because we will replace the button with an activity indicator.
    @IBOutlet /* strong */ var addButton: UIBarButtonItem!
    var delegate: ModifyAccessoryDelegate?
    let cellID: String = "CellID"
    var rooms = [HMRoom]()
    var accessory: HMAccessory!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        selectedRoom = accessory.room ?? home.roomForEntireHome()
        // If the accessory belongs to the home already, we are in 'edit' mode.
        editingExistingAccessory = accessoryHasBeenAddedToHome()
        if editingExistingAccessory {
            // Show 'save' instead of 'add.'
            addButton.title = NSLocalizedString("Save", comment: "Save")
        }
        else {
            /*
            If we're not editing an existing accessory, then let the back
            button show in the left.
            */
            navigationItem.leftBarButtonItem = nil
        }
        
        // Put the accessory's name in the 'name' field.
        resetNameField()
        
         // Register a cell for the rooms.
        tableview.registerClass(UITableViewCell.self, forCellReuseIdentifier: cellID)
        
        home?.delegate = self
        accessory.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    /// Replaces the activity indicator with the 'Add' or 'Save' button.
    func hideActivityIndicator() {
        activityIndicator.stopAnimating()
        navigationItem.rightBarButtonItem = addButton
    }
    
    /// Temporarily replaces the 'Add' or 'Save' button with an activity indicator.
    func showActivityIndicator() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: activityIndicator)
        activityIndicator.startAnimating()
    }
    */
    
    /**
    Called whenever the user taps the 'add' button.
    
    This method:
    1. Adds the accessory to the home, if not already added.
    2. Updates the accessory's name, if necessary.
    3. Assigns the accessory to the selected room, if necessary.
    */
    @IBAction func didTapAddButton() {
        let name = trimmedName
//        showActivityIndicator()
        
        if editingExistingAccessory {
            home(home, assignAccessory: accessory, toRoom: selectedRoom)
            updateName(name, forAccessory: accessory)
        }
        else {
            dispatch_group_enter(saveAccessoryGroup)
            home.addAccessory(accessory) { error in
                if let error = error {
//                    self.hideActivityIndicator()
                    self.displayError(error)
                    self.didEncounterError = true
                }
                else {
                    // Once it's successfully added to the home, add it to the room that's selected.
                    self.home(self.home, assignAccessory:self.accessory, toRoom: self.selectedRoom)
                    self.updateName(name, forAccessory: self.accessory)
                }
                dispatch_group_leave(self.saveAccessoryGroup)
            }
        }
        
        dispatch_group_notify(saveAccessoryGroup, dispatch_get_main_queue()) {
//            self.hideActivityIndicator()
            if !self.didEncounterError {
                self.dismiss(nil)
            }
        }
    }
    
    /**
    Informs the delegate that the accessory has been saved, and
    dismisses the view controller.
    */
    @IBAction func dismiss(sender: AnyObject?) {
        delegate?.accessoryViewController(self, didSaveAccessory: accessory)
        if editingExistingAccessory {
            presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
        }
        else {
            navigationController?.popViewControllerAnimated(true)
        }
    }
    
    /**
    - returns: `true` if the accessory has already been added to
    the home; `false` otherwise.
    */
    func accessoryHasBeenAddedToHome() -> Bool {
        return home.accessories.contains(accessory)
    }
    
    /**
    Updates the accessories name. This function will enter and leave the saved dispatch group.
    If the accessory's name is already equal to the passed-in name, this method does nothing.
    
    - parameter name:      The new name for the accessory.
    - parameter accessory: The accessory to rename.
    */
    func updateName(name: String, forAccessory accessory: HMAccessory) {
        if accessory.name == name {
            return
        }
        dispatch_group_enter(saveAccessoryGroup)
        accessory.updateName(name) { error in
            if let error = error {
                self.displayError(error)
                self.didEncounterError = true
            }
            dispatch_group_leave(self.saveAccessoryGroup)
        }
    }
    
    /**
    Assigns the given accessory to the provided room. This method will enter and leave the saved dispatch group.
    
    - parameter home:      The home to assign.
    - parameter accessory: The accessory to be assigned.
    - parameter room:      The room to which to assign the accessory.
    */
    func home(home: HMHome, assignAccessory accessory: HMAccessory, toRoom room: HMRoom) {
        if accessory.room == room {
            return
        }
        dispatch_group_enter(saveAccessoryGroup)
        home.assignAccessory(accessory, toRoom: room) { error in
            if let error = error {
                self.displayError(error)
                self.didEncounterError = true
            }
            dispatch_group_leave(self.saveAccessoryGroup)
        }
    }
    
    /// Tells the current accessory to identify itself.
    func identifyAccessory() {
        accessory.identifyWithCompletionHandler { error in
            if let error = error {
                self.displayError(error)
            }
        }
    }
    
    /// Enables the name field if the accessory's name changes.
    func resetNameField() {
        var action: String
        if editingExistingAccessory {
            action = NSLocalizedString("Edit %@", comment: "Edit Accessory")
        }
        else {
            action = NSLocalizedString("Add %@", comment: "Add Accessory")
        }
        navigationItem.title = NSString(format: action, accessory.name) as String
        nameField.text = accessory.name
        nameField.enabled = home.isAdmin
        enableAddButtonIfApplicable()
    }
    
    /// Enables the save button if the name field is not empty.
    func enableAddButtonIfApplicable() {
        addButton.enabled = home.isAdmin && trimmedName.characters.count > 0
    }
    
    /// - returns:  The `nameField`'s text, trimmed of newline and whitespace characters.
    var trimmedName: String {
        return nameField.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
    }
    
    /// Enables or disables the add button.
    @IBAction func nameFieldDidChange(sender: AnyObject) {
        enableAddButtonIfApplicable()
    }
    
    
    
    // MARK: - Table view data source

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return rooms.count
    }

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let roomData:HMRoom = rooms[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier(cellID, forIndexPath: indexPath)
        // Configure the cell...
//        cell.textLabel?.text="TEST";
        cell.textLabel?.text=roomData.name;

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
