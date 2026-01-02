//
//  OnboardingView.swift
//  KanEduSphere
//

import SwiftUI

struct OnboardingView: View {
    @EnvironmentObject var viewModel: AppViewModel
    @State private var currentPage = 0
    @State private var userName = ""
    @State private var userEmail = ""
    @State private var selectedInterests: Set<String> = []
    
    let availableInterests = ["Languages", "Mathematics", "Science", "Programming", "Arts", "Business"]
    
    var body: some View {
        ZStack {
            DesignSystem.backgroundColor
                .ignoresSafeArea()
            
            VStack {
                if currentPage == 0 {
                    welcomePage
                } else if currentPage == 1 {
                    profilePage
                } else if currentPage == 2 {
                    interestsPage
                }
                
                Spacer()
                
                navigationButtons
                    .padding()
            }
            .padding()
        }
    }
    
    private var welcomePage: some View {
        VStack(spacing: 30) {
            Spacer()
            
            Image(systemName: "graduationcap.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .foregroundColor(DesignSystem.primaryColor)
            
            Text("Welcome to EduSphere")
                .font(.system(size: 34))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
            
            Text("Master new skills, languages, and subjects with interactive lessons, AI-powered feedback, and collaborative learning")
                .font(.system(size: 17))
                .foregroundColor(.white.opacity(0.8))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 20)
            
            Spacer()
        }
    }
    
    private var profilePage: some View {
        VStack(spacing: 30) {
            Spacer()
            
            Image(systemName: "person.circle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
                .foregroundColor(DesignSystem.primaryColor)
            
            Text("Create Your Profile")
                .font(.system(size: 28))
                .foregroundColor(.white)
            
            VStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Name")
                        .font(.system(size: 15))
                        .foregroundColor(.white.opacity(0.7))
                    
                    TextField("Enter your name", text: $userName)
                        .padding()
                        .background(DesignSystem.glassBackground)
                        .cornerRadius(12)
                        .foregroundColor(.white)
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Email")
                        .font(.system(size: 15))
                        .foregroundColor(.white.opacity(0.7))
                    
                    TextField("Enter your email", text: $userEmail)
                        .padding()
                        .background(DesignSystem.glassBackground)
                        .cornerRadius(12)
                        .foregroundColor(.white)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                }
            }
            .padding(.horizontal, 20)
            
            Spacer()
        }
    }
    
    private var interestsPage: some View {
        VStack(spacing: 30) {
            Spacer()
            
            Image(systemName: "heart.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
                .foregroundColor(DesignSystem.primaryColor)
            
            Text("Choose Your Interests")
                .font(.system(size: 28))
                .foregroundColor(.white)
            
            Text("Select topics you want to learn")
                .font(.system(size: 17))
                .foregroundColor(.white.opacity(0.8))
            
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                ForEach(availableInterests, id: \.self) { interest in
                    Button(action: {
                        if selectedInterests.contains(interest) {
                            selectedInterests.remove(interest)
                        } else {
                            selectedInterests.insert(interest)
                        }
                    }) {
                        Text(interest)
                            .font(.system(size: 15))
                            .foregroundColor(selectedInterests.contains(interest) ? .black : .white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(
                                selectedInterests.contains(interest) ?
                                DesignSystem.primaryColor :
                                DesignSystem.glassBackground
                            )
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.white.opacity(selectedInterests.contains(interest) ? 0 : 0.3), lineWidth: 1)
                            )
                    }
                }
            }
            .padding(.horizontal, 20)
            
            Spacer()
        }
    }
    
    private var navigationButtons: some View {
        HStack(spacing: 16) {
            if currentPage > 0 {
                Button("Back") {
                    withAnimation {
                        currentPage -= 1
                    }
                }
                .buttonStyle(SecondaryButtonStyle())
            }
            
            Button(currentPage == 2 ? "Get Started" : "Next") {
                if currentPage < 2 {
                    withAnimation {
                        currentPage += 1
                    }
                } else {
                    completeOnboarding()
                }
            }
            .buttonStyle(PrimaryButtonStyle())
            .disabled(currentPage == 1 && (userName.isEmpty || userEmail.isEmpty))
            .opacity(currentPage == 1 && (userName.isEmpty || userEmail.isEmpty) ? 0.5 : 1.0)
        }
    }
    
    private func completeOnboarding() {
        viewModel.completeOnboarding(
            name: userName,
            email: userEmail,
            interests: Array(selectedInterests)
        )
    }
}

