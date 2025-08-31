//
//  HomeView.swift
//  tamap
//
//  Created by AI Assistant on 2025/08/20.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                
                Image(systemName: "house.fill")
                    .font(.largeTitle)
                    .foregroundColor(.green)
                    .padding()
                
                Text("ホーム")
                    .font(.title2)
                    .fontWeight(.semibold)
                
                Text("ここがホーム画面です")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .padding()

                // 追加ボタン
                NavigationLink(destination: MapView()) {
                    Text("地図からスポットを探す")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .cornerRadius(10)
                        .padding(.horizontal)
                }
                .padding(.top)
                
                Spacer()
            }
            .navigationTitle("ホーム")
        }
    }
}

#Preview {
    HomeView()
}
