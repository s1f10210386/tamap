//
//  TabBarView.swift
//  tamap
//
//  Created by AI Assistant on 2025/08/20.
//

import SwiftUI

struct TabBarView: View {
    @State private var selectedTab = 0
    @State private var showingPostView = false
    
    var body: some View {
        ZStack {
            // メインコンテンツ
            Group {
                switch selectedTab {
                case 0:
                    HomeView()
                case 1:
                    SearchView()
                case 3:
                    NotificationView()
                case 4:
                    SettingsView()
                default:
                    HomeView()
                }
            }
            
            VStack {
                Spacer()
                CustomTabBar(selectedTab: $selectedTab, showingPostView: $showingPostView)
            }
            .ignoresSafeArea(.all, edges: .bottom)
        }
        .sheet(isPresented: $showingPostView) {
            PostView()
        }
    }
}

struct CustomTabBar: View {
    @Binding var selectedTab: Int
    @Binding var showingPostView: Bool
    
    var body: some View {
        ZStack {
            // タブバーのコンテンツ
            VStack {
                Spacer()
                ZStack {
                    // タブバーの角丸背景
                    RoundedRectangle(cornerRadius: 25)
                        .fill(Color(.systemBackground))
                        .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: -5)
                        .frame(height: 80)
                    
                    HStack {
                        // ホームタブ
                        TabBarItem(
                            icon: "house",
                            title: "ホーム",
                            isSelected: selectedTab == 0
                        ) {
                            selectedTab = 0
                        }
                        
                        // 検索タブ
                        TabBarItem(
                            icon: "magnifyingglass",
                            title: "さがす",
                            isSelected: selectedTab == 1
                        ) {
                            selectedTab = 1
                        }
                        
                        // 中央の投稿ボタン（飛び出し）
                        Button(action: {
                            showingPostView = true
                        }) {
                            ZStack {
                                Circle()
                                    .fill(Color.green)
                                    .frame(width: 60, height: 60)
                                    .shadow(color: Color.green.opacity(0.3), radius: 8, x: 0, y: 4)
                                
                                Image(systemName: "plus")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                            }
                        }
                        .offset(y: -20)
                        
                        // 通知タブ
                        TabBarItem(
                            icon: "bell",
                            title: "通知",
                            isSelected: selectedTab == 3
                        ) {
                            selectedTab = 3
                        }
                        
                        // 設定タブ
                        TabBarItem(
                            icon: "gearshape",
                            title: "設定",
                            isSelected: selectedTab == 4
                        ) {
                            selectedTab = 4
                        }
                    }
                    .padding(.horizontal, 20)
                }
                .padding(.bottom, 10)
            }
        }
    }
}

struct TabBarItem: View {
    let icon: String
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundColor(isSelected ? .green : .gray)
                
                Text(title)
                    .font(.caption2)
                    .foregroundColor(isSelected ? .green : .gray)
            }
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    TabBarView()
}
