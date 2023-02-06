// RootViewModel.swift

import SwiftUI

class RootViewModel: ObservableObject {
    
    @Published var prompt = ""
    @Published var messages = [Message]()
    
    var api = ChatGPT()
    
    var code = false
    
    func sendMessage() async {
        let savedPrompt = prompt
        await MainActor.run {
            messages.insert(.init(text: .init(prompt), isOutgoing: true), at: 0)
            prompt.removeAll()
        }
        
        do {
            let stream = try await api.sendMessageStream(text: savedPrompt)
            await MainActor.run {
                messages.insert(.init(text: ""), at: 0)
            }
            for try await text in stream {
                await MainActor.run {
                    messages[0].text += text
                }
            }
        } catch {
            await MainActor.run {
                messages.insert(.init(text: .init("\(error)")), at: 0)
            }
        }
    }
    
    func clearMessages() {
        messages.removeAll()
        api.clearHistoryList()
    }
}
