//
//  User+CoreDataProperties.swift
//  
//
//  Created by Pankaj Teckchandani on 12/04/20.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var displayName: String?
    @NSManaged public var id: Int32
    @NSManaged public var image: String?
    @NSManaged public var username: String?

}
