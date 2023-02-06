// AlwaysChatGPTApp.swift

import SwiftUI

@main
struct AlwaysChatGPTApp: App {
    var body: some Scene {
        MenuBarExtra("AlwaysChatGPT", image: "MenuBarIcon") {
            RootView()
        }.menuBarExtraStyle(.window)
    }
}
