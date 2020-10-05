//
//  ProfileTableViewController.swift
//  RealTimeChat2
//
//  Created by Miyo Alpízar on 05/10/20.
//  Copyright © 2020 Miyo Alpízar. All rights reserved.
//

import UIKit

enum profileCellType {
    case notifications
    case account
    case help
    case logout
}

struct profileCell {
    var type: profileCellType
    var title: String
    var hasNext: Bool
}

class ProfileTableViewController: UITableViewController {
    
    var cells: [[profileCell]] = []
    
    let header: ProfileHeaderView = {
        let header = ProfileHeaderView()
        return header
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setData()
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return cells.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells[section].count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellID", for: indexPath)
        let info = cells[indexPath.section][indexPath.item]
        cell.textLabel?.text = info.title
        cell.accessoryType = info.hasNext ? UITableViewCell.AccessoryType.disclosureIndicator : UITableViewCell.AccessoryType.none
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let info = cells[indexPath.section][indexPath.item]
        
        if info.type == .logout {
            self.confirmAlert(title: "Log out", message: "You shure?, we will gonna miss you =(") {
                UserHelper.shared.logOut()
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.window!.rootViewController = StartViewController()
            }
        }
        
        tableView.deselectAllRows()
    }
}


extension ProfileTableViewController {
    private func setupViews() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellID")
        tableView.tableHeaderView = header
        tableView.tableFooterView = UIView()
        tableView.layoutTableHeaderView()
    }
    
    private func setData() {
        
        cells.append([profileCell(type: .account, title: "My Account", hasNext: true),
                      profileCell(type: .notifications, title: "Notifications", hasNext: true)])
        cells.append([profileCell(type: .help, title: "Help", hasNext: false)])
        cells.append([profileCell(type: .logout, title: "Log out", hasNext: false)])
        
        
    }
}
