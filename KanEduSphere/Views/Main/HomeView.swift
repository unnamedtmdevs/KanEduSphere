//
//  HomeView.swift
//  KanEduSphere
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var viewModel: AppViewModel
    @State private var selectedCategory: LessonCategory?
    @State private var searchText = ""
    
    var filteredLessons: [Lesson] {
        var lessons = viewModel.lessons
        
        if let category = selectedCategory {
            lessons = lessons.filter { $0.category == category }
        }
        
        if !searchText.isEmpty {
            lessons = lessons.filter { $0.title.localizedCaseInsensitiveContains(searchText) ||
                $0.description.localizedCaseInsensitiveContains(searchText) }
        }
        
        return lessons
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                DesignSystem.backgroundColor
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        headerSection
                        
                        categoryFilter
                        
                        lessonsGrid
                    }
                    .padding()
                }
            }
            .navigationTitle("Lessons")
            .navigationBarTitleDisplayMode(.large)
        }
    }
    
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            if let user = viewModel.currentUser {
                Text("Hello, \(user.name)! 👋")
                    .font(.system(size: 28))
                    .foregroundColor(.white)
                
                HStack(spacing: 20) {
                    StatCard(title: "Points", value: "\(user.totalPoints)", icon: "star.fill")
                    StatCard(title: "Streak", value: "\(user.currentStreak)", icon: "flame.fill")
                    StatCard(title: "Lessons", value: "\(user.completedLessons.count)", icon: "checkmark.circle.fill")
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var categoryFilter: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                CategoryChip(
                    title: "All",
                    isSelected: selectedCategory == nil,
                    action: { selectedCategory = nil }
                )
                
                ForEach(LessonCategory.allCases, id: \.self) { category in
                    CategoryChip(
                        title: category.rawValue,
                        isSelected: selectedCategory == category,
                        action: { selectedCategory = category }
                    )
                }
            }
        }
    }
    
    private var lessonsGrid: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
            ForEach(filteredLessons) { lesson in
                NavigationLink(destination: LessonDetailView(lesson: lesson)) {
                    LessonCard(lesson: lesson)
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(DesignSystem.primaryColor)
            
            Text(value)
                .font(.system(size: 20))
                .foregroundColor(.white)
            
            Text(title)
                .font(.system(size: 12))
                .foregroundColor(.white.opacity(0.7))
        }
        .frame(maxWidth: .infinity)
        .padding()
        .glassCard()
    }
}

struct CategoryChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 15))
                .foregroundColor(isSelected ? .black : .white)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(isSelected ? DesignSystem.primaryColor : DesignSystem.glassBackground)
                .cornerRadius(20)
        }
    }
}

struct LessonCard: View {
    let lesson: Lesson
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: categoryIcon(for: lesson.category))
                    .foregroundColor(DesignSystem.primaryColor)
                    .font(.system(size: 24))
                
                Spacer()
                
                if lesson.isCompleted {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(DesignSystem.primaryColor)
                }
            }
            
            Text(lesson.title)
                .font(.system(size: 16))
                .foregroundColor(.white)
                .lineLimit(2)
                .multilineTextAlignment(.leading)
            
            HStack {
                Image(systemName: "clock")
                    .font(.system(size: 12))
                Text("\(lesson.duration) min")
                    .font(.system(size: 12))
            }
            .foregroundColor(.white.opacity(0.7))
            
            HStack {
                Image(systemName: "star.fill")
                    .font(.system(size: 12))
                Text("\(lesson.points) pts")
                    .font(.system(size: 12))
            }
            .foregroundColor(DesignSystem.primaryColor)
            
            if lesson.progress > 0 && !lesson.isCompleted {
                ProgressView(value: lesson.progress)
                    .progressViewStyle(LinearProgressViewStyle(tint: DesignSystem.primaryColor))
            }
        }
        .padding()
        .frame(height: 180)
        .glassCard()
    }
    
    private func categoryIcon(for category: LessonCategory) -> String {
        switch category {
        case .language: return "text.bubble.fill"
        case .mathematics: return "function"
        case .science: return "atom"
        case .arts: return "paintbrush.fill"
        case .programming: return "chevron.left.forwardslash.chevron.right"
        case .business: return "briefcase.fill"
        }
    }
}

