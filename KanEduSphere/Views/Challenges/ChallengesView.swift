//
//  ChallengesView.swift
//  KanEduSphere
//

import SwiftUI

struct ChallengesView: View {
    @EnvironmentObject var viewModel: AppViewModel
    @State private var selectedType: ChallengeType?
    
    var filteredChallenges: [Challenge] {
        if let type = selectedType {
            return viewModel.challenges.filter { $0.type == type }
        }
        return viewModel.challenges
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                DesignSystem.backgroundColor
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        headerSection
                        
                        typeFilter
                        
                        challengesList
                    }
                    .padding()
                }
            }
            .navigationTitle("Challenges")
            .navigationBarTitleDisplayMode(.large)
        }
    }
    
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Daily Challenges")
                .font(.system(size: 24))
                .foregroundColor(.white)
            
            Text("Complete challenges to earn bonus points and maintain your streak!")
                .font(.system(size: 15))
                .foregroundColor(.white.opacity(0.7))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var typeFilter: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                CategoryChip(
                    title: "All",
                    isSelected: selectedType == nil,
                    action: { selectedType = nil }
                )
                
                CategoryChip(
                    title: "Daily",
                    isSelected: selectedType == .daily,
                    action: { selectedType = .daily }
                )
                
                CategoryChip(
                    title: "Weekly",
                    isSelected: selectedType == .weekly,
                    action: { selectedType = .weekly }
                )
                
                CategoryChip(
                    title: "Special",
                    isSelected: selectedType == .special,
                    action: { selectedType = .special }
                )
            }
        }
    }
    
    private var challengesList: some View {
        VStack(spacing: 16) {
            ForEach(filteredChallenges) { challenge in
                NavigationLink(destination: ChallengeDetailView(challenge: challenge)) {
                    ChallengeCard(challenge: challenge)
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
    }
}

struct ChallengeCard: View {
    let challenge: Challenge
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(challenge.title)
                        .font(.system(size: 18))
                        .foregroundColor(.white)
                    
                    Text(challenge.type.rawValue)
                        .font(.system(size: 14))
                        .foregroundColor(DesignSystem.primaryColor)
                }
                
                Spacer()
                
                if challenge.isCompleted {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 24))
                        .foregroundColor(DesignSystem.primaryColor)
                }
            }
            
            Text(challenge.description)
                .font(.system(size: 15))
                .foregroundColor(.white.opacity(0.8))
                .lineLimit(2)
            
            HStack {
                Image(systemName: "star.fill")
                    .font(.system(size: 14))
                Text("\(challenge.points) points")
                    .font(.system(size: 14))
                
                Spacer()
                
                Image(systemName: "clock")
                    .font(.system(size: 14))
                Text(timeRemaining(until: challenge.expiryDate))
                    .font(.system(size: 14))
            }
            .foregroundColor(.white.opacity(0.7))
            
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("Progress")
                        .font(.system(size: 13))
                        .foregroundColor(.white.opacity(0.7))
                    
                    Spacer()
                    
                    Text("\(Int(challenge.progress * 100))%")
                        .font(.system(size: 13))
                        .foregroundColor(DesignSystem.primaryColor)
                }
                
                ProgressView(value: challenge.progress)
                    .progressViewStyle(LinearProgressViewStyle(tint: DesignSystem.primaryColor))
            }
        }
        .padding()
        .glassCard()
    }
    
    private func timeRemaining(until date: Date) -> String {
        let components = Calendar.current.dateComponents([.hour, .minute], from: Date(), to: date)
        if let hours = components.hour, let minutes = components.minute {
            if hours > 24 {
                let days = hours / 24
                return "\(days) days"
            } else if hours > 0 {
                return "\(hours)h \(minutes)m"
            } else {
                return "\(minutes)m"
            }
        }
        return "Expired"
    }
}

struct ChallengeDetailView: View {
    @EnvironmentObject var viewModel: AppViewModel
    @Environment(\.presentationMode) var presentationMode
    let challenge: Challenge
    
    var currentChallenge: Challenge {
        viewModel.challenges.first { $0.id == challenge.id } ?? challenge
    }
    
    var body: some View {
        ZStack {
            DesignSystem.backgroundColor
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    headerCard
                    
                    tasksSection
                    
                    if !currentChallenge.isCompleted {
                        completeButton
                    }
                }
                .padding()
            }
        }
        .navigationTitle("Challenge")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private var headerCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(currentChallenge.title)
                        .font(.system(size: 24))
                        .foregroundColor(.white)
                    
                    Text(currentChallenge.type.rawValue)
                        .font(.system(size: 15))
                        .foregroundColor(DesignSystem.primaryColor)
                }
                
                Spacer()
            }
            
            Text(currentChallenge.description)
                .font(.system(size: 15))
                .foregroundColor(.white.opacity(0.8))
            
            HStack(spacing: 20) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Reward")
                        .font(.system(size: 13))
                        .foregroundColor(.white.opacity(0.7))
                    
                    HStack {
                        Image(systemName: "star.fill")
                        Text("\(currentChallenge.points) points")
                    }
                    .font(.system(size: 15))
                    .foregroundColor(DesignSystem.primaryColor)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text("Expires")
                        .font(.system(size: 13))
                        .foregroundColor(.white.opacity(0.7))
                    
                    Text(formatDate(currentChallenge.expiryDate))
                        .font(.system(size: 15))
                        .foregroundColor(.white)
                }
            }
            
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("Overall Progress")
                        .font(.system(size: 15))
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Text("\(Int(currentChallenge.progress * 100))%")
                        .font(.system(size: 15))
                        .foregroundColor(DesignSystem.primaryColor)
                }
                
                ProgressView(value: currentChallenge.progress)
                    .progressViewStyle(LinearProgressViewStyle(tint: DesignSystem.primaryColor))
            }
        }
        .padding()
        .glassCard()
    }
    
    private var tasksSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Tasks")
                .font(.system(size: 20))
                .foregroundColor(.white)
            
            ForEach(currentChallenge.tasks) { task in
                TaskRow(
                    task: task,
                    isCompleted: currentChallenge.completedTasks.contains(task.id),
                    onToggle: {
                        viewModel.completeTask(in: currentChallenge.id, taskId: task.id)
                    }
                )
            }
        }
    }
    
    private var completeButton: some View {
        Button("Mark Challenge Complete") {
            viewModel.completeChallenge(currentChallenge.id)
            presentationMode.wrappedValue.dismiss()
        }
        .buttonStyle(PrimaryButtonStyle())
        .disabled(currentChallenge.progress < 1.0)
        .opacity(currentChallenge.progress < 1.0 ? 0.5 : 1.0)
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

struct TaskRow: View {
    let task: ChallengeTask
    let isCompleted: Bool
    let onToggle: () -> Void
    
    var body: some View {
        Button(action: onToggle) {
            HStack(spacing: 12) {
                Image(systemName: isCompleted ? "checkmark.circle.fill" : "circle")
                    .font(.system(size: 24))
                    .foregroundColor(isCompleted ? DesignSystem.primaryColor : .white.opacity(0.3))
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(task.description)
                        .font(.system(size: 15))
                        .foregroundColor(.white)
                        .strikethrough(isCompleted, color: .white)
                    
                    Text("\(task.currentCount)/\(task.requiredCount) completed")
                        .font(.system(size: 13))
                        .foregroundColor(.white.opacity(0.7))
                }
                
                Spacer()
            }
            .padding()
            .glassCard()
        }
        .disabled(isCompleted)
    }
}

