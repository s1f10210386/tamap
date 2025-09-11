//
//  PostView.swift
//  tamap
//
//  Created by AI Assistant on 2025/08/20.
//

import SwiftUI

struct PostView: View {
    @State private var postText = ""
    @State private var showingAlert = false
    private let charLimit = 300

    // 簡単なクイックタグ
    private let suggestedTags = ["子連れ", "ランチ", "自然", "屋内", "穴場"]

    // フォーカス状態を管理してプレースホルダ表示を制御
    @FocusState private var isEditorFocused: Bool

    var body: some View {
        NavigationView {
            VStack(spacing: 16) {
                // ヘッダーカード
                HStack(spacing: 12) {
                    ZStack {
                        Circle()
                            .fill(Color.green.opacity(0.15))
                            .frame(width: 64, height: 64)
                        Image(systemName: "camera.fill")
                            .font(.title)
                            .foregroundColor(.green)
                    }

                    VStack(alignment: .leading, spacing: 4) {
                        Text("新しい投稿")
                            .font(.title2)
                            .fontWeight(.semibold)
                        Text("今起こったこと・見つけたスポットをシェアしよう")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }

                    Spacer()
                }
                .padding()
                .background(Color(UIColor.secondarySystemBackground))
                .cornerRadius(14)
                .padding(.horizontal)

                // 入力エリア
                ZStack(alignment: .topLeading) {
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color(UIColor.systemGray4), lineWidth: 1)
                        .background(Color(UIColor.systemBackground).cornerRadius(12))

                    VStack(alignment: .leading, spacing: 8) {
                        // プレースホルダ（フォーカス時は非表示にする）
                        if postText.isEmpty && !isEditorFocused {
                            Text("あなたが体験した多摩の魅力をみんなに共有しましょう！")
                                .foregroundColor(.secondary)
                                .padding(.top, 12)
                                .padding(.horizontal, 8)
                        }

                        TextEditor(text: $postText)
                            .frame(minHeight: 140)
                            .padding(6)
                            .background(Color.clear)
                            .cornerRadius(8)
                            .focused($isEditorFocused)
                    }
                    .padding(8)
                }
                .padding(.horizontal)

                // クイックタグ
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(suggestedTags, id: \ .self) { tag in
                            Button(action: {
                                let trimmed = postText.trimmingCharacters(in: .whitespacesAndNewlines)
                                if trimmed.isEmpty {
                                    postText = "#\(tag) "
                                } else {
                                    postText += " #\(tag)"
                                }
                            }) {
                                Text("#\(tag)")
                                    .font(.caption2)
                                    .padding(.vertical, 6)
                                    .padding(.horizontal, 10)
                                    .background(Color.green.opacity(0.12))
                                    .foregroundColor(.green)
                                    .cornerRadius(12)
                            }
                        }

                        // 絵文字追加ボタン
                        Button(action: {
                            postText += " 😊"
                        }) {
                            Text("😊")
                                .font(.title3)
                                .padding(8)
                                .background(Color.yellow.opacity(0.12))
                                .cornerRadius(10)
                        }
                    }
                    .padding(.horizontal)
                }

                // 投稿ボタンと文字数表示
                HStack(spacing: 12) {
                    Text("\(postText.count)/\(charLimit)")
                        .font(.caption2)
                        .foregroundColor(postText.count > charLimit ? .red : .secondary)

                    Spacer()

                    Button(action: {
                        showingAlert = true
                    }) {
                        HStack {
                            Image(systemName: "paperplane.fill")
                            Text("たまポスト")
                                .fontWeight(.semibold)
                        }
                        .foregroundColor(.white)
                        .padding()
                        .frame(minWidth: 120)
                        .background(postText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || postText.count > charLimit ? Color.gray : Color.green)
                        .cornerRadius(12)
                    }
                    .disabled(postText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || postText.count > charLimit)
                }
                .padding(.horizontal)

                Spacer()
            }
            .navigationTitle("")
            .navigationBarHidden(false)
            .alert("投稿しました!", isPresented: $showingAlert) {
                Button("OK") {
                    postText = ""
                }
            } message: {
                Text("たまポストありがとうございます🎉")
            }
        }
    }
}

#Preview {
    PostView()
}
