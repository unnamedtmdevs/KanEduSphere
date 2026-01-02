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
    @Published var groups: [CollaborationGroup] = []
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
        
        if let savedGroups = UserDefaultsService.shared.loadGroups() {
            self.groups = savedGroups
        } else {
            self.groups = DataService.shared.getCollaborationGroups()
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
    
    func joinGroup(_ groupId: UUID) {
        guard let user = currentUser else { return }
        
        if let index = groups.firstIndex(where: { $0.id == groupId }) {
            let member = GroupMember(name: user.name, avatarColor: user.avatarColor)
            groups[index].members.append(member)
            UserDefaultsService.shared.saveGroups(groups)
        }
    }
    
    func sendMessage(to groupId: UUID, content: String) {
        guard let user = currentUser else { return }
        
        if let index = groups.firstIndex(where: { $0.id == groupId }) {
            let message = GroupMessage(senderId: user.id, senderName: user.name, content: content)
            groups[index].messages.append(message)
            UserDefaultsService.shared.saveGroups(groups)
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
        groups = DataService.shared.getCollaborationGroups()
        feedbackHistory = []
    }
}

