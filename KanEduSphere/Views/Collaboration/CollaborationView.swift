//
//  CollaborationView.swift
//  KanEduSphere
//

import SwiftUI

struct CollaborationView: View {
    @EnvironmentObject var viewModel: AppViewModel
    @State private var selectedCategory: LessonCategory?
    
    var filteredGroups: [CollaborationGroup] {
        if let category = selectedCategory {
            return viewModel.groups.filter { $0.category == category }
        }
        return viewModel.groups
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
                        
                        groupsList
                    }
                    .padding()
                }
            }
            .navigationTitle("Collaborate")
            .navigationBarTitleDisplayMode(.large)
        }
    }
    
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Study Groups")
                .font(.system(size: 24))
                .foregroundColor(.white)
            
            Text("Join groups to learn together and share knowledge with peers")
                .font(.system(size: 15))
                .foregroundColor(.white.opacity(0.7))
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
    
    private var groupsList: some View {
        VStack(spacing: 16) {
            ForEach(filteredGroups) { group in
                NavigationLink(destination: GroupDetailView(group: group)) {
                    GroupCard(group: group)
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
    }
}

struct GroupCard: View {
    let group: CollaborationGroup
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(group.name)
                        .font(.system(size: 18))
                        .foregroundColor(.white)
                    
                    Text(group.category.rawValue)
                        .font(.system(size: 14))
                        .foregroundColor(DesignSystem.primaryColor)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(.white.opacity(0.5))
            }
            
            Text(group.description)
                .font(.system(size: 15))
                .foregroundColor(.white.opacity(0.8))
                .lineLimit(2)
            
            HStack(spacing: 16) {
                Label("\(group.members.count)/\(group.maxMembers)", systemImage: "person.2.fill")
                    .font(.system(size: 14))
                    .foregroundColor(.white.opacity(0.7))
                
                Label("\(group.messages.count) messages", systemImage: "message.fill")
                    .font(.system(size: 14))
                    .foregroundColor(.white.opacity(0.7))
            }
            
            if group.isFull {
                Text("Group Full")
                    .font(.system(size: 13))
                    .foregroundColor(.red)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color.red.opacity(0.2))
                    .cornerRadius(8)
            }
        }
        .padding()
        .glassCard()
    }
}

struct GroupDetailView: View {
    @EnvironmentObject var viewModel: AppViewModel
    let group: CollaborationGroup
    
    @State private var newMessage = ""
    @State private var isMember = false
    
    var currentGroup: CollaborationGroup {
        viewModel.groups.first { $0.id == group.id } ?? group
    }
    
    var body: some View {
        ZStack {
            DesignSystem.backgroundColor
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                ScrollView {
                    VStack(spacing: 20) {
                        groupHeader
                        
                        membersSection
                        
                        messagesSection
                    }
                    .padding()
                }
                
                if isMember {
                    messageInput
                }
            }
        }
        .navigationTitle(currentGroup.name)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            checkMembership()
        }
    }
    
    private var groupHeader: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(currentGroup.category.rawValue)
                        .font(.system(size: 15))
                        .foregroundColor(DesignSystem.primaryColor)
                    
                    Text("Created by \(currentGroup.createdBy)")
                        .font(.system(size: 13))
                        .foregroundColor(.white.opacity(0.7))
                }
                
                Spacer()
            }
            
            Text(currentGroup.description)
                .font(.system(size: 15))
                .foregroundColor(.white.opacity(0.8))
            
            HStack {
                Text("\(currentGroup.members.count) / \(currentGroup.maxMembers) members")
                    .font(.system(size: 14))
                    .foregroundColor(.white.opacity(0.7))
                
                Spacer()
                
                if !isMember && !currentGroup.isFull {
                    Button("Join Group") {
                        viewModel.joinGroup(currentGroup.id)
                        isMember = true
                    }
                    .buttonStyle(PrimaryButtonStyle())
                    .frame(width: 120)
                }
            }
        }
        .padding()
        .glassCard()
    }
    
    private var membersSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Members")
                .font(.system(size: 20))
                .foregroundColor(.white)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(currentGroup.members) { member in
                        MemberBadge(member: member)
                    }
                }
            }
        }
    }
    
    private var messagesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Messages")
                .font(.system(size: 20))
                .foregroundColor(.white)
            
            ForEach(currentGroup.messages) { message in
                MessageBubble(message: message, isCurrentUser: message.senderName == viewModel.currentUser?.name)
            }
        }
    }
    
    private var messageInput: some View {
        HStack(spacing: 12) {
            TextField("Type a message...", text: $newMessage)
                .padding()
                .background(DesignSystem.glassBackground)
                .cornerRadius(20)
                .foregroundColor(.white)
            
            Button(action: sendMessage) {
                Image(systemName: "arrow.up.circle.fill")
                    .font(.system(size: 32))
                    .foregroundColor(newMessage.isEmpty ? .gray : DesignSystem.primaryColor)
            }
            .disabled(newMessage.isEmpty)
        }
        .padding()
        .background(DesignSystem.backgroundColor)
    }
    
    private func checkMembership() {
        guard let user = viewModel.currentUser else { return }
        isMember = currentGroup.members.contains { $0.name == user.name }
    }
    
    private func sendMessage() {
        guard !newMessage.isEmpty else { return }
        viewModel.sendMessage(to: currentGroup.id, content: newMessage)
        newMessage = ""
    }
}

struct MemberBadge: View {
    let member: GroupMember
    
    var body: some View {
        VStack(spacing: 8) {
            Circle()
                .fill(Color(hex: member.avatarColor))
                .frame(width: 50, height: 50)
                .overlay(
                    Text(String(member.name.prefix(1)))
                        .font(.system(size: 20))
                        .foregroundColor(.black)
                )
            
            Text(member.name)
                .font(.system(size: 12))
                .foregroundColor(.white)
                .lineLimit(1)
                .frame(width: 70)
        }
    }
}

struct MessageBubble: View {
    let message: GroupMessage
    let isCurrentUser: Bool
    
    var body: some View {
        HStack {
            if isCurrentUser {
                Spacer()
            }
            
            VStack(alignment: isCurrentUser ? .trailing : .leading, spacing: 4) {
                if !isCurrentUser {
                    Text(message.senderName)
                        .font(.system(size: 12))
                        .foregroundColor(DesignSystem.primaryColor)
                }
                
                Text(message.content)
                    .font(.system(size: 15))
                    .foregroundColor(.white)
                    .padding(12)
                    .background(
                        isCurrentUser ?
                        DesignSystem.primaryColor.opacity(0.3) :
                        DesignSystem.glassBackground
                    )
                    .cornerRadius(16)
                
                Text(formatTime(message.timestamp))
                    .font(.system(size: 11))
                    .foregroundColor(.white.opacity(0.5))
            }
            
            if !isCurrentUser {
                Spacer()
            }
        }
    }
    
    private func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

