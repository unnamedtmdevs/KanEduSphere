//
//  Lesson.swift
//  KanEduSphere
//

import Foundation

enum LessonCategory: String, Codable, CaseIterable {
    case language = "Language"
    case mathematics = "Mathematics"
    case science = "Science"
    case arts = "Arts"
    case programming = "Programming"
    case business = "Business"
}

enum DifficultyLevel: String, Codable {
    case beginner = "Beginner"
    case intermediate = "Intermediate"
    case advanced = "Advanced"
}

struct Lesson: Identifiable, Codable {
    let id: UUID
    let title: String
    let description: String
    let category: LessonCategory
    let difficulty: DifficultyLevel
    let duration: Int
    let points: Int
    let quizQuestions: [QuizQuestion]
    let content: [LessonContent]
    var isCompleted: Bool
    var progress: Double
    
    init(title: String, description: String, category: LessonCategory, difficulty: DifficultyLevel, duration: Int, points: Int, quizQuestions: [QuizQuestion], content: [LessonContent]) {
        self.id = UUID()
        self.title = title
        self.description = description
        self.category = category
        self.difficulty = difficulty
        self.duration = duration
        self.points = points
        self.quizQuestions = quizQuestions
        self.content = content
        self.isCompleted = false
        self.progress = 0.0
    }
}

struct LessonContent: Identifiable, Codable {
    let id: UUID
    let type: ContentType
    let text: String
    let mediaURL: String?
    
    enum ContentType: String, Codable {
        case text
        case video
        case image
        case interactive
    }
    
    init(type: ContentType, text: String, mediaURL: String? = nil) {
        self.id = UUID()
        self.type = type
        self.text = text
        self.mediaURL = mediaURL
    }
}

struct QuizQuestion: Identifiable, Codable {
    let id: UUID
    let question: String
    let options: [String]
    let correctAnswer: Int
    let explanation: String
    
    init(question: String, options: [String], correctAnswer: Int, explanation: String) {
        self.id = UUID()
        self.question = question
        self.options = options
        self.correctAnswer = correctAnswer
        self.explanation = explanation
    }
}

