//
//  ContactsHelper.swift
//  RealTimeChat2
//
//  Created by Miyo Alpízar on 05/10/20.
//  Copyright © 2020 Miyo Alpízar. All rights reserved.
//

import Firebase
import CodableFirebase

class  ContactsHelper {
    
    private static let _shared = ContactsHelper()
    
    public static var shared: ContactsHelper {
        return _shared
    }
    
    func LoadContacts(completion: @escaping(Array<AppUser>, [String])-> Void) {
        DatabaseHelper.shared.userData.queryOrdered(byChild: "name").observe(DataEventType.value) { (snap) in
            var  users: Array<AppUser> = []
            var contacts: [String] = []
           
            if !snap.exists() {
                completion(users, contacts)
                return
            }
            
            for child in snap.children {
                do {
                    guard let snap = child as? DataSnapshot
                    else {
                        return
                    }
                    guard let value = snap.value as? [String: Any] else {
                        return
                    }
                    let user = try FirebaseDecoder().decode(AppUser.self, from: value)
                    //Apend all users, except current user
                    if user.uid != UserHelper.shared.user.uid {
                        users.append(user)
                    }
                    
                } catch let error {
                    print(error)
                }
            }
            
            DatabaseHelper.shared.contactsData.child(UserHelper.shared.user.uid).observeSingleEvent(of: DataEventType.value) { (snap) in
                
                if snap.exists() {
                    if let cont = snap.value as? [String] {
                        contacts = cont
                        UserHelper.shared.contacts = contacts
                    }
                }
                
                completion(users, contacts)
                
            }
        
        }
    }
    
    func UpdateContact(uid: String, add: Bool, done: @escaping(Result<Bool, Error>) -> Void) {
        
        UserHelper.shared.contacts = UserHelper.shared.contacts.filter({$0 != uid})
        //We add the contact, other wise, just remove it
        if (add) {
            UserHelper.shared.contacts.append(uid)
        }
        //let docData = try! FirestoreEncoder().encode(UserHelper.shared.contacts)
        DatabaseHelper.shared.contactsData.child(UserHelper.shared.user.uid)
            .setValue(UserHelper.shared.contacts) { (error, reference) in
                if let error = error {
                    done(.failure(error))
                }else {
                    done(.success(true))
                }
            }
    }
}
