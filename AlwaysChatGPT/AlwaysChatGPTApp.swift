// AlwaysChatGPTApp.swift

import SwiftUI

@main
struct AlwaysChatGPTApp: App {
    var body: some Scene {
        MenuBarExtra("AlwaysChatGPT", image: "MenuBarIcon") {
            RootView()
//                .onOpenURL { url in
//                    print("url", url)
//                    guard let components = URLComponents(url: url, resolvingAgainstBaseURL: true),
//                          let queryItems = components.queryItems,
//                          let item = queryItems.first, item.name == "code", let value = item.value
//                    else { return }
//
//                    NSPasteboard.general.setString("```\(value)```", forType: .html)
//                }
        }.menuBarExtraStyle(.window)
    }
}
