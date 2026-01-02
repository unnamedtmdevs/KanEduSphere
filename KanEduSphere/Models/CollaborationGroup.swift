//
//  CollaborationGroup.swift
//  KanEduSphere
//

import Foundation

struct CollaborationGroup: Identifiable, Codable {
    let id: UUID
    let name: String
    let description: String
    let category: LessonCategory
    let createdBy: String
    let createdDate: Date
    var members: [GroupMember]
    var messages: [GroupMessage]
    var maxMembers: Int
    
    init(name: String, description: String, category: LessonCategory, createdBy: String, maxMembers: Int = 10) {
        self.id = UUID()
        self.name = name
        self.description = description
        self.category = category
        self.createdBy = createdBy
        self.createdDate = Date()
        self.members = []
        self.messages = []
        self.maxMembers = maxMembers
    }
    
    var isFull: Bool {
        members.count >= maxMembers
    }
}

struct GroupMember: Identifiable, Codable {
    let id: UUID
    let name: String
    let avatarColor: String
    let joinedDate: Date
    
    init(name: String, avatarColor: String) {
        self.id = UUID()
        self.name = name
        self.avatarColor = avatarColor
        self.joinedDate = Date()
    }
}

struct GroupMessage: Identifiable, Codable {
    let id: UUID
    let senderId: UUID
    let senderName: String
    let content: String
    let timestamp: Date
    let isModerated: Bool
    
    init(senderId: UUID, senderName: String, content: String) {
        self.id = UUID()
        self.senderId = senderId
        self.senderName = senderName
        self.content = content
        self.timestamp = Date()
        self.isModerated = true
    }
}

