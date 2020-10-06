//
//  UserHelper.swift
//  RealTimeChat
//
//  Created by Miyo Alpízar on 14/09/20.
//  Copyright © 2020 Miyo Alpízar. All rights reserved.
//

import Firebase
import CodableFirebase

class  UserHelper {
    
    private static let _shared = UserHelper()
    
    public static var shared: UserHelper {
        return _shared
    }
    
    public func isUserIn() -> Bool {
        return Auth.auth().currentUser != nil
    }
    
    public func currentUser(completion: @escaping(Bool) -> Void) {
        if Auth.auth().currentUser == nil {
            completion(false)
            return
        }
        getCurrentUser { (ok) in
            completion(ok)
        }
    }
    
    private func getCurrentUser(completion: @escaping(Bool) -> Void) {
        if let user = Auth.auth().currentUser {
            DatabaseHelper.shared.userData.child(user.uid).observeSingleEvent(of: DataEventType.value) { (data) in
                if !data.exists() {
                    completion(false)
                    return
                }
                guard let value = data.value else { return }
                do {
                    let user = try FirebaseDecoder().decode(AppUser.self, from: value)
                    self._user = user
                    completion(true)
                } catch let error {
                    print(error)
                }
            }
        }
    }
    
    private var _user = AppUser(uid: "", email: "", name: "", lastName: "", phoneNumber: "")
    
    public var user: AppUser {
        get {
            return _user
        }
    }
    
    public var contacts: [String] = []
    
    public func registerUser(email: String,
                             name: String,
                             lastName: String,
                             phone: String,
                             pwd: String,
                             completion: @escaping (Result<String, Error>) -> Void) {
        
        Auth.auth().createUser(withEmail: email, password: pwd) { (result, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let result = result else {
                completion(.failure(NSError(domain: "Error on Firebase", code: -1, userInfo: nil)))
                return
            }
            self.addUser(user: AppUser(uid: result.user.uid, email: email, name: name, lastName: lastName, phoneNumber: phone)) { (res) in
                switch res {
                case .success(_):
                    completion(.success(result.user.uid))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
    
    private func addUser(user: AppUser, completion: @escaping(Result<Bool, Error>) -> Void) {
        let docData = try! FirestoreEncoder().encode(user)
        DatabaseHelper.shared.userData.child(user.uid).setValue(docData) { (error, ref) in
            if let error = error {
                completion(.failure(error))
                return
            }
            self._user = user
            completion(.success(true))
        }
    }
    
    public func login(email: String, pwd: String, completion: @escaping(Result<Bool, Error>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: pwd) { (result, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            if let result = result {
                print(result)
                self.getCurrentUser { (ok) in
                    completion(.success(ok))
                }
                return
            }
            completion(.success(false))
        }
    }
    
    public func logOut() {
        do {
            try Auth.auth().signOut()
            contacts = []
            _user =  AppUser(uid: "", email: "", name: "", lastName: "", phoneNumber: "")
        }
        catch {
            print("already logged out")
        }
    }
    
    public func sendEmailToRecoveryPassword(with email: String, completion: @escaping(Result<Bool, Error>)  -> Void) {
        Auth.auth().sendPasswordReset(withEmail: email) { (error) in
            if let error = error {
                completion(.failure(error))
            }else {
                completion(.success(true))
            }
        }
    }
    
    public func searchUsers(with phone: String, completion: @escaping(Array<AppUser>) -> Void) {
        DatabaseHelper.shared.userData.queryOrdered(byChild: "phoneNumber").queryStarting(atValue: phone).observe(DataEventType.value) { (snap) in
            var  users: Array<AppUser> = []
            if !snap.exists() {
                completion(users)
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
                    print(value)
                    let user = try FirebaseDecoder().decode(AppUser.self, from: value)
                    users.append(user)
                    print(user)
                } catch let error {
                    print(error)
                }
            }
            print(users)
            completion(users)
        }
    }
}



