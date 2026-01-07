//
//  ProfileView.swift
//  KanEduSphere
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var viewModel: AppViewModel
    @State private var showDeleteAlert = false
    @State private var showFeedbackHistory = false
    @State private var showProgressStats = false
    @State private var showNotifications = false
    @State private var showAppearance = false
    @State private var showHelpSupport = false
    @State private var showAbout = false
    
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
                    action: { showProgressStats = true }
                )
                
                SettingsRow(
                    icon: "brain.head.profile",
                    title: "AI Feedback History",
                    action: { showFeedbackHistory = true }
                )
                
                SettingsRow(
                    icon: "bell.fill",
                    title: "Notifications",
                    action: { showNotifications = true }
                )
                
                SettingsRow(
                    icon: "paintbrush.fill",
                    title: "Appearance",
                    action: { showAppearance = true }
                )
                
                SettingsRow(
                    icon: "questionmark.circle.fill",
                    title: "Help & Support",
                    action: { showHelpSupport = true }
                )
                
                SettingsRow(
                    icon: "info.circle.fill",
                    title: "About EduSphere",
                    action: { showAbout = true }
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
        .sheet(isPresented: $showProgressStats) {
            ProgressStatsView()
                .environmentObject(viewModel)
        }
        .sheet(isPresented: $showNotifications) {
            NotificationsView()
        }
        .sheet(isPresented: $showAppearance) {
            AppearanceView()
        }
        .sheet(isPresented: $showHelpSupport) {
            HelpSupportView()
        }
        .sheet(isPresented: $showAbout) {
            AboutView()
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

// MARK: - Progress & Stats View
struct ProgressStatsView: View {
    @EnvironmentObject var viewModel: AppViewModel
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            ZStack {
                DesignSystem.backgroundColor
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        if let user = viewModel.currentUser {
                            // Overall Stats
                            VStack(alignment: .leading, spacing: 16) {
                                Text("Overall Progress")
                                    .font(.system(size: 24))
                                    .foregroundColor(.white)
                                
                                VStack(spacing: 12) {
                                    ProgressStatRow(title: "Total Points", value: "\(user.totalPoints)", icon: "star.fill", color: DesignSystem.primaryColor)
                                    ProgressStatRow(title: "Current Streak", value: "\(user.currentStreak) days", icon: "flame.fill", color: .orange)
                                    ProgressStatRow(title: "Lessons Completed", value: "\(user.completedLessons.count)", icon: "book.fill", color: .blue)
                                    ProgressStatRow(title: "Challenges Completed", value: "\(user.completedChallenges.count)", icon: "trophy.fill", color: .green)
                                }
                            }
                            .padding()
                            .glassCard()
                            
                            // Category Breakdown
                            VStack(alignment: .leading, spacing: 16) {
                                Text("Learning Categories")
                                    .font(.system(size: 24))
                                    .foregroundColor(.white)
                                
                                ForEach(user.interests, id: \.self) { interest in
                                    CategoryProgressCard(category: interest, viewModel: viewModel)
                                }
                            }
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Progress & Stats")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(trailing: Button("Done") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}

struct ProgressStatRow: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(color)
                .frame(width: 30)
            
            Text(title)
                .font(.system(size: 16))
                .foregroundColor(.white)
            
            Spacer()
            
            Text(value)
                .font(.system(size: 18))
                .foregroundColor(color)
        }
        .padding()
        .background(DesignSystem.glassBackground)
        .cornerRadius(12)
    }
}

struct CategoryProgressCard: View {
    let category: String
    let viewModel: AppViewModel
    
    var lessonsInCategory: Int {
        viewModel.lessons.filter { $0.category.rawValue == category && $0.isCompleted }.count
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(category)
                    .font(.system(size: 17))
                    .foregroundColor(.white)
                
                Text("\(lessonsInCategory) lessons completed")
                    .font(.system(size: 14))
                    .foregroundColor(.white.opacity(0.7))
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.white.opacity(0.3))
        }
        .padding()
        .glassCard()
    }
}

// MARK: - Notifications View
struct NotificationsView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var dailyReminders = true
    @State private var challengeAlerts = true
    @State private var achievementNotifications = true
    @State private var weeklyProgress = false
    
    var body: some View {
        NavigationView {
            ZStack {
                DesignSystem.backgroundColor
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Notification Preferences")
                                .font(.system(size: 24))
                                .foregroundColor(.white)
                            
                            VStack(spacing: 12) {
                                NotificationToggle(title: "Daily Learning Reminders", subtitle: "Get reminded to study every day", isOn: $dailyReminders)
                                NotificationToggle(title: "Challenge Alerts", subtitle: "Notifications for new challenges", isOn: $challengeAlerts)
                                NotificationToggle(title: "Achievement Unlocked", subtitle: "Celebrate your milestones", isOn: $achievementNotifications)
                                NotificationToggle(title: "Weekly Progress Report", subtitle: "Summary of your weekly progress", isOn: $weeklyProgress)
                            }
                        }
                        .padding()
                        .glassCard()
                        
                        Text("Note: Notification settings are saved locally on your device.")
                            .font(.system(size: 13))
                            .foregroundColor(.white.opacity(0.5))
                            .multilineTextAlignment(.center)
                    }
                    .padding()
                }
            }
            .navigationTitle("Notifications")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(trailing: Button("Done") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}

struct NotificationToggle: View {
    let title: String
    let subtitle: String
    @Binding var isOn: Bool
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 16))
                    .foregroundColor(.white)
                
                Text(subtitle)
                    .font(.system(size: 13))
                    .foregroundColor(.white.opacity(0.6))
            }
            
            Spacer()
            
            Toggle("", isOn: $isOn)
                .labelsHidden()
                .tint(DesignSystem.primaryColor)
        }
        .padding()
        .background(DesignSystem.glassBackground)
        .cornerRadius(12)
    }
}

// MARK: - Appearance View
struct AppearanceView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var selectedTheme = "Dark"
    let themes = ["Dark", "Light", "System"]
    
    var body: some View {
        NavigationView {
            ZStack {
                DesignSystem.backgroundColor
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Theme")
                                .font(.system(size: 24))
                                .foregroundColor(.white)
                            
                            VStack(spacing: 12) {
                                ForEach(themes, id: \.self) { theme in
                                    Button(action: { selectedTheme = theme }) {
                                        HStack {
                                            Text(theme)
                                                .font(.system(size: 17))
                                                .foregroundColor(.white)
                                            
                                            Spacer()
                                            
                                            if selectedTheme == theme {
                                                Image(systemName: "checkmark.circle.fill")
                                                    .foregroundColor(DesignSystem.primaryColor)
                                            }
                                        }
                                        .padding()
                                        .background(DesignSystem.glassBackground)
                                        .cornerRadius(12)
                                    }
                                }
                            }
                        }
                        .padding()
                        .glassCard()
                        
                        Text("Currently, EduSphere uses a fixed dark theme with glassmorphism design.")
                            .font(.system(size: 13))
                            .foregroundColor(.white.opacity(0.5))
                            .multilineTextAlignment(.center)
                    }
                    .padding()
                }
            }
            .navigationTitle("Appearance")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(trailing: Button("Done") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}

// MARK: - Help & Support View
struct HelpSupportView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            ZStack {
                DesignSystem.backgroundColor
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Frequently Asked Questions")
                                .font(.system(size: 24))
                                .foregroundColor(.white)
                            
                            VStack(spacing: 12) {
                                FAQCard(question: "How do I start learning?", answer: "Navigate to the Lessons tab and select a lesson that matches your interests. Each lesson includes interactive content and quizzes.")
                                
                                FAQCard(question: "What are challenges?", answer: "Challenges are daily and weekly tasks that help you stay motivated and practice regularly. Complete them to earn bonus points!")
                                
                                FAQCard(question: "How does AI Feedback work?", answer: "During interactive lessons, you can submit your practice work and receive personalized AI-generated feedback on your strengths and areas to improve.")
                                
                                FAQCard(question: "Can I track my progress?", answer: "Yes! Check the Progress & Stats section in your Profile to see detailed analytics of your learning journey.")
                            }
                        }
                        .padding()
                        .glassCard()
                        
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Contact Support")
                                .font(.system(size: 24))
                                .foregroundColor(.white)
                            
                            Text("Need more help? Reach out to us at:")
                                .font(.system(size: 15))
                                .foregroundColor(.white.opacity(0.7))
                            
                            Text("support@edusphere.com")
                                .font(.system(size: 17))
                                .foregroundColor(DesignSystem.primaryColor)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .glassCard()
                    }
                    .padding()
                }
            }
            .navigationTitle("Help & Support")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(trailing: Button("Done") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}

struct FAQCard: View {
    let question: String
    let answer: String
    @State private var isExpanded = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Button(action: { isExpanded.toggle() }) {
                HStack {
                    Text(question)
                        .font(.system(size: 16))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.leading)
                    
                    Spacer()
                    
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .foregroundColor(.white.opacity(0.5))
                }
            }
            
            if isExpanded {
                Text(answer)
                    .font(.system(size: 14))
                    .foregroundColor(.white.opacity(0.8))
                    .multilineTextAlignment(.leading)
            }
        }
        .padding()
        .background(DesignSystem.glassBackground)
        .cornerRadius(12)
    }
}

// MARK: - About View
struct AboutView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            ZStack {
                DesignSystem.backgroundColor
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 30) {
                        // App Icon
                        Image(systemName: "graduationcap.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .foregroundColor(DesignSystem.primaryColor)
                        
                        VStack(spacing: 8) {
                            Text("EduSphere")
                                .font(.system(size: 32))
                                .foregroundColor(.white)
                            
                            Text("Version 1.0.0")
                                .font(.system(size: 15))
                                .foregroundColor(.white.opacity(0.7))
                        }
                        
                        VStack(alignment: .leading, spacing: 16) {
                            Text("About")
                                .font(.system(size: 24))
                                .foregroundColor(.white)
                            
                            Text("EduSphere is your personal learning companion, designed to help you master new languages, skills, and subjects through interactive lessons, AI-powered feedback, and engaging challenges.")
                                .font(.system(size: 15))
                                .foregroundColor(.white.opacity(0.8))
                                .multilineTextAlignment(.leading)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .glassCard()
                        
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Features")
                                .font(.system(size: 24))
                                .foregroundColor(.white)
                            
                            VStack(alignment: .leading, spacing: 12) {
                                FeatureRow(icon: "book.fill", title: "Interactive Lessons", description: "Learn at your own pace")
                                FeatureRow(icon: "trophy.fill", title: "Daily Challenges", description: "Stay motivated with goals")
                                FeatureRow(icon: "brain.head.profile", title: "AI Feedback", description: "Personalized improvement tips")
                                FeatureRow(icon: "chart.line.uptrend.xyaxis", title: "Progress Tracking", description: "Monitor your growth")
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .glassCard()
                        
                        VStack(spacing: 8) {
                            Text("© 2025 EduSphere")
                                .font(.system(size: 13))
                                .foregroundColor(.white.opacity(0.5))
                            
                            Text("Made with ♥ for learners worldwide")
                                .font(.system(size: 13))
                                .foregroundColor(.white.opacity(0.5))
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("About EduSphere")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(trailing: Button("Done") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}

struct FeatureRow: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(DesignSystem.primaryColor)
                .frame(width: 30)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 16))
                    .foregroundColor(.white)
                
                Text(description)
                    .font(.system(size: 13))
                    .foregroundColor(.white.opacity(0.6))
            }
            
            Spacer()
        }
    }
}

