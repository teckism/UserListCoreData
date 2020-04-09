//
//  UsersListDataController.swift
//  StockList
//
//  Created by Pankaj Teckchandani on 09/04/20.
//  Copyright © 2020 Pankaj Teckchandani. All rights reserved.
//

import UIKit
import CoreData


class UsersListDataController: NSObject {
    
    private var arrayOfUsers : [SLUser]?
    private(set) var arrayOfUsersFiltered : [SLUser]?
    
    /**
     Interacts with the APIManager and maps the respective data received from server into objects
     */
    
    func getListOfUsers( onSuccess:@escaping ()->Void , onFailure:@escaping (_ result: String)->Void)
    {
        //Adding any parameters in to be added in the api
        let params : [String : Any ] = [:]
        
        APIManager.sharedInstance.postRequestForPersonList(params: params as NSDictionary, onSuccess: { (responseFromServer) in
            
            var dictFromServer : [String : Any] = [:]
            
            dictFromServer =  try! JSONSerialization.jsonObject(with: responseFromServer, options: .allowFragments) as! [String : Any]
            let arrayFromServer = dictFromServer["users"] as? [[String : Any]] ?? []
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .useDefaultKeys
            
            var users : [SLUser] = []
            for user in arrayFromServer {
                guard let archivedUser = try? decoder.decode(SLUser.self, from: try!  JSONSerialization.data(withJSONObject: user, options: .prettyPrinted))
                    else {
                        return
                }
                users.append(archivedUser)
                
            }
            self.arrayOfUsers = users
            self.arrayOfUsersFiltered = users
            self.updateUsersInDB()
            
            onSuccess()
            
        }) { (error) in
            onFailure(error.userInfo[NSLocalizedDescriptionKey] as! String);
        };
        
    }
    
    
    func performFilter(searchText : String){
        
        //Count > 2 after trimming to search only if more than 2 characters are inserted
        
        if searchText.trim().count <= 2 {
            self.arrayOfUsersFiltered = self.arrayOfUsers
        }
        else{
            
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Blacklisted")
            
            do {
                let results = try context.fetch(fetchRequest)
                let  blacklistedObjects = results as! [Blacklisted]
                
                if blacklistedObjects.filter({$0.text?.uppercased() == searchText.uppercased()}).count > 0 {
                    //string is blacklisted
                    self.arrayOfUsersFiltered?.removeAll()
                }
                else{
                    //string is not blacklisted.
                    //perform search
                    
                    
                    self.arrayOfUsersFiltered = self.arrayOfUsers?.filter({($0.displayName?.uppercased().contains(searchText.uppercased()) ?? false)})
                    
                    if self.arrayOfUsersFiltered?.count == 0 {
                        //add the object in blacklisted if no user is find with the search query provided
                        let entity = NSEntityDescription.entity(forEntityName: "Blacklisted", in: context)
                        let newBlacklistedObject = NSManagedObject(entity: entity!, insertInto: context)
                        newBlacklistedObject.setValue(searchText, forKey: "text")
                        try context.save()
                    }
                }
                
            }catch let err as NSError {
                print(err.debugDescription)
            }
        }
    }
    
    
    
    /**
     Insert/Updates Users in core data
     */
    private func updateUsersInDB(){
        
        DispatchQueue.main.async {
   
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            context.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
            
            
            DispatchQueue.global(qos: .background).async {
                context.perform {
                    let entity = NSEntityDescription.entity(forEntityName: "User", in: context)
                    do {
                        
                        for userObj in self.arrayOfUsers ?? [] {
                            
                            let newUserObject = NSManagedObject(entity: entity!, insertInto: context)
                            newUserObject.setValue(userObj.id, forKey: "id")
                            newUserObject.setValue(userObj.displayName, forKey: "displayName")
                            newUserObject.setValue(userObj.avatarUrl, forKey: "image")
                            newUserObject.setValue(userObj.username, forKey: "username")
                        }
                        
                        try context.save()
                    }catch let err as NSError {
                        print(err.debugDescription)
                    }
                }
            }
        }
    }
    
    
    
    
    /**
     fetches Users from core data and maps them into the array of  NSObject (SLUser)  class .
     */
    func performOfflineDataFetch(){
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        
        do{
            let results = try context.fetch(fetchRequest)
            let  userObjectsInDB = results as! [User]
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .useDefaultKeys
            
            
            var userObjs : [SLUser] = []
            for userObject in userObjectsInDB {
                
                var dict : [String : Any] = [:]
                dict["id"] = userObject.id
                dict["avatar_url"] = userObject.image
                dict["display_name"] = userObject.displayName
                dict["username"] = userObject.username
                
                
                guard let archivedUser = try? decoder.decode(SLUser.self, from: try!  JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted))
                    else {
                        return
                }
                
                
                userObjs.append(archivedUser)
            }
            
            self.arrayOfUsers = userObjs
            self.arrayOfUsersFiltered = userObjs
            
        }
        catch let err as NSError {
            print(err.debugDescription)
        }
    }
}
