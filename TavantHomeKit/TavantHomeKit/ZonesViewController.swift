//
//  ZonesViewController.swift
//  TavantHomeKit
//
//  Created by administrator on 08/07/15.
//  Copyright © 2015 tavant_sreejit. All rights reserved.
//

import UIKit

class ZonesViewController: UIViewController {

    let cellReuseId:String = "CellID"
    @IBOutlet weak var zoneTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        zoneTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier:cellReuseId)
        //self.view.backgroundColor = UIColor.redColor()
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
        return 15
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellReuseId, forIndexPath: indexPath)
        //let currentRoom = homeObjectModel.rooms[indexPath.row] as HMRoom
        cell.textLabel?.text = "test"
        
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

}
