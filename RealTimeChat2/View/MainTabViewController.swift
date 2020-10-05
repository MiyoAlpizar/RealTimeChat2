//
//  MainTabViewController.swift
//  RealTimeChat2
//
//  Created by Miyo Alpízar on 05/10/20.
//  Copyright © 2020 Miyo Alpízar. All rights reserved.
//

import UIKit

class MainTabViewController: UITabBarController {
    
    private let contactsVC: ContactsTableViewController = {
        let home = ContactsTableViewController()
        home.title = "Contacts"
        return home
    }()
    
    private lazy var contactsNC: UINavigationController = {
        let nc = UINavigationController(rootViewController: contactsVC)
        nc.title = "Contacts"
        nc.navigationBar.prefersLargeTitles = true
        nc.tabBarItem.selectedImage = UIImage(systemName: "person.3.fill")
        nc.tabBarItem.image = UIImage(systemName: "person.3")
        return nc
    }()
    
    private let chatsVC: ChatsTableViewController = {
        let vc = ChatsTableViewController()
        vc.title = "Chats"
        return vc
    }()
    
    private lazy var chatsNC: UINavigationController = {
        let nc = UINavigationController(rootViewController: chatsVC)
        nc.title = "Chats"
        nc.navigationBar.prefersLargeTitles = true
        nc.tabBarItem.selectedImage = UIImage(systemName: "text.bubble.fill")
        nc.tabBarItem.image = UIImage(systemName: "text.bubble")
        return nc
    }()
    
    private let profileVC: ProfileTableViewController = {
        let vc = ProfileTableViewController(style: UITableView.Style.grouped)
        vc.title = "Profile"
        return vc
    }()
    
    private lazy var profileNC: UINavigationController = {
        let nc = UINavigationController(rootViewController: profileVC)
        nc.title = "Profile"
        nc.navigationBar.prefersLargeTitles = true
        nc.tabBarItem.selectedImage = UIImage(systemName: "person.fill")
        nc.tabBarItem.image = UIImage(systemName: "person")
        return nc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewControllers = [contactsNC, chatsNC, profileNC]
    }
    
}
