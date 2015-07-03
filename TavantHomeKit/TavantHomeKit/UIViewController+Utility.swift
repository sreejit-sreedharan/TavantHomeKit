//
//  UIViewController+Utility.swift
//  TavantHomeKit
//
//  Created by administrator on 03/07/15.
//  Copyright © 2015 tavant_sreejit. All rights reserved.
//

import Foundation
import UIKit
import HomeKit

extension UIViewController{
    
    //var homes = [HMHome]()
    
    var homeStoreManager: HomeStoreManager {
        return HomeStoreManager.sharedStoreManager
    }
    
    var homeManager: HMHomeManager {
        return homeStoreManager.homeManager
    }
    
    func displayError(error: NSError) {
        if let errorCode = HMErrorCode(rawValue: error.code) {
            if self.presentedViewController != nil || errorCode == .OperationCancelled || errorCode == .UserDeclinedAddingUser {
                print(error.localizedDescription)
            }
            else {
                self.displayErrorMessage(error.localizedDescription)
            }
        }
        else {
            self.displayErrorMessage(error.description)
        }
    }
    
    private func displayErrorMessage(message: String) {
        let errorTitle = NSLocalizedString("Error", comment: "Error")
        displayMessage(errorTitle, message: message)
    }
    
    func displayMessage(title: String, message: String) {
        dispatch_async(dispatch_get_main_queue()) {
            let alert = UIAlertController(title: title, message: message, preferredStyle:UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Cancel, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    func updatePrimaryHome(newPrimaryHome: HMHome) {
        guard newPrimaryHome != homeManager.primaryHome else { return }
        
        homeManager.updatePrimaryHome(newPrimaryHome) { error in
            if let error = error {
                self.displayError(error)
                return
            }
            
            //self.didUpdatePrimaryHome()
        }
    }
    
}