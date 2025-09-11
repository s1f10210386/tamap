//
//  tamapApp.swift
//  tamap
//
//  Created by 金澤帆高 on 2025/08/19.
//

import SwiftUI

@main
struct tamapApp: App {
    @StateObject private var appState = AppState()
    var body: some Scene {
        WindowGroup {
            TabBarView()
                .environmentObject(appState)
        }
    }
}
