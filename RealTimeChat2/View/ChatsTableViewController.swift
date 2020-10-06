//
//  ChatsTableViewController.swift
//  RealTimeChat2
//
//  Created by Miyo Alpízar on 05/10/20.
//  Copyright © 2020 Miyo Alpízar. All rights reserved.
//

import UIKit

class ChatsTableViewController: UITableViewController {

    let viewmodel = ChatsVideModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareTableView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewmodel.LoadChats()
    }
    
    private func prepareTableView() {
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "reuseIdentifier")
        self.tableView.tableFooterView = UIView()
        viewmodel.delegate = self
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewmodel.chats.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        cell.textLabel?.text = viewmodel.chats[indexPath.row].from
        cell.detailTextLabel?.text = viewmodel.chats[indexPath.row].latest_message.message
        cell.accessoryType = .disclosureIndicator

        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let chat = ChatViewController(with: self.viewmodel.chats[indexPath.row])
        self.navigationController?.pushViewController(chat, animated: true)
    }
}

extension ChatsTableViewController: ChatsDelegate {
    func onChatsLoaded() {
        self.tableView.reloadData()
        
    }
}
