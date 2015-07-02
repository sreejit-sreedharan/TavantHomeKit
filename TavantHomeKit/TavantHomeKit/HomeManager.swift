//
//  HomeManager.swift
//  TavantHomeKit
//
//  Created by administrator on 02/07/15.
//  Copyright © 2015 tavant_sreejit. All rights reserved.
//

import HomeKit

class HomeStore: NSObject, HMHomeManagerDelegate {
    static let sharedStore = HomeStore()
    
    var home: HMHome?
    
    var homeManager = HMHomeManager()
}

