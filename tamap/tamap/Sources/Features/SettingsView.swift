//
//  SettingsView.swift
//  tamap
//
//  Created by AI Assistant on 2025/08/20.
//

import SwiftUI

struct SettingsView: View {
    @State private var notificationsEnabled = true
    @State private var darkModeEnabled = false
    @State private var locationEnabled = true
    @AppStorage("username") private var username = "ユーザー名"
    
    var body: some View {
        NavigationView {
            List {
                // プロフィールセクション
                Section {
                    HStack {
                        Image(systemName: "person.circle.fill")
                            .font(.largeTitle)
                            .foregroundColor(.green)
                        
                        VStack(alignment: .leading) {
                            Text(username)
                                .font(.headline)
                            Text("プロフィールを編集")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                            .foregroundColor(.secondary)
                    }
                    .padding(.vertical, 4)
                }
                
                // 設定セクション
                Section("設定") {
                    HStack {
                        Image(systemName: "bell")
                            .foregroundColor(.green)
                            .frame(width: 24, height: 24)
                        
                        Toggle("通知", isOn: $notificationsEnabled)
                    }
                    
                    HStack {
                        Image(systemName: "moon")
                            .foregroundColor(.green)
                            .frame(width: 24, height: 24)
                        
                        Toggle("ダークモード", isOn: $darkModeEnabled)
                    }
                    
                    HStack {
                        Image(systemName: "location")
                            .foregroundColor(.green)
                            .frame(width: 24, height: 24)
                        
                        Toggle("位置情報", isOn: $locationEnabled)
                    }
                }
                
                // アプリ情報セクション
                Section("アプリ情報") {
                    HStack {
                        Image(systemName: "info.circle")
                            .foregroundColor(.green)
                            .frame(width: 24, height: 24)
                        
                        Text("バージョン")
                        
                        Spacer()
                        
                        Text("1.0.0")
                            .foregroundColor(.secondary)
                    }
                    
                    HStack {
                        Image(systemName: "questionmark.circle")
                            .foregroundColor(.green)
                            .frame(width: 24, height: 24)
                        
                        Text("ヘルプ")
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                            .foregroundColor(.secondary)
                    }
                    
                    HStack {
                        Image(systemName: "doc.text")
                            .foregroundColor(.green)
                            .frame(width: 24, height: 24)
                        
                        Text("利用規約")
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                            .foregroundColor(.secondary)
                    }
                    
                    HStack {
                        Image(systemName: "lock.shield")
                            .foregroundColor(.green)
                            .frame(width: 24, height: 24)
                        
                        Text("プライバシーポリシー")
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                            .foregroundColor(.secondary)
                    }
                }
                
                // アカウントセクション
                Section {
                    Button(action: {
                        // ログアウト処理
                    }) {
                        HStack {
                            Image(systemName: "rectangle.portrait.and.arrow.right")
                                .foregroundColor(.red)
                                .frame(width: 24, height: 24)
                            
                            Text("ログアウト")
                                .foregroundColor(.red)
                        }
                    }
                }
            }
            .navigationTitle("設定")
        }
    }
}

#Preview {
    SettingsView()
}
