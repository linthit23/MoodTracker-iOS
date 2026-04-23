//
//  MoodViewModel.swift
//  MoodTracker-iOS
//
//  Created by Lin Thit on 4/23/26.
//

import Foundation
import SwiftData

@Observable
class MoodViewModel {
    private var context: ModelContext
    
    var entries: [MoodEntry] = []
    var isLoading: Bool = false
    
    init(context: ModelContext) {
        self.context = context
        fetchEntries()
    }
    
    // MARK: - Fetch
    func fetchEntries() {
        isLoading = true
        let descriptor = FetchDescriptor<MoodEntry>(
            sortBy: [SortDescriptor(\.date, order: .reverse)]
        )
        do {
            entries = try context.fetch(descriptor)
        } catch {
            print("Failed to fetch entries: \(error)")
        }
        isLoading = false
    }
    
    // MARK: - Add
    func addEntry(moodLevel: MoodLevel, note: String, emotions: [String]) {
        let entry = MoodEntry(
            moodLevel: moodLevel,
            note: note,
            emotions: emotions
        )
        context.insert(entry)
        saveContext()
        fetchEntries()
    }
    
    // MARK: - Delete
    func deleteEntry(_ entry: MoodEntry) {
        context.delete(entry)
        saveContext()
        fetchEntries()
    }
    
    // MARK: - Save
    private func saveContext() {
        do {
            try context.save()
        } catch {
            print("Failed to save context: \(error)")
        }
    }
}
