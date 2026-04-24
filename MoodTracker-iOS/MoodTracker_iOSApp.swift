//
//  MoodTracker_iOSApp.swift
//  MoodTracker-iOS
//
//  Created by Lin Thit on 4/21/26.
//

import SwiftUI
import SwiftData

@main
struct MoodTracker_iOSApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: MoodEntry.self)
    }
}
