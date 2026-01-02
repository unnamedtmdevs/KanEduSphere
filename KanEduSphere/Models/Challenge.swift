//
//  Challenge.swift
//  KanEduSphere
//

import Foundation

enum ChallengeType: String, Codable {
    case daily = "Daily"
    case weekly = "Weekly"
    case special = "Special"
}

struct Challenge: Identifiable, Codable {
    let id: UUID
    let title: String
    let description: String
    let type: ChallengeType
    let category: LessonCategory
    let points: Int
    let tasks: [ChallengeTask]
    let expiryDate: Date
    var isCompleted: Bool
    var completedTasks: [UUID]
    
    init(title: String, description: String, type: ChallengeType, category: LessonCategory, points: Int, tasks: [ChallengeTask], expiryDate: Date) {
        self.id = UUID()
        self.title = title
        self.description = description
        self.type = type
        self.category = category
        self.points = points
        self.tasks = tasks
        self.expiryDate = expiryDate
        self.isCompleted = false
        self.completedTasks = []
    }
    
    var progress: Double {
        guard !tasks.isEmpty else { return 0 }
        return Double(completedTasks.count) / Double(tasks.count)
    }
}

struct ChallengeTask: Identifiable, Codable {
    let id: UUID
    let description: String
    let requiredCount: Int
    var currentCount: Int
    
    init(description: String, requiredCount: Int) {
        self.id = UUID()
        self.description = description
        self.requiredCount = requiredCount
        self.currentCount = 0
    }
    
    var isCompleted: Bool {
        currentCount >= requiredCount
    }
}

