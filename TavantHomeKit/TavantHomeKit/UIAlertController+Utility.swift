//
//  UIAlertController+Utility.swift
//  TavantHomeKit
//
//  Created by administrator on 06/07/15.
//  Copyright © 2015 tavant_sreejit. All rights reserved.
//

import Foundation
import UIKit

extension UIAlertController{
    convenience init(attributeType: String, completionHandler: (name: String) -> Void, var placeholder: String? = nil, var shortType: String? = nil) {
        if placeholder == nil {
            placeholder = attributeType
        }
        if shortType == nil {
            shortType = attributeType
        }
        let title = NSLocalizedString("New", comment: "New") + " \(attributeType)"
        let message = NSLocalizedString("Enter a name.", comment: "Enter a name.")
        self.init(title: title, message: message, preferredStyle: .Alert)
        self.addTextFieldWithConfigurationHandler { textField in
            textField.placeholder = placeholder
            textField.autocapitalizationType = .Words
        }
        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: "Cancel"), style: .Cancel) { action in
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        let add = NSLocalizedString("Add", comment: "Add")
        let addString = "\(add) \(shortType!)"
        let addNewObject = UIAlertAction(title: addString, style: .Default) { action in
            if let name = self.textFields!.first!.text {
                let trimmedName = name.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
                completionHandler(name: trimmedName)
            }
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        self.addAction(cancelAction)
        self.addAction(addNewObject)
    }
    

    convenience init(title: String, body: String) {
        self.init(title: title, message: body, preferredStyle: .Alert)
        let okayAction = UIAlertAction(title: NSLocalizedString("Okay", comment: "Okay"), style: .Default) { action in
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        self.addAction(okayAction)
    }

}