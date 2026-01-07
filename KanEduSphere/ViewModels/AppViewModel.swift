//
//  AppViewModel.swift
//  KanEduSphere
//

import Foundation
import SwiftUI

class AppViewModel: ObservableObject {
    @Published var currentUser: User?
    @Published var lessons: [Lesson] = []
    @Published var challenges: [Challenge] = []
    @Published var feedbackHistory: [AIFeedback] = []
    @Published var isOnboardingComplete: Bool = false
    
    init() {
        loadData()
    }
    
    func loadData() {
        if let user = UserDefaultsService.shared.loadUser() {
            self.currentUser = user
            self.isOnboardingComplete = true
        }
        
        if let savedLessons = UserDefaultsService.shared.loadLessons() {
            self.lessons = savedLessons
        } else {
            self.lessons = DataService.shared.getLessons()
        }
        
        if let savedChallenges = UserDefaultsService.shared.loadChallenges() {
            self.challenges = savedChallenges
        } else {
            self.challenges = DataService.shared.getChallenges()
        }
        
        if let savedFeedback = UserDefaultsService.shared.loadFeedback() {
            self.feedbackHistory = savedFeedback
        }
    }
    
    func completeOnboarding(name: String, email: String, interests: [String]) {
        let user = User(name: name, email: email, interests: interests)
        self.currentUser = user
        self.isOnboardingComplete = true
        UserDefaultsService.shared.saveUser(user)
    }
    
    func completeLesson(_ lessonId: UUID) {
        guard var user = currentUser else { return }
        
        if let index = lessons.firstIndex(where: { $0.id == lessonId }) {
            lessons[index].isCompleted = true
            lessons[index].progress = 1.0
            
            user.completedLessons.append(lessonId)
            user.totalPoints += lessons[index].points
            
            currentUser = user
            UserDefaultsService.shared.saveUser(user)
            UserDefaultsService.shared.saveLessons(lessons)
        }
    }
    
    func updateLessonProgress(_ lessonId: UUID, progress: Double) {
        if let index = lessons.firstIndex(where: { $0.id == lessonId }) {
            lessons[index].progress = progress
            UserDefaultsService.shared.saveLessons(lessons)
        }
    }
    
    func completeChallenge(_ challengeId: UUID) {
        guard var user = currentUser else { return }
        
        if let index = challenges.firstIndex(where: { $0.id == challengeId }) {
            challenges[index].isCompleted = true
            
            user.completedChallenges.append(challengeId)
            user.totalPoints += challenges[index].points
            user.currentStreak += 1
            
            currentUser = user
            UserDefaultsService.shared.saveUser(user)
            UserDefaultsService.shared.saveChallenges(challenges)
        }
    }
    
    func completeTask(in challengeId: UUID, taskId: UUID) {
        if let challengeIndex = challenges.firstIndex(where: { $0.id == challengeId }) {
            if !challenges[challengeIndex].completedTasks.contains(taskId) {
                challenges[challengeIndex].completedTasks.append(taskId)
                
                if challenges[challengeIndex].completedTasks.count == challenges[challengeIndex].tasks.count {
                    completeChallenge(challengeId)
                } else {
                    UserDefaultsService.shared.saveChallenges(challenges)
                }
            }
        }
    }
    
    func generateFeedback(for lessonId: UUID, input: String, type: AIFeedback.FeedbackType) {
        let feedback = DataService.shared.generateAIFeedback(for: lessonId, userInput: input, type: type)
        feedbackHistory.append(feedback)
        UserDefaultsService.shared.saveFeedback(feedbackHistory)
    }
    
    func deleteAccount() {
        UserDefaultsService.shared.resetAllData()
        currentUser = nil
        isOnboardingComplete = false
        lessons = DataService.shared.getLessons()
        challenges = DataService.shared.getChallenges()
        feedbackHistory = []
    }
}

