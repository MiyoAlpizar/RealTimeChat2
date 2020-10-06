//
//  ContactsTableViewController.swift
//  RealTimeChat2
//
//  Created by Miyo Alpízar on 05/10/20.
//  Copyright © 2020 Miyo Alpízar. All rights reserved.
//

import UIKit

class ContactsTableViewController: UITableViewController {

    var viewmodel = ContactsViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareTableView()
        addTargets()
        viewmodel.LoadContacts()
        viewmodel.delegate = self
    }
    
    private func prepareTableView() {
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "reuseIdentifier")
        self.tableView.tableFooterView = UIView()
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return viewmodel.contacts.InList.count
        }
        return viewmodel.contacts.NotInList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        if indexPath.section == 0 {
            cell.textLabel?.text = viewmodel.contacts.InList[indexPath.row].fullName
        }else {
            cell.textLabel?.text = viewmodel.contacts.NotInList[indexPath.row].fullName
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "My Contacts"
        }
        return "Other Contacts"
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            self.confirmAlert(title: "Add Contact", message: "Do you wanna add this contact") { [weak self] in
                guard let `self` = self else { return }
                self.viewmodel.updateContacts(uid: self.viewmodel.contacts.NotInList[indexPath.row].uid, isAdd: true)
            }
        }else {
            
            let actionSheet = UIAlertController(title: "Choose one option", message: "What do you wanna do?", preferredStyle: UIAlertController.Style.actionSheet)
            
            let cancel = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil)
            
            let startChat = UIAlertAction(title: "New chat", style: UIAlertAction.Style.default) { (UIAlertAction) in
                
            }
            
            let removeContact = UIAlertAction(title: "Remove contact", style: UIAlertAction.Style.destructive) { (_) in
                self.confirmAlert(title: "Remove Contact", message: "Do you wanna remove this contact") { [weak self] in
                    guard let `self` = self else { return }
                    self.viewmodel.updateContacts(uid: self.viewmodel.contacts.InList[indexPath.row].uid, isAdd: false)
                }
            }
            
            actionSheet.addAction(startChat)
            actionSheet.addAction(removeContact)
            actionSheet.addAction(cancel)
            
            self.present(actionSheet, animated: true, completion: nil)
            
        }
        tableView.deselectAllRows()
    }
}

extension ContactsTableViewController {
    
    func addTargets() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(addContact))
    }
    
    @objc func addContact() {
        showInputDialog(title: "Look for contact",
                        subtitle: "Please enter the number of the contact you are looking for.",
                        actionTitle: "Search",
                        cancelTitle: "Cancel",
                        inputPlaceholder: "number",
                        inputKeyboardType: .numberPad, actionHandler:
                            {(input:String?) in
                                //guard let `self` = self else { return }
                                guard let phone = input else { return }
                                UserHelper.shared.searchUsers(with: phone) { (users) in
                                    print(users)
                                }
                            })
    }
    
}

extension ContactsTableViewController: ContactsDelegate {
    func onContactsLaoded(contacts: AppContacts) {
        self.tableView.reloadData()
    }
}
