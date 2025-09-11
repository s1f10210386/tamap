//
//  NotificationView.swift
//  tamap
//
//  Created by AI Assistant on 2025/08/20.
//

import SwiftUI

struct NotificationView: View {
    @State private var notifications = [
        NotificationItem(id: 1, title: "新しいフォロワー", message: "ユーザー1があなたをフォローしました", time: "2分前", isRead: false),
        NotificationItem(id: 2, title: "いいね", message: "あなたの投稿にいいねがつきました", time: "1時間前", isRead: false),
        NotificationItem(id: 3, title: "コメント", message: "あなたの投稿にコメントがつきました", time: "3時間前", isRead: true),
        NotificationItem(id: 4, title: "システム通知", message: "アプリが更新されました", time: "1日前", isRead: true)
    ]
    
    var body: some View {
        NavigationView {
            Group {
                if notifications.isEmpty {
                    VStack {
                        Spacer()
                        
                        Image(systemName: "bell.slash")
                            .font(.largeTitle)
                            .foregroundColor(.green)
                            .padding()
                        
                        Text("通知はありません")
                            .font(.title2)
                            .fontWeight(.semibold)
                        
                        Text("新しい通知が来ると、ここに表示されます")
                            .font(.body)
                            .foregroundColor(.secondary)
                            .padding()
                        
                        Spacer()
                    }
                } else {
                    List {
                        ForEach(notifications) { notification in
                            NotificationRow(notification: notification)
                                .onTapGesture {
                                    markAsRead(notification.id)
                                }
                        }
                        .onDelete(perform: deleteNotification)
                    }
                }
            }
            .navigationTitle("通知")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("すべて既読") {
                        markAllAsRead()
                    }
                    .disabled(notifications.filter { !$0.isRead }.isEmpty)
                }
            }
        }
    }
    
    private func markAsRead(_ id: Int) {
        if let index = notifications.firstIndex(where: { $0.id == id }) {
            notifications[index].isRead = true
        }
    }
    
    private func markAllAsRead() {
        for index in notifications.indices {
            notifications[index].isRead = true
        }
    }
    
    private func deleteNotification(at offsets: IndexSet) {
        notifications.remove(atOffsets: offsets)
    }
}

struct NotificationItem: Identifiable {
    let id: Int
    let title: String
    let message: String
    let time: String
    var isRead: Bool
}

struct NotificationRow: View {
    let notification: NotificationItem
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(notification.title)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Text(notification.message)
                    .font(.body)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
                
                Text(notification.time)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            if !notification.isRead {
                Circle()
                    .fill(Color.green)
                    .frame(width: 8, height: 8)
            }
        }
        .padding(.vertical, 4)
        .background(notification.isRead ? Color.clear : Color(.systemGray6))
        .cornerRadius(8)
    }
}

#Preview {
    NotificationView()
}
