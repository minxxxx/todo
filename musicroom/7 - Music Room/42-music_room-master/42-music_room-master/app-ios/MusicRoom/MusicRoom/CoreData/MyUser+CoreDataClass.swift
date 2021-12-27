//
//  User+CoreDataClass.swift
//  MusicRoom
//
//  Created by Etienne TRANCHIER on 11/5/18.
//  Copyright © 2018 Etienne Tranchier. All rights reserved.
//
//

import Foundation
import CoreData

public class MyUser: NSManagedObject {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<MyUser> {
        return NSFetchRequest<MyUser>(entityName: "MyUser")
    }
    
    @NSManaged public var login: String?
    @NSManaged public var token: String?
    @NSManaged public var deezer_token: String?

}
