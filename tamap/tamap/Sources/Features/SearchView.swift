//
//  SearchView.swift
//  tamap
//
//  Created by AI Assistant on 2025/08/20.
//

import SwiftUI

struct SearchView: View {
    @State private var searchText = ""
    
    var body: some View {
        NavigationView {
            VStack {
                SearchBar(text: $searchText)
                    .padding(.horizontal)
                
                if searchText.isEmpty {
                    VStack {
                        Spacer()
                        
                        Image(systemName: "magnifyingglass")
                            .font(.largeTitle)
                            .foregroundColor(.green)
                            .padding()
                        
                        Text("さがす")
                            .font(.title2)
                            .fontWeight(.semibold)
                        
                        Text("何かを検索してみましょう")
                            .font(.body)
                            .foregroundColor(.secondary)
                            .padding()
                        
                        Spacer()
                    }
                } else {
                    List {
                        ForEach(filteredResults, id: \.self) { result in
                            Text(result)
                                .padding(.vertical, 4)
                        }
                    }
                }
            }
            .navigationTitle("さがす")
        }
    }
    
    private var filteredResults: [String] {
        let sampleData = ["サンプル1", "サンプル2", "テスト", "検索結果"]
        return sampleData.filter { $0.contains(searchText) }
    }
}

struct SearchBar: View {
    @Binding var text: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.secondary)
            
            TextField("検索...", text: $text)
                .textFieldStyle(RoundedBorderTextFieldStyle())
        }
    }
}

#Preview {
    SearchView()
}
