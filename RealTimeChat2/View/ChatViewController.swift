//
//  ChatViewController.swift
//  RealTimeChat2
//
//  Created by Miyo Alpízar on 06/10/20.
//  Copyright © 2020 Miyo Alpízar. All rights reserved.
//

import UIKit
import MessageKit
import InputBarAccessoryView

class ChatViewController: MessagesViewController, MessagesDataSource, MessagesLayoutDelegate, MessagesDisplayDelegate {
    
    
    
    let viewmodel = ChatViewModel()
    
    init(with user: AppUser) {
        super.init(nibName: nil, bundle: nil)
        viewmodel.chatWithUid = user.uid
        viewmodel.chatWithName = user.fullName
        title = user.fullName
        self.navigationItem.largeTitleDisplayMode = .never
    }
    
    init(with conversation: ConversationUser) {
        super.init(nibName: nil, bundle: nil)
        viewmodel.chatWithUid = conversation.chat_with_uid
        viewmodel.chatWithName = conversation.from
        title = conversation.from
        viewmodel.conversation_uid = conversation.uid
        self.navigationItem.largeTitleDisplayMode = .never
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareMessage()
        viewmodel.loadMessages()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        messageInputBar.inputTextView.becomeFirstResponder()
    }
    
    func prepareMessage()  {
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messageInputBar.delegate = self
        viewmodel.delegate = self
    }
    
    func currentSender() -> SenderType {
        return viewmodel.current
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return viewmodel.messages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return viewmodel.messages.count
    }
}

extension ChatViewController: InputBarAccessoryViewDelegate, ChatDelegate {
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        guard  !text.replacingOccurrences(of: " ", with: "").isEmpty else {
            return
        }
        
        viewmodel.sendMessage(with: text) { (done) in
            inputBar.inputTextView.text = ""
        }
    
    }
    
    func onChatChanged() {
        self.messagesCollectionView.reloadData()
    }
}
