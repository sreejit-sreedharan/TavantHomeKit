//
//  DeviceViewController.swift
//  TavantHomeKit
//
//  Created by administrator on 03/07/15.
//  Copyright © 2015 tavant_sreejit. All rights reserved.
//

import UIKit

class DeviceViewController: UIViewController {

    let cellReuseId:String = "CellID"
    @IBOutlet weak var devicesTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        devicesTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier:cellReuseId)
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
        
        cell.textLabel?.text = "Device \(indexPath.row + 1)"
        
        return cell
    }

    @IBAction func addDeviceButtonPressed(sender: AnyObject) {
        let deviceStoryboard : UIStoryboard = UIStoryboard(name: "DeviceStoryboard", bundle: nil)
        let deviceBrowserVC : DeviceBrowserViewController = deviceStoryboard.instantiateViewControllerWithIdentifier("DeviceBrowserViewController") as! DeviceBrowserViewController
        self.navigationController?.pushViewController(deviceBrowserVC, animated: true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
