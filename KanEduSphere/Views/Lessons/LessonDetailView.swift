//
//  LessonDetailView.swift
//  KanEduSphere
//

import SwiftUI

struct LessonDetailView: View {
    @EnvironmentObject var viewModel: AppViewModel
    @Environment(\.presentationMode) var presentationMode
    let lesson: Lesson
    
    @State private var currentContentIndex = 0
    @State private var showQuiz = false
    @State private var selectedAnswers: [UUID: Int] = [:]
    @State private var showResults = false
    @State private var showFeedback = false
    @State private var userInput = ""
    
    var body: some View {
        ZStack {
            DesignSystem.backgroundColor
                .ignoresSafeArea()
            
            if showQuiz {
                quizView
            } else {
                lessonContentView
            }
        }
        .navigationTitle(lesson.title)
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private var lessonContentView: some View {
        VStack(spacing: 20) {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    lessonHeader
                    
                    if currentContentIndex < lesson.content.count {
                        contentCard
                    }
                }
                .padding()
            }
            
            navigationBar
                .padding()
        }
    }
    
    private var lessonHeader: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(lesson.category.rawValue)
                        .font(.system(size: 14))
                        .foregroundColor(DesignSystem.primaryColor)
                    
                    Text(lesson.difficulty.rawValue)
                        .font(.system(size: 14))
                        .foregroundColor(.white.opacity(0.7))
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    HStack {
                        Image(systemName: "clock")
                        Text("\(lesson.duration) min")
                    }
                    .font(.system(size: 14))
                    .foregroundColor(.white.opacity(0.7))
                    
                    HStack {
                        Image(systemName: "star.fill")
                        Text("\(lesson.points) pts")
                    }
                    .font(.system(size: 14))
                    .foregroundColor(DesignSystem.primaryColor)
                }
            }
            
            Text(lesson.description)
                .font(.system(size: 15))
                .foregroundColor(.white.opacity(0.8))
            
            ProgressView(value: Double(currentContentIndex) / Double(lesson.content.count))
                .progressViewStyle(LinearProgressViewStyle(tint: DesignSystem.primaryColor))
        }
        .padding()
        .glassCard()
    }
    
    private var contentCard: some View {
        let content = lesson.content[currentContentIndex]
        
        return VStack(alignment: .leading, spacing: 16) {
            Text(content.text)
                .font(.system(size: 17))
                .foregroundColor(.white)
            
            if content.type == .interactive {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Your Practice:")
                        .font(.system(size: 15))
                        .foregroundColor(DesignSystem.primaryColor)
                    
                    TextField("Type here...", text: $userInput)
                        .padding()
                        .background(DesignSystem.glassBackground)
                        .cornerRadius(12)
                        .foregroundColor(.white)
                    
                    Button("Get AI Feedback") {
                        viewModel.generateFeedback(
                            for: lesson.id,
                            input: userInput,
                            type: .pronunciation
                        )
                        showFeedback = true
                    }
                    .buttonStyle(PrimaryButtonStyle())
                    .disabled(userInput.isEmpty)
                    .opacity(userInput.isEmpty ? 0.5 : 1.0)
                }
            }
        }
        .padding()
        .glassCard()
        .sheet(isPresented: $showFeedback) {
            if let feedback = viewModel.feedbackHistory.last {
                FeedbackView(feedback: feedback)
            }
        }
    }
    
    private var navigationBar: some View {
        HStack(spacing: 16) {
            if currentContentIndex > 0 {
                Button("Previous") {
                    currentContentIndex -= 1
                }
                .buttonStyle(SecondaryButtonStyle())
            }
            
            if currentContentIndex < lesson.content.count - 1 {
                Button("Next") {
                    currentContentIndex += 1
                    updateProgress()
                }
                .buttonStyle(PrimaryButtonStyle())
            } else {
                Button("Take Quiz") {
                    showQuiz = true
                    updateProgress()
                }
                .buttonStyle(PrimaryButtonStyle())
            }
        }
    }
    
    private var quizView: some View {
        VStack(spacing: 20) {
            if showResults {
                quizResults
            } else {
                ScrollView {
                    VStack(spacing: 20) {
                        Text("Quiz Time!")
                            .font(.system(size: 28))
                            .foregroundColor(.white)
                        
                        ForEach(lesson.quizQuestions) { question in
                            QuizQuestionCard(
                                question: question,
                                selectedAnswer: selectedAnswers[question.id],
                                onSelect: { index in
                                    selectedAnswers[question.id] = index
                                }
                            )
                        }
                    }
                    .padding()
                }
                
                Button("Submit Quiz") {
                    showResults = true
                }
                .buttonStyle(PrimaryButtonStyle())
                .padding()
                .disabled(selectedAnswers.count != lesson.quizQuestions.count)
                .opacity(selectedAnswers.count != lesson.quizQuestions.count ? 0.5 : 1.0)
            }
        }
    }
    
    private var quizResults: some View {
        let correctAnswers = lesson.quizQuestions.filter { question in
            selectedAnswers[question.id] == question.correctAnswer
        }.count
        
        let percentage = (Double(correctAnswers) / Double(lesson.quizQuestions.count)) * 100
        
        return VStack(spacing: 30) {
            Spacer()
            
            Image(systemName: percentage >= 70 ? "checkmark.circle.fill" : "xmark.circle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .foregroundColor(percentage >= 70 ? DesignSystem.primaryColor : .red)
            
            Text("\(Int(percentage))%")
                .font(.system(size: 48))
                .foregroundColor(.white)
            
            Text("\(correctAnswers) out of \(lesson.quizQuestions.count) correct")
                .font(.system(size: 17))
                .foregroundColor(.white.opacity(0.8))
            
            if percentage >= 70 {
                Text("🎉 Congratulations!")
                    .font(.system(size: 24))
                    .foregroundColor(DesignSystem.primaryColor)
                
                Text("You earned \(lesson.points) points!")
                    .font(.system(size: 17))
                    .foregroundColor(.white)
            } else {
                Text("Keep practicing!")
                    .font(.system(size: 24))
                    .foregroundColor(.white)
                
                Text("You need 70% to pass")
                    .font(.system(size: 17))
                    .foregroundColor(.white.opacity(0.8))
            }
            
            Spacer()
            
            Button(percentage >= 70 ? "Complete Lesson" : "Try Again") {
                if percentage >= 70 {
                    viewModel.completeLesson(lesson.id)
                    presentationMode.wrappedValue.dismiss()
                } else {
                    selectedAnswers.removeAll()
                    showResults = false
                }
            }
            .buttonStyle(PrimaryButtonStyle())
            .padding()
        }
    }
    
    private func updateProgress() {
        let progress = Double(currentContentIndex + 1) / Double(lesson.content.count)
        viewModel.updateLessonProgress(lesson.id, progress: progress)
    }
}

struct QuizQuestionCard: View {
    let question: QuizQuestion
    let selectedAnswer: Int?
    let onSelect: (Int) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(question.question)
                .font(.system(size: 17))
                .foregroundColor(.white)
            
            ForEach(0..<question.options.count, id: \.self) { index in
                Button(action: { onSelect(index) }) {
                    HStack {
                        Text(question.options[index])
                            .font(.system(size: 15))
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        if selectedAnswer == index {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(DesignSystem.primaryColor)
                        }
                    }
                    .padding()
                    .background(
                        selectedAnswer == index ?
                        DesignSystem.primaryColor.opacity(0.2) :
                        DesignSystem.glassBackground
                    )
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(
                                selectedAnswer == index ?
                                DesignSystem.primaryColor :
                                Color.white.opacity(0.3),
                                lineWidth: 1
                            )
                    )
                }
            }
        }
        .padding()
        .glassCard()
    }
}

struct FeedbackView: View {
    let feedback: AIFeedback
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack {
            DesignSystem.backgroundColor
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    Text("AI Feedback")
                        .font(.system(size: 28))
                        .foregroundColor(.white)
                    
                    VStack(spacing: 8) {
                        Text("Score")
                            .font(.system(size: 17))
                            .foregroundColor(.white.opacity(0.7))
                        
                        Text("\(Int(feedback.score * 100))%")
                            .font(.system(size: 48))
                            .foregroundColor(DesignSystem.primaryColor)
                    }
                    .padding()
                    .glassCard()
                    
                    FeedbackSection(title: "Strengths", items: feedback.strengths, icon: "checkmark.circle.fill")
                    
                    FeedbackSection(title: "Areas to Improve", items: feedback.areasToImprove, icon: "exclamationmark.triangle.fill")
                    
                    FeedbackSection(title: "Suggestions", items: feedback.suggestions, icon: "lightbulb.fill")
                    
                    Button("Close") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .buttonStyle(PrimaryButtonStyle())
                }
                .padding()
            }
        }
    }
}

struct FeedbackSection: View {
    let title: String
    let items: [String]
    let icon: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(DesignSystem.primaryColor)
                Text(title)
                    .font(.system(size: 20))
                    .foregroundColor(.white)
            }
            
            ForEach(items, id: \.self) { item in
                HStack(alignment: .top, spacing: 8) {
                    Text("•")
                        .foregroundColor(DesignSystem.primaryColor)
                    Text(item)
                        .font(.system(size: 15))
                        .foregroundColor(.white.opacity(0.8))
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .glassCard()
    }
}

