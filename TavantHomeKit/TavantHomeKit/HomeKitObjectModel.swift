//
//  HomeKitObjectModel.swift
//  TavantHomeKit
//
//  Created by administrator on 07/07/15.
//  Copyright © 2015 tavant_sreejit. All rights reserved.
//

import HomeKit

/// Represents the all different types of HomeKit objects.
enum HomeKitObjectSection: Int {
    case Accessory, Room, Zone
    
    static let count = 3
}

/**
Manages internal lists of HomeKit objects to allow for
save insertion into a table view.
*/
class HomeKitObjectModel {
    // MARK: Properties
    
    static let sharedManager = HomeKitObjectModel()
    
    var accessories = [HMAccessory]()
    var rooms = [HMRoom]()
    var zones = [HMZone]()
    
    /**
    Adds an object to the collection by finding its corresponding
    array and appending the object to it.
    
    - parameter object: The HomeKit object to append.
    */
    func append(object: AnyObject) {
        switch object {
        case let accessory as HMAccessory:
            accessories.append(accessory)
            accessories = accessories.sortByLocalizedName()
            
        case let room as HMRoom:
            rooms.append(room)
            rooms = rooms.sortByLocalizedName()
            
        case let zone as HMZone:
            zones.append(zone)
            zones = zones.sortByLocalizedName()

        default:
            break
        }
        print(self.rooms)
    }
    
    /**
    Creates an `NSIndexPath` representing the location of the
    HomeKit object in the table view.
    
    - parameter object: The HomeKit object to find.
    
    - returns:  The `NSIndexPath` representing the location of
    the HomeKit object in the table view.
    */
    func indexPathOfObject(object: AnyObject) -> NSIndexPath? {
        switch object {

        case let accessory as HMAccessory:
            if let index = accessories.indexOf(accessory) {
                return NSIndexPath(forRow: index, inSection: HomeKitObjectSection.Accessory.rawValue)
            }
            
        case let room as HMRoom:
            if let index = rooms.indexOf(room) {
                return NSIndexPath(forRow: index, inSection: HomeKitObjectSection.Room.rawValue)
            }
            
        case let zone as HMZone:
            if let index = zones.indexOf(zone) {
                return NSIndexPath(forRow: index, inSection: HomeKitObjectSection.Zone.rawValue)
            }

        default: break
        }
        
        return nil
    }
    
    /**
    Removes a HomeKit object from the collection.
    
    - parameter object: The HomeKit object to remove.
    */
    func remove(object: AnyObject) {
        switch object {
        case let accessory as HMAccessory:
            if let index = accessories.indexOf(accessory) {
                accessories.removeAtIndex(index)
            }
            
        case let room as HMRoom:
            if let index = rooms.indexOf(room) {
                rooms.removeAtIndex(index)
            }
            
        case let zone as HMZone:
            if let index = zones.indexOf(zone) {
                zones.removeAtIndex(index)
            }

        default:
            break
        }
    }
    
    /**
    Provides the array of `NSObject`s corresponding to the provided section.
    
    - parameter section: A `HomeKitObjectSection`.
    
    - returns:  An array of `NSObject`s corresponding to the provided section.
    */
    func objectsForSection(section: HomeKitObjectSection) -> [NSObject] {
        switch section {
        case .Accessory:
            return accessories
            
        case .Room:
            return rooms
            
        case .Zone:
            return zones
            
        default:
            return []
        }
    }
    
    /**
    Provides an `HomeKitObjectSection` for a given object.
    
    - parameter object: A HomeKit object.
    
    - returns:  The corrosponding `HomeKitObjectSection`
    */
    class func sectionForObject(object: AnyObject?) -> HomeKitObjectSection? {
        switch object {
        case is HMAccessory:
            return .Accessory
            
        case is HMZone:
            return .Zone
            
        case is HMRoom:
            return .Room
    
        default:
            return nil
        }
    }
}

