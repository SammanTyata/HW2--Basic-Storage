//
//  HomePage.swift
//  HW2--Basic-Storage
//
//  Created by Samman Tyata on 10/18/24.
//

import SwiftUI

struct HomePage: View {
    var body: some View {
        TabView {
            
            // Tab 1: Media View
            MediaView()
                .tabItem {
                    Label("Media", systemImage: "photo")
                }
            
            // Tab 2: Settings View
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
        }
    }
}

#Preview {
    HomePage()
}
