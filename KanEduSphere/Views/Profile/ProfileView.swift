//
//  ProfileView.swift
//  KanEduSphere
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var viewModel: AppViewModel
    @State private var showDeleteAlert = false
    @State private var showFeedbackHistory = false
    
    var body: some View {
        NavigationView {
            ZStack {
                DesignSystem.backgroundColor
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        profileHeader
                        
                        statsSection
                        
                        settingsSection
                    }
                    .padding()
                }
            }
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.large)
        }
    }
    
    private var profileHeader: some View {
        VStack(spacing: 16) {
            if let user = viewModel.currentUser {
                Circle()
                    .fill(Color(hex: user.avatarColor))
                    .frame(width: 100, height: 100)
                    .overlay(
                        Text(String(user.name.prefix(1)))
                            .font(.system(size: 40))
                            .foregroundColor(.black)
                    )
                
                Text(user.name)
                    .font(.system(size: 28))
                    .foregroundColor(.white)
                
                Text(user.email)
                    .font(.system(size: 15))
                    .foregroundColor(.white.opacity(0.7))
                
                Text("Member since \(formatDate(user.joinedDate))")
                    .font(.system(size: 13))
                    .foregroundColor(.white.opacity(0.5))
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
        .glassCard()
    }
    
    private var statsSection: some View {
        VStack(spacing: 16) {
            if let user = viewModel.currentUser {
                HStack(spacing: 16) {
                    StatBox(title: "Total Points", value: "\(user.totalPoints)", icon: "star.fill")
                    StatBox(title: "Current Streak", value: "\(user.currentStreak)", icon: "flame.fill")
                }
                
                HStack(spacing: 16) {
                    StatBox(title: "Lessons", value: "\(user.completedLessons.count)", icon: "book.fill")
                    StatBox(title: "Challenges", value: "\(user.completedChallenges.count)", icon: "trophy.fill")
                }
            }
        }
    }
    
    private var settingsSection: some View {
        VStack(spacing: 16) {
            Text("Settings")
                .font(.system(size: 24))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack(spacing: 12) {
                SettingsRow(
                    icon: "chart.bar.fill",
                    title: "Progress & Stats",
                    action: {}
                )
                
                SettingsRow(
                    icon: "brain.head.profile",
                    title: "AI Feedback History",
                    action: { showFeedbackHistory = true }
                )
                
                SettingsRow(
                    icon: "bell.fill",
                    title: "Notifications",
                    action: {}
                )
                
                SettingsRow(
                    icon: "paintbrush.fill",
                    title: "Appearance",
                    action: {}
                )
                
                SettingsRow(
                    icon: "questionmark.circle.fill",
                    title: "Help & Support",
                    action: {}
                )
                
                SettingsRow(
                    icon: "info.circle.fill",
                    title: "About EduSphere",
                    action: {}
                )
                
                Button(action: { showDeleteAlert = true }) {
                    HStack {
                        Image(systemName: "trash.fill")
                            .font(.system(size: 20))
                            .foregroundColor(.red)
                        
                        Text("Delete Account")
                            .font(.system(size: 17))
                            .foregroundColor(.red)
                        
                        Spacer()
                    }
                    .padding()
                    .glassCard()
                }
            }
        }
        .alert(isPresented: $showDeleteAlert) {
            Alert(
                title: Text("Delete Account"),
                message: Text("Are you sure you want to delete your account? This will reset all your progress and data."),
                primaryButton: .destructive(Text("Delete")) {
                    viewModel.deleteAccount()
                },
                secondaryButton: .cancel()
            )
        }
        .sheet(isPresented: $showFeedbackHistory) {
            FeedbackHistoryView()
                .environmentObject(viewModel)
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter.string(from: date)
    }
}

struct StatBox: View {
    let title: String
    let value: String
    let icon: String
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(DesignSystem.primaryColor)
            
            Text(value)
                .font(.system(size: 24))
                .foregroundColor(.white)
            
            Text(title)
                .font(.system(size: 13))
                .foregroundColor(.white.opacity(0.7))
        }
        .frame(maxWidth: .infinity)
        .padding()
        .glassCard()
    }
}

struct SettingsRow: View {
    let icon: String
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundColor(DesignSystem.primaryColor)
                    .frame(width: 30)
                
                Text(title)
                    .font(.system(size: 17))
                    .foregroundColor(.white)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14))
                    .foregroundColor(.white.opacity(0.5))
            }
            .padding()
            .glassCard()
        }
    }
}

struct FeedbackHistoryView: View {
    @EnvironmentObject var viewModel: AppViewModel
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            ZStack {
                DesignSystem.backgroundColor
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 16) {
                        if viewModel.feedbackHistory.isEmpty {
                            VStack(spacing: 16) {
                                Image(systemName: "tray")
                                    .font(.system(size: 60))
                                    .foregroundColor(.white.opacity(0.3))
                                
                                Text("No feedback yet")
                                    .font(.system(size: 17))
                                    .foregroundColor(.white.opacity(0.7))
                                
                                Text("Complete interactive lessons to receive AI feedback")
                                    .font(.system(size: 15))
                                    .foregroundColor(.white.opacity(0.5))
                                    .multilineTextAlignment(.center)
                            }
                            .padding()
                        } else {
                            ForEach(viewModel.feedbackHistory.reversed()) { feedback in
                                FeedbackHistoryCard(feedback: feedback)
                            }
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Feedback History")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(trailing: Button("Done") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}

struct FeedbackHistoryCard: View {
    let feedback: AIFeedback
    @State private var isExpanded = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(feedback.feedbackType.rawValue)
                        .font(.system(size: 17))
                        .foregroundColor(.white)
                    
                    Text(formatDate(feedback.timestamp))
                        .font(.system(size: 13))
                        .foregroundColor(.white.opacity(0.7))
                }
                
                Spacer()
                
                VStack(spacing: 4) {
                    Text("\(Int(feedback.score * 100))%")
                        .font(.system(size: 20))
                        .foregroundColor(DesignSystem.primaryColor)
                    
                    Button(action: { isExpanded.toggle() }) {
                        Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                            .foregroundColor(.white.opacity(0.5))
                    }
                }
            }
            
            if isExpanded {
                VStack(alignment: .leading, spacing: 12) {
                    Divider()
                        .background(Color.white.opacity(0.2))
                    
                    if !feedback.strengths.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Strengths")
                                .font(.system(size: 15))
                                .foregroundColor(DesignSystem.primaryColor)
                            
                            ForEach(feedback.strengths, id: \.self) { strength in
                                Text("• \(strength)")
                                    .font(.system(size: 14))
                                    .foregroundColor(.white.opacity(0.8))
                            }
                        }
                    }
                    
                    if !feedback.areasToImprove.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Areas to Improve")
                                .font(.system(size: 15))
                                .foregroundColor(DesignSystem.primaryColor)
                            
                            ForEach(feedback.areasToImprove, id: \.self) { area in
                                Text("• \(area)")
                                    .font(.system(size: 14))
                                    .foregroundColor(.white.opacity(0.8))
                            }
                        }
                    }
                }
            }
        }
        .padding()
        .glassCard()
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

