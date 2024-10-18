//
//  SettingsView.swift
//  HW2--Basic-Storage
//
//  Created by Samman Tyata on 10/18/24.
//

import SwiftUI

struct UserSettings: Codable {
    var darkModeEnabled: Bool
    var username: String
    var notificationsEnabled: Bool
    var language: String
}

struct SettingsView: View {
    @State private var darkModeEnabled: Bool = false
    @State private var username: String = ""
    @State private var notificationsEnabled: Bool = false
    @State private var language: String = "English"
    
    @State private var selectedUsername: String = ""
    @State private var savedUsernames: [String] = []
    
    // State variable for alert
    @State private var showingAlert: Bool = false
    @State private var alertMessage: String = ""

    var body: some View {
        VStack {
            Text("User Settings")
                .font(.headline)
                .padding()
            
            // Dropdown Picker for existing usernames
            Picker("Select User", selection: $selectedUsername) {
                Text("Select a user").tag("")
                ForEach(savedUsernames, id: \.self) { user in
                    Text(user).tag(user)
                }
            }
            .pickerStyle(WheelPickerStyle())
            .onChange(of: selectedUsername) { newValue in
                loadSettings(for: newValue)
            }
            .padding()

            // TextField populated with the selected username
            TextField("Enter your username", text: $username)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            Toggle("Dark Mode", isOn: $darkModeEnabled)
                .padding()
        

            Toggle("Notifications", isOn: $notificationsEnabled)
                .padding()

            Picker("Language", selection: $language) {
                Text("English").tag("English")
                Text("Spanish").tag("Spanish")
                Text("Nepali").tag("Nepali")
            }
            .pickerStyle(MenuPickerStyle())
            .padding()

            HStack {
                Button("Save Settings") {
                    saveUserSettings(username: username,
                                     darkModeEnabled: darkModeEnabled,
                                     notificationsEnabled: notificationsEnabled,
                                     language: language)
                    updateSavedUsernames()
                    
                    // Show alert after saving
                    alertMessage = "Settings saved for user: \(username)"
                    showingAlert = true
                }
                .padding()

                Button("Load Settings") {
                    loadSettings(for: username)
                }
                .padding()

                Button("Delete User") {
                    deleteUser(username: selectedUsername)
                }
                .padding()
                .disabled(selectedUsername.isEmpty) // Disable if no user is selected
            }
        }
        .padding()
        .onAppear {
            updateSavedUsernames()
        }
        .alert(isPresented: $showingAlert) {
            Alert(title: Text("Settings Saved"),
                  message: Text(alertMessage),
                  dismissButton: .default(Text("OK")))
        }
    }
    
    func saveUserSettings(username: String, darkModeEnabled: Bool, notificationsEnabled: Bool, language: String) {
        let settings = UserSettings(darkModeEnabled: darkModeEnabled,
                                    username: username,
                                    notificationsEnabled: notificationsEnabled,
                                    language: language)
        
        // Retrieve existing users
        var usersSettings = loadAllUserSettings()
        usersSettings[username] = settings
        
        // Save updated user settings
        saveAllUserSettings(usersSettings)
    }

    func loadSettings(for username: String) {
        if let settings = loadUserSettings(username: username) {
            darkModeEnabled = settings.darkModeEnabled
            notificationsEnabled = settings.notificationsEnabled
            language = settings.language
            self.username = username // Populate the username in the text field
        } else {
            // Reset to defaults if user not found
            darkModeEnabled = false
            notificationsEnabled = false
            language = "English"
            self.username = "" // Clear the text field if no user found
        }
    }

    func loadUserSettings(username: String) -> UserSettings? {
        let usersSettings = loadAllUserSettings()
        return usersSettings[username]
    }

    func loadAllUserSettings() -> [String: UserSettings] {
        if let data = UserDefaults.standard.data(forKey: "userSettings") {
            let decoder = JSONDecoder()
            do {
                return try decoder.decode([String: UserSettings].self, from: data)
            } catch {
                print("Error decoding user settings: \(error)")
            }
        }
        return [:]
    }

    func saveAllUserSettings(_ usersSettings: [String: UserSettings]) {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(usersSettings)
            UserDefaults.standard.set(data, forKey: "userSettings")
        } catch {
            print("Error encoding user settings: \(error)")
        }
    }

    // Update the saved usernames for the dropdown
    func updateSavedUsernames() {
        savedUsernames = loadAllUserSettings().keys.map { $0 }
        if let firstUsername = savedUsernames.first {
            selectedUsername = firstUsername // Set the first user as selected by default
        } else {
            selectedUsername = "" // Clear if no users are available
        }
    }

    func deleteUser(username: String) {
        // Load current user settings
        var usersSettings = loadAllUserSettings()
        
        // Remove the selected user
        usersSettings.removeValue(forKey: username)
        
        // Save the updated settings
        saveAllUserSettings(usersSettings)
        
        // Update saved usernames and clear the text field
        updateSavedUsernames()
        self.username = ""
        alertMessage = "User \(username) has been deleted."
        showingAlert = true
    }
}

#Preview {
    SettingsView()
}
