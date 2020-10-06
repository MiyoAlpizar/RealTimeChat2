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
        self.tableView.register(ContactChatCell.self, forCellReuseIdentifier: "reuseIdentifier")
        self.tableView.tableFooterView = UIView()
        self.tableView.rowHeight = 54
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath) as! ContactChatCell

        cell.lblName.text = viewmodel.chats[indexPath.row].from
        cell.lblMessage.text = viewmodel.chats[indexPath.row].latest_message.message
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



class ContactChatCell: UITableViewCell {
    
    let lblName: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.boldSystemFont(ofSize: 16)
        lbl.numberOfLines = 1
        return lbl
    }()
    
    let lblMessage: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.italicSystemFont(ofSize: 13)
        lbl.numberOfLines = 1
        lbl.textColor = UIColor.gray
        return lbl
    }()
    
    let container: UIView = {
        let view = UIView()
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    private func setupViews() {
        
        self.addSubview(container)
        container.addSubview(lblName)
        container.addSubview(lblMessage)
        
        container.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-10)
            make.centerY.equalToSuperview().offset(-18)
        }
        
        lblName.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
        }
        lblMessage.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.top.equalTo(lblName.snp.bottom).offset(2)
            make.right.equalToSuperview()
        }
        
        
        
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
