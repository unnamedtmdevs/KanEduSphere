//
//  User.swift
//  KanEduSphere
//

import Foundation

struct User: Codable, Identifiable {
    let id: UUID
    var name: String
    var email: String
    var avatarColor: String
    var interests: [String]
    var joinedDate: Date
    var totalPoints: Int
    var currentStreak: Int
    var completedLessons: [UUID]
    var completedChallenges: [UUID]
    
    init(name: String, email: String, interests: [String]) {
        self.id = UUID()
        self.name = name
        self.email = email
        self.avatarColor = ["#fbd600", "#ffffff"].randomElement() ?? "#fbd600"
        self.interests = interests
        self.joinedDate = Date()
        self.totalPoints = 0
        self.currentStreak = 0
        self.completedLessons = []
        self.completedChallenges = []
    }
}

