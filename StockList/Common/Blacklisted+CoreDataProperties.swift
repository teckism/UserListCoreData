//
//  Blacklisted+CoreDataProperties.swift
//  
//
//  Created by Pankaj Teckchandani on 09/04/20.
//
//

import Foundation
import CoreData


extension Blacklisted {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Blacklisted> {
        return NSFetchRequest<Blacklisted>(entityName: "Blacklisted")
    }

    @NSManaged public var text: String?

}
