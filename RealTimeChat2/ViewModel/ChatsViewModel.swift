//
//  ChatsViewModel.swift
//  RealTimeChat2
//
//  Created by Miyo Alpízar on 06/10/20.
//  Copyright © 2020 Miyo Alpízar. All rights reserved.
//

import Foundation

protocol ChatsDelegate: class {
    func onChatsLoaded()
}

class ChatsVideModel {
    
    public weak var delegate: ChatsDelegate?
    public var chats: Array<ConversationUser> = []
    
    func LoadChats() {
        ChatHelper.shared.getAllConversation { [weak self] (result) in
            switch result {
            case .success(let ch):
                self?.chats = ch
                self?.DelegateChats()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func DelegateChats() {
        if let delegate = delegate {
            delegate.onChatsLoaded()
        }
    }
}
