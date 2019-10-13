//
//  UserModel.swift
//  Crash Box
//
//  Created by Sarvad shetty on 10/12/19.
//  Copyright © 2019 Sarvad shetty. All rights reserved.
//

import Foundation
import FirebaseAuth


class User {
    
    //MARK: - Variables
    var emailId:String!
    var password:String!
    var uuid:String! = ""
    var name:String!
    var bloodGroup:String!
    var contact1:String!
    var contact2:String!
    var contact3:String!
    
    //MARK: - Dependency injection
    init(_ withEmail:String, _ withPassword:String,_ withName:String,_ withBG:String,_ withC1:String,_ withC2:String,_ withC3:String) {
        //while registering
        self.emailId = withEmail
        self.password = withPassword
        self.uuid = ""
        self.name = withName
        self.bloodGroup = withBG
        self.contact1 = withC1
        self.contact2 = withC2
        self.contact3 = withC3
        
    }
    
    init(_ Email:String,_ pass:String) {
        //while logging
        self.emailId = Email
        self.password = pass
        self.uuid = ""
        self.name = ""
        self.bloodGroup = ""
        self.contact1 = ""
        self.contact2 = ""
        self.contact3 = ""
    }
    
    //MARK: - Functions
     func save() {
        let emailValue = self.emailId
        let passValue = self.password
        let uuidValue = self.uuid
        
        let userDict:[String:String] = ["email":emailValue!,"pass":passValue!,"uuid":uuidValue!]
        UserDefaults.standard.set(userDict, forKey: UserObjKey)
    }
    
    func Register(stat:@escaping(_ status:String) -> Void){
        Auth.auth().createUser(withEmail: self.emailId, password: self.password) { (user, error) in
            if error != nil {
                let alertController = UIAlertController(title: "Error", message: "\(String(describing: error!.localizedDescription))", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                
                var rootViewController = UIApplication.shared.keyWindow?.rootViewController
                if let navigationController = rootViewController as? UINavigationController {
                    rootViewController = navigationController.viewControllers.first
                }
                if let tabBarController = rootViewController as? UITabBarController {
                    rootViewController = tabBarController.selectedViewController
                }
                rootViewController?.present(alertController, animated: true, completion: nil)
                stat("notCreated")
            } else {
                //user sucessfully created
                let userId = user?.user.uid
                self.uuid = userId
                let userDict:[String:String] = ["email":self.emailId!,"uuid":userId!,"name":self.name,"bloodGroup":self.bloodGroup,"c1":self.contact1,"c2":self.contact2,"c3":self.contact3]
                UserDefaults.standard.set(userId, forKey: "uid")
                //persist
                let dbData:[String:String] = ["email":self.emailId!,"uuid":userId!,"pass":self.password,"name":self.name,"bloodGroup":self.bloodGroup,"c1":self.contact1,"c2":self.contact2,"c3":self.contact3]
                UserDefaults.standard.set(dbData, forKey: UserObjKey)
                //save to db
                DataService.dataService.createNewAccount(uid: userId!, user: userDict)
                stat("created")
            }
        }
    }
    
    func login(stat:@escaping(_ status:String) -> Void) {
        Auth.auth().signIn(withEmail: self.emailId!, password: self.password!) { (user, error) in
            if error != nil {
                let alertController = UIAlertController(title: "Error", message: "\(String(describing: error!.localizedDescription))", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                
                var rootViewController = UIApplication.shared.keyWindow?.rootViewController
                if let navigationController = rootViewController as? UINavigationController {
                    rootViewController = navigationController.viewControllers.first
                }
                if let tabBarController = rootViewController as? UITabBarController {
                    rootViewController = tabBarController.selectedViewController
                }
                rootViewController?.present(alertController, animated: true, completion: nil)
                stat("notCreated")
            } else {
                //user sucessfully created
                let userId = user?.user.uid
                self.uuid = userId
                UserDefaults.standard.set(userId, forKey: "uid")
                //get data
                
                DataService.dataService.CURRENT_USER_REF.observe(.value) { (snapshot) in
                    if let data = snapshot.value as? [String:String] {
                        let userDict:[String:String] = ["email":data["email"]!,
                                                        "name":data["name"]!,
                                                        "bloodGroup":data["bloodGroup"]!,
                                                        "c1":data["c1"]!,
                                                        "c2":data["c2"]!,
                                                        "c3":data["c3"]!,
                                                        "uuid":data["uuid"]!,
                                                        "pass":self.password!]
                        print(userDict)
                    UserDefaults.standard.set(userDict, forKey: UserObjKey)
                    }
                }
                stat("created")
            }
        }
    }
    
    func logout(stat:@escaping(_ status:String) -> Void) {
        do {
            try! Auth.auth().signOut()
            UserDefaults.standard.removeObject(forKey: "uid")
            UserDefaults.standard.removeObject(forKey: UserObjKey)
            stat("removed")
            
        } catch {
            print("Not able to logout, check internet connection")
            stat("notRemoved")
        }
    }
}
