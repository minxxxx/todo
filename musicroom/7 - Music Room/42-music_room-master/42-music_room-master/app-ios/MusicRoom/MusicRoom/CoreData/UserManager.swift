//
//  UserManager.swift
//  MusicRoom
//
//  Created by Etienne TRANCHIER on 11/5/18.
//  Copyright © 2018 Etienne Tranchier. All rights reserved.
//


import CoreData
import Foundation

enum LoginType {
    case local, fb, google
}

class UserManager {
    public var context : NSManagedObjectContext
    public var currentUser : MyUser?
    
    public var logedWith : LoginType?
    
    public func newUser() -> MyUser
    {
        var user: MyUser?
        context.performAndWait {
            let ent = NSEntityDescription.entity(forEntityName: "MyUser", in: context)!
            user = MyUser(entity: ent, insertInto: context)
        }
        return user!
    }
    
    private lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let modelUrl: URL = Bundle(for: MyUser.self).url(forResource: "MusicRoom", withExtension: "momd")!
        let managedObjectModel = NSManagedObjectModel(contentsOf: modelUrl)!
        let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
        
        let fileManager = FileManager.default
        let storeName = "MyUser.sqlite"
        
        let documentsDirectoryURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        
        let persistentStoreURL = documentsDirectoryURL.appendingPathComponent(storeName)
        let options = [NSInferMappingModelAutomaticallyOption : true, NSMigratePersistentStoresAutomaticallyOption : true]
        do {
            try persistentStoreCoordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: persistentStoreURL, options: options)
        } catch {
            fatalError("Unable to Load Persistent Store")
        }
        
        return persistentStoreCoordinator
    }()
    
    public init() {
        context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        context.persistentStoreCoordinator = persistentStoreCoordinator
    }
    
    /*public func getArticles(containString str : String) -> [Article]{
        var result : [Article] = []
        context.performAndWait {
            let request = NSFetchRequest<NSFetchRequestResult>(entityName : "Article")
            request.predicate = NSComparisonPredicate(format: "content CONTAINS %@ || titre CONTAINS %@ || langue CONTAINS %@ || image CONTAINS %@ || createdAt CONTAINS %@ || modifyAt CONTAINS %@", str, str, str,str,str,str)
            do {
                result = try context.fetch(request) as! [Article]
            } catch (let err){
                print(err.localizedDescription)
            }
        }
        return result
    }*/
    
    func deleteAllData() {
        let entity = "MyUser"
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let results = try context.fetch(fetchRequest)
            for object in results {
                guard let objectData = object as? NSManagedObject else {continue}
                context.delete(objectData)
            }
        } catch let error {
            print("Detele all data in \(entity) error :", error)
        }
    }
    
    public func getAllUsers() -> [MyUser] {
        var result : [MyUser] = []
        context.performAndWait {
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "MyUser")
            do {
                result = try context.fetch(request) as! [MyUser]
            } catch (let err){
                print(err.localizedDescription)
            }
        }
        return result
    }
    
    public func save() -> Void {
        context.performAndWait {
            do {
                try context.save()
            } catch (let err) {
                print(err.localizedDescription)
            }
        }
    }

    
}
