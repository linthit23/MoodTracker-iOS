//
//  SettingsView.swift
//  MoodTracker-iOS
//
//  Created by Lin Thit on 4/26/26.
//

import SwiftUI

struct SettingsView: View {
    var viewModel: MoodViewModel
    
    @State private var reminderHour: Int = 20
    @State private var reminderMinute: Int = 0
    @State private var notificationsEnabled: Bool = false
    @State private var selectedTime = Calendar.current.date(
        bySettingHour: 20,
        minute: 0,
        second: 0,
        of: Date()
    ) ?? Date()
    
    var body: some View {
        NavigationStack {
            List {
                
                // MARK: - Notifications Section
                Section {
                    Toggle(isOn: $notificationsEnabled) {
                        Label("Daily Reminder", systemImage: "bell.fill")
                    }
                    .tint(.indigo)
                    .onChange(of: notificationsEnabled) { _, newValue in
                        Task {
                            if newValue {
                                await viewModel.requestNotifications()
                            } else {
                                viewModel.notificationService.cancelDailyReminder()
                            }
                        }
                    }
                    
                    if notificationsEnabled {
                        DatePicker(
                            "Reminder Time",
                            selection: $selectedTime,
                            displayedComponents: .hourAndMinute
                        )
                        .tint(.indigo)
                        .onChange(of: selectedTime) { _, newValue in
                            let components = Calendar.current.dateComponents(
                                [.hour, .minute],
                                from: newValue
                            )
                            reminderHour = components.hour ?? 20
                            reminderMinute = components.minute ?? 0
                            Task {
                                await viewModel.notificationService.scheduleDailyReminder(
                                    hour: reminderHour,
                                    minute: reminderMinute
                                )
                            }
                        }
                    }
                } header: {
                    Text("Notifications")
                } footer: {
                    Text("Get a daily reminder to log your mood.")
                }
                
                // MARK: - HealthKit Section
                Section {
                    HStack {
                        Label("HealthKit", systemImage: "heart.fill")
                        Spacer()
                        Text(viewModel.sleepHours > 0 ? "Connected" : "Not Available")
                            .foregroundStyle(
                                viewModel.sleepHours > 0 ? .green : .secondary
                            )
                            .font(.subheadline)
                    }
                    
                    if viewModel.sleepHours > 0 {
                        HStack {
                            Label("Sleep Last Night", systemImage: "moon.fill")
                            Spacer()
                            Text(String(format: "%.1f hrs", viewModel.sleepHours))
                                .foregroundStyle(.secondary)
                        }
                    }
                    
                    if viewModel.mindfulMinutes > 0 {
                        HStack {
                            Label("Mindful Minutes", systemImage: "brain.head.profile")
                            Spacer()
                            Text(String(format: "%.0f min", viewModel.mindfulMinutes))
                                .foregroundStyle(.secondary)
                        }
                    }
                } header: {
                    Text("Health Data")
                } footer: {
                    Text("MoodTracker reads sleep and mindfulness data from Apple Health to enrich your mood insights.")
                }
                
                // MARK: - About Section
                Section {
                    HStack {
                        Label("Version", systemImage: "info.circle.fill")
                        Spacer()
                        Text("1.0.0")
                            .foregroundStyle(.secondary)
                    }
                    
                    HStack {
                        Label("Developer", systemImage: "person.fill")
                        Spacer()
                        Text("Lin Thit Khant")
                            .foregroundStyle(.secondary)
                    }
                    
                    HStack {
                        Label("Built With", systemImage: "swift")
                        Spacer()
                        Text("Swift & SwiftUI")
                            .foregroundStyle(.secondary)
                    }
                } header: {
                    Text("About")
                }
            }
            .navigationTitle("Settings")
            .onAppear {
                notificationsEnabled = viewModel.notificationsGranted
            }
        }
    }
}
