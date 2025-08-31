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
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Image(systemName: "plus.circle.fill")
                    .font(.largeTitle)
                    .foregroundColor(.green)
                    .padding(.top, 40)
                
                Text("新しい投稿")
                    .font(.title2)
                    .fontWeight(.semibold)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("投稿内容")
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    TextEditor(text: $postText)
                        .frame(minHeight: 120)
                        .padding(8)
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color(.systemGray4), lineWidth: 1)
                        )
                }
                .padding(.horizontal)
                
                Button(action: {
                    showingAlert = true
                }) {
                    HStack {
                        Image(systemName: "paperplane.fill")
                        Text("投稿する")
                    }
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.green)
                    .cornerRadius(10)
                }
                .padding(.horizontal)
                .disabled(postText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                
                Spacer()
            }
            .navigationTitle("投稿する")
            .alert("投稿しました", isPresented: $showingAlert) {
                Button("OK") {
                    postText = ""
                }
            } message: {
                Text("投稿が完了しました。")
            }
        }
    }
}

#Preview {
    PostView()
}
