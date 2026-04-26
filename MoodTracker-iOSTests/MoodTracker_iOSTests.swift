//
//  MoodTracker_iOSTests.swift
//  MoodTracker-iOSTests
//
//  Created by Lin Thit on 4/21/26.
//

import XCTest
import SwiftData
@testable import MoodTracker_iOS

final class MoodViewModelTests: XCTestCase {
    var container: ModelContainer!
    var context: ModelContext!
    var viewModel: MoodViewModel!
    
    // MARK: - Setup
    override func setUpWithError() throws {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        container = try ModelContainer(
            for: MoodEntry.self,
            configurations: config
        )
        context = ModelContext(container)
        viewModel = MoodViewModel(context: context)
    }
    
    // MARK: - Teardown
    override func tearDownWithError() throws {
        viewModel = nil
        context = nil
        container = nil
    }
    
    // MARK: - Tests
    func testAddEntry() throws {
        // Given
        XCTAssertEqual(viewModel.entries.count, 0)
        
        // When
        viewModel.addEntry(
            moodLevel: .good,
            note: "Feeling good today",
            emotions: ["Happy", "Calm"]
        )
        
        // Then
        XCTAssertEqual(viewModel.entries.count, 1)
        XCTAssertEqual(viewModel.entries.first?.moodLevel, .good)
        XCTAssertEqual(viewModel.entries.first?.note, "Feeling good today")
        XCTAssertEqual(viewModel.entries.first?.emotions, ["Happy", "Calm"])
    }
    
    func testDeleteEntry() throws {
        // Given
        viewModel.addEntry(
            moodLevel: .good,
            note: "Test entry",
            emotions: []
        )
        XCTAssertEqual(viewModel.entries.count, 1)
        
        // When
        let entry = viewModel.entries[0]
        viewModel.deleteEntry(entry)
        
        // Then
        XCTAssertEqual(viewModel.entries.count, 0)
    }
    
    func testMultipleEntries() throws {
        // Given / When
        viewModel.addEntry(moodLevel: .veryBad, note: "Rough day", emotions: ["Anxious"])
        viewModel.addEntry(moodLevel: .neutral, note: "Okay day", emotions: ["Calm"])
        viewModel.addEntry(moodLevel: .veryGood, note: "Great day", emotions: ["Happy"])
        
        // Then
        XCTAssertEqual(viewModel.entries.count, 3)
    }
    
    func testEntriesSortedByDateDescending() throws {
        // Given / When
        viewModel.addEntry(moodLevel: .bad, note: "First", emotions: [])
        viewModel.addEntry(moodLevel: .good, note: "Second", emotions: [])
        
        // Then — most recent entry should be first
        XCTAssertEqual(viewModel.entries.first?.note, "Second")
    }
    
    func testMoodLevelRawValues() throws {
        XCTAssertEqual(MoodLevel.veryBad.rawValue, 1)
        XCTAssertEqual(MoodLevel.bad.rawValue, 2)
        XCTAssertEqual(MoodLevel.neutral.rawValue, 3)
        XCTAssertEqual(MoodLevel.good.rawValue, 4)
        XCTAssertEqual(MoodLevel.veryGood.rawValue, 5)
    }
    
    func testMoodLevelEmojis() throws {
        XCTAssertEqual(MoodLevel.veryBad.emoji, "😞")
        XCTAssertEqual(MoodLevel.bad.emoji, "😕")
        XCTAssertEqual(MoodLevel.neutral.emoji, "😐")
        XCTAssertEqual(MoodLevel.good.emoji, "🙂")
        XCTAssertEqual(MoodLevel.veryGood.emoji, "😄")
    }
    
    func testMoodLevelLabels() throws {
        XCTAssertEqual(MoodLevel.veryBad.label, "Very Bad")
        XCTAssertEqual(MoodLevel.bad.label, "Bad")
        XCTAssertEqual(MoodLevel.neutral.label, "Neutral")
        XCTAssertEqual(MoodLevel.good.label, "Good")
        XCTAssertEqual(MoodLevel.veryGood.label, "Very Good")
    }
    
    func testAddEntryWithEmptyNote() throws {
        // Given / When
        viewModel.addEntry(moodLevel: .neutral, note: "", emotions: [])
        
        // Then
        XCTAssertEqual(viewModel.entries.first?.note, "")
    }
    
    func testAddEntryWithMultipleEmotions() throws {
        // Given / When
        let emotions = ["Happy", "Calm", "Grateful", "Excited"]
        viewModel.addEntry(moodLevel: .veryGood, note: "Amazing day", emotions: emotions)
        
        // Then
        XCTAssertEqual(viewModel.entries.first?.emotions.count, 4)
        XCTAssertTrue(viewModel.entries.first?.emotions.contains("Grateful") ?? false)
    }
}
