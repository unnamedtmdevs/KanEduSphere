//
//  MainTabView.swift
//  KanEduSphere
//

import SwiftUI

struct MainTabView: View {
    @EnvironmentObject var viewModel: AppViewModel
    
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Image(systemName: "book.fill")
                    Text("Lessons")
                }
                .environmentObject(viewModel)
            
            ChallengesView()
                .tabItem {
                    Image(systemName: "trophy.fill")
                    Text("Challenges")
                }
                .environmentObject(viewModel)
            
            CollaborationView()
                .tabItem {
                    Image(systemName: "person.3.fill")
                    Text("Collaborate")
                }
                .environmentObject(viewModel)
            
            ProfileView()
                .tabItem {
                    Image(systemName: "person.crop.circle.fill")
                    Text("Profile")
                }
                .environmentObject(viewModel)
        }
        .accentColor(DesignSystem.primaryColor)
    }
}

