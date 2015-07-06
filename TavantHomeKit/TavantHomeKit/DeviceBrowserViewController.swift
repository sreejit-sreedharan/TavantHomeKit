//
//  DeviceBrowserViewController.swift
//  TavantHomeKit
//
//  Created by tavant_sreejit on 7/6/15.
//  Copyright © 2015 tavant_sreejit. All rights reserved.
//

import UIKit
import HomeKit
import ExternalAccessory

/// Represents an accessory type and encapsulated accessory.
enum AccessoryType: Equatable, Nameable {
    /// A HomeKit object
    case HomeKit(accessory: HMAccessory)
    
    /// An external, `EAWiFiUnconfiguredAccessory` object
    case External(accessory: EAWiFiUnconfiguredAccessory)
    
    /// The name of the accessory.
    var name: String {
        return accessory.name
    }
    
    /// The accessory within the `AccessoryType`.
    var accessory: AnyObject {
        switch self {
        case .HomeKit(let accessory):
            return accessory
            
        case .External(let accessory):
            return accessory
        }
    }
}

/// Comparison of `AccessoryType`s based on name.
func ==(lhs: AccessoryType, rhs: AccessoryType) -> Bool {
    return lhs.name == rhs.name
}


class DeviceBrowserViewController: UIViewController,HMAccessoryBrowserDelegate,UITableViewDataSource,UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    let cellReuseId:String = "CellID"
    
    let accessoryBrowser:HMAccessoryBrowser = HMAccessoryBrowser();
    
    var addedAccessories = [HMAccessory]()
    var displayedAccessories = [AccessoryType]()
    var externalAccessoryBrowser: EAWiFiUnconfiguredAccessoryBrowser?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier:cellReuseId)
        
        accessoryBrowser.delegate = self
        accessoryBrowser.startSearchingForNewAccessories()
        externalAccessoryBrowser?.startSearchingForUnconfiguredAccessoriesMatchingPredicate(nil)
    }

    /// Reloads the view.
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        reloadTable()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        accessoryBrowser.stopSearchingForNewAccessories()
        externalAccessoryBrowser?.stopSearchingForUnconfiguredAccessories()
    }
    
    
    // MARK: Table View Methods
    
    /**
    Generates the number of rows based on the number of displayed accessories.
    
    This method will also display a table view background message, if required.
    
    - returns:  The number of rows based on the number of displayed accessories.
    */
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let rows = displayedAccessories.count
        
        if rows == 0 {
            let message = NSLocalizedString("No Discovered Accessories", comment: "No Discovered Accessories")
            setBackgroundMessage(message)
        }
        else {
            setBackgroundMessage(nil)
        }
        
        return rows
    }
    
    /**
    - returns:  Creates a cell that lists an accessory, and if it hasn't been added to the home,
    shows a disclosure indicator instead of a checkmark.
    */
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let accessoryType = displayedAccessories[indexPath.row]
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellReuseId, forIndexPath: indexPath)
//        cell.textLabel?.text = "Device \(indexPath.row + 1)"
        cell.textLabel?.text = accessoryType.name
//        cell.detailTextLabel?.text = accessory.category.localizedDescription
        return cell
        
        
        /*
        let accessoryType = displayedAccessories[indexPath.row]
        
        var reuseIdentifier = Identifiers.accessoryCell
        
        if case let .HomeKit(hmAccessory) = accessoryType where addedAccessories.contains(hmAccessory) {
            reuseIdentifier = Identifiers.addedAccessoryCell
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier, forIndexPath: indexPath)
        cell.textLabel?.text = accessoryType.name
        
        if let accessory = accessoryType.accessory as? HMAccessory {
            cell.detailTextLabel?.text = accessory.category.localizedDescription
        }
        else {
            cell.detailTextLabel?.text = NSLocalizedString("External Accessory", comment: "External Accessory")
        }
        */
        
        return cell
    }
    
    /// Configures the accessory based on its type.
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        switch displayedAccessories[indexPath.row] {
//        case .HomeKit(let accessory):
//            configureAccessory(accessory)
//            
//        case .External(let accessory):
//            externalAccessoryBrowser?.configureAccessory(accessory, withConfigurationUIOnViewController: self)
//        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    func setBackgroundMessage(message: String?) {
        if let message = message {
            // Display a message when the table is empty
            let messageLabel = UILabel()
            
            messageLabel.text = message
            messageLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
            messageLabel.textColor = UIColor.lightGrayColor()
            messageLabel.textAlignment = .Center
            messageLabel.sizeToFit()
            
            tableView.backgroundView = messageLabel
            tableView.separatorStyle = .None
        }
        else {
            tableView.backgroundView = nil
            tableView.separatorStyle = .SingleLine
        }
    }
    
    
    /**
    Inserts the accessory into the internal array and inserts the
    row into the table view.
    */
    func accessoryBrowser(browser: HMAccessoryBrowser, didFindNewAccessory accessory: HMAccessory) {
        let newAccessory = AccessoryType.HomeKit(accessory: accessory)
        if displayedAccessories.contains(newAccessory)  {
            return
        }
        displayedAccessories.append(newAccessory)
        displayedAccessories = displayedAccessories.sortByLocalizedName()
        
        if let newIndex = displayedAccessories.indexOf(newAccessory) {
            let newIndexPath = NSIndexPath(forRow: newIndex, inSection: 0)
            tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Automatic)
        }
    }
    
    
    /**
    Concatenates and sorts the discovered and added accessories.
    
    - returns:  A sorted list of all accessories involved with this
    browser session.
    */
    func allAccessories() -> [AccessoryType] {
        var accessories = [AccessoryType]()
        accessories += accessoryBrowser.discoveredAccessories.map { .HomeKit(accessory: $0) }
        
        accessories += addedAccessories.flatMap { addedAccessory in
            let accessoryType = AccessoryType.HomeKit(accessory: addedAccessory)
            
            return accessories.contains(accessoryType) ? nil : accessoryType
        }
        
        if let external = externalAccessoryBrowser?.unconfiguredAccessories {
            let unconfiguredAccessoriesArray = Array(external)
            
            accessories += unconfiguredAccessoriesArray.flatMap { addedAccessory in
                let accessoryType = AccessoryType.External(accessory: addedAccessory)
                
                return accessories.contains(accessoryType) ? nil : accessoryType
            }
        }
        
        return accessories.sortByLocalizedName()
    }
    
    /// Updates the displayed accesories array and reloads the table view.
    private func reloadTable() {
        displayedAccessories = allAccessories()
        tableView.reloadData()
    }
    
}
