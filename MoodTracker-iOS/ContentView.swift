//
//  ContentView.swift
//  MoodTracker-iOS
//
//  Created by Lin Thit on 4/21/26.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        HomeView(viewModel: MoodViewModel(context: modelContext))
    }
}

#Preview {
    ContentView()
        .modelContainer(for: MoodEntry.self, inMemory: true)
}
