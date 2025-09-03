//
//  HomeView.swift
//  tamap
//
//  Created by AI Assistant on 2025/08/20.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        NavigationView {
            VStack {
                // アプリアイコンとタイトル
                VStack(spacing: 6) {
                    Image(systemName: "leaf.fill")
                        .font(.system(size: 48))
                        .foregroundColor(.green)
                    Text("Tamap")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                }
                .padding(.top, 6)

                NavigationLink(destination: MapView()) {
                    HStack(spacing: 10) {
                        Image(systemName: "map.fill")
                            .foregroundColor(.white)
                        Text("地図からスポットを探す")
                            .foregroundColor(.white)
                            .fontWeight(.semibold)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green)
                    .cornerRadius(10)
                    .padding(.horizontal)
                }
                .padding(.top, 8)
                .padding(.bottom, 20)

                // おすすめ記事見出し
                VStack(alignment: .leading, spacing: 4) {
                    Text("おすすめ記事")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)

                // インラインで WebView を埋め込む（ベタ表示）
                WebView(url: URL(string: "https://tama-app-2025.vercel.app/")!)
                    .frame(height: 500)
                    .cornerRadius(12)
                    .shadow(color: Color.black.opacity(0.06), radius: 6, x: 0, y: 4)
                    .padding(.horizontal)

                // NavigationLink を isActive で制御して、AppState.showMap が true のとき自動的に MapView へ遷移する
                NavigationLink(destination: MapView().environmentObject(appState), isActive: Binding(get: { appState.showMap }, set: { appState.showMap = $0 })) {
                    EmptyView()
                }
            }
        }
        .background(Color.clear)
    }
}

#Preview {
    HomeView()
}
