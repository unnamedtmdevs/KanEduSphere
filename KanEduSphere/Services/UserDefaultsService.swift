//
//  UserDefaultsService.swift
//  KanEduSphere
//

import Foundation

class UserDefaultsService {
    static let shared = UserDefaultsService()
    
    private let userKey = "currentUser"
    private let lessonsKey = "userLessons"
    private let challengesKey = "userChallenges"
    private let feedbackKey = "userFeedback"
    
    private init() {}
    
    func saveUser(_ user: User) {
        if let encoded = try? JSONEncoder().encode(user) {
            UserDefaults.standard.set(encoded, forKey: userKey)
        }
    }
    
    func loadUser() -> User? {
        guard let data = UserDefaults.standard.data(forKey: userKey),
              let user = try? JSONDecoder().decode(User.self, from: data) else {
            return nil
        }
        return user
    }
    
    func saveLessons(_ lessons: [Lesson]) {
        if let encoded = try? JSONEncoder().encode(lessons) {
            UserDefaults.standard.set(encoded, forKey: lessonsKey)
        }
    }
    
    func loadLessons() -> [Lesson]? {
        guard let data = UserDefaults.standard.data(forKey: lessonsKey),
              let lessons = try? JSONDecoder().decode([Lesson].self, from: data) else {
            return nil
        }
        return lessons
    }
    
    func saveChallenges(_ challenges: [Challenge]) {
        if let encoded = try? JSONEncoder().encode(challenges) {
            UserDefaults.standard.set(encoded, forKey: challengesKey)
        }
    }
    
    func loadChallenges() -> [Challenge]? {
        guard let data = UserDefaults.standard.data(forKey: challengesKey),
              let challenges = try? JSONDecoder().decode([Challenge].self, from: data) else {
            return nil
        }
        return challenges
    }
    
    func saveFeedback(_ feedback: [AIFeedback]) {
        if let encoded = try? JSONEncoder().encode(feedback) {
            UserDefaults.standard.set(encoded, forKey: feedbackKey)
        }
    }
    
    func loadFeedback() -> [AIFeedback]? {
        guard let data = UserDefaults.standard.data(forKey: feedbackKey),
              let feedback = try? JSONDecoder().decode([AIFeedback].self, from: data) else {
            return nil
        }
        return feedback
    }
    
    func resetAllData() {
        UserDefaults.standard.removeObject(forKey: userKey)
        UserDefaults.standard.removeObject(forKey: lessonsKey)
        UserDefaults.standard.removeObject(forKey: challengesKey)
        UserDefaults.standard.removeObject(forKey: feedbackKey)
        UserDefaults.standard.synchronize()
    }
}

