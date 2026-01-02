//
//  AIFeedback.swift
//  KanEduSphere
//

import Foundation

struct AIFeedback: Identifiable, Codable {
    let id: UUID
    let lessonId: UUID
    let userInput: String
    let feedbackType: FeedbackType
    let score: Double
    let suggestions: [String]
    let strengths: [String]
    let areasToImprove: [String]
    let timestamp: Date
    
    enum FeedbackType: String, Codable {
        case pronunciation = "Pronunciation"
        case grammar = "Grammar"
        case vocabulary = "Vocabulary"
        case writing = "Writing"
        case problemSolving = "Problem Solving"
    }
    
    init(lessonId: UUID, userInput: String, feedbackType: FeedbackType, score: Double, suggestions: [String], strengths: [String], areasToImprove: [String]) {
        self.id = UUID()
        self.lessonId = lessonId
        self.userInput = userInput
        self.feedbackType = feedbackType
        self.score = score
        self.suggestions = suggestions
        self.strengths = strengths
        self.areasToImprove = areasToImprove
        self.timestamp = Date()
    }
}

