// Message.swift

import SwiftUI

struct Message: Identifiable, Equatable {
    let id = UUID()
    var text: String
    var isOutgoing: Bool = false
}
