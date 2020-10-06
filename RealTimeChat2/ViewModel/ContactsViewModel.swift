//
//  ContactsViewModel.swift
//  RealTimeChat2
//
//  Created by Miyo Alpízar on 05/10/20.
//  Copyright © 2020 Miyo Alpízar. All rights reserved.
//

import Foundation

protocol ContactsDelegate: class {
    func onContactsLaoded(contacts: AppContacts)
}

class ContactsViewModel {
    
    weak var delegate: ContactsDelegate?
    var contacts: AppContacts = AppContacts()
    var users: Array<AppUser> = []
    var _contacts: [String] = []
    
    func LoadContacts() {
        ContactsHelper.shared.LoadContacts { [weak self] (users, contacts) in
            guard let `self` = self else { return }
            self.users = users
            self._contacts = contacts
            self.delegateUsers()
        }
    }
    
    private func delegateUsers() {
        self.contacts.InList = []
        self.contacts.NotInList = users
        
        _contacts.forEach { (contact) in
            self.contacts.InList.append(contentsOf: users.filter({ $0.uid == contact }))
        }
        
        self.contacts.InList = self.contacts.InList.sorted{ $0.fullName < $1.fullName }
        
        self.contacts.InList.forEach { (user) in
            var isIn: Bool = false
            _contacts.forEach { (contact) in
                if (contact == user.uid) {
                    isIn = true
                }
            }
            if isIn {
                self.contacts.NotInList = self.contacts.NotInList.filter({$0.uid != user.uid})
            }
        }
        
        self.contacts.NotInList = self.contacts.NotInList.sorted{ $0.fullName < $1.fullName }
       
        
        guard let delegate = self.delegate else { return }
        delegate.onContactsLaoded(contacts: self.contacts)
    }
    
    func updateContacts(uid: String, isAdd: Bool) {
        ContactsHelper.shared.UpdateContact(uid: uid, add: isAdd) { [weak self] (res) in
            guard let `self` = self else { return }
            
            self._contacts = self._contacts.filter({$0 != uid})
            if isAdd {
                self._contacts.append(uid)
            }
            UserHelper.shared.contacts = self._contacts
            self.delegateUsers()
        }
    }
}
