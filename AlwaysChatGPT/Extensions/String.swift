// String.swift

import SwiftUI

func stringRange(
    for string: String,
    start: Int,
    length: Int
) -> Range<String.Index> {
    let startIndex = string.utf16.index(string.startIndex, offsetBy: start)
    let endIndex = string.utf16.index(startIndex, offsetBy: length)
    return startIndex..<endIndex
}

func attributedStringRange(
    for attrString: AttributedString,
    from stringRange: Range<String.Index>
) -> Range<AttributedString.Index> {
    let lowerBound = AttributedString.Index(stringRange.lowerBound, within: attrString)!
    let upperBound = AttributedString.Index(stringRange.upperBound, within: attrString)!
    return lowerBound..<upperBound
}

extension String: CustomNSError {
    public var errorUserInfo: [String: Any] {
        [NSLocalizedDescriptionKey: self]
    }
    
    func withRenderedCode() -> AttributedString {
        var savedSelf = self
        var attributedString = AttributedString(savedSelf)
        
        var codes = 0
        for char in savedSelf where char == "`" {
            codes += 1
        }
        
        for _ in 0...(codes / 2) {
            if let firstRange = savedSelf.firstRange(of: "```"),
               let secondRange = savedSelf.replacing("```", with: "", maxReplacements: 1).firstRange(of: "```") {
                let range = attributedStringRange(for: attributedString, from: firstRange.upperBound..<secondRange.lowerBound)
                attributedString[range].font = .title3.monospaced()
                
//                print("here \(savedSelf[firstRange.upperBound..<secondRange.lowerBound])")
//                let url = URL(string: "alwayschatgpt:copy?code=print hello world")
//                print("not url", url)
//                attributedString[range].link = url
//                attributedString[range].cursor = .pointingHand
                
                attributedString[range].foregroundColor = .black
                let savedAttributedString = attributedString
                attributedString.removeSubrange(attributedStringRange(for: savedAttributedString, from: firstRange))
                attributedString.removeSubrange(attributedStringRange(for: savedAttributedString, from: secondRange))
                savedSelf.removeSubrange(firstRange)
                savedSelf.removeSubrange(secondRange)
            }
            if let startIndex = savedSelf.firstIndex(of: "`"),
               let endIndex = savedSelf.replacing("`", with: "", maxReplacements: 1).firstIndex(of: "`") {
                let range = attributedStringRange(for: attributedString, from: startIndex..<endIndex)
                attributedString[range].font = .title3.monospaced()
                let savedAttributedString = attributedString
                let firstRange = startIndex..<savedSelf.index(after: startIndex)
                let secondRange = endIndex..<savedSelf.index(after: endIndex)
                attributedString.removeSubrange(attributedStringRange(for: savedAttributedString, from: firstRange))
                attributedString.removeSubrange(attributedStringRange(for: savedAttributedString, from: secondRange))
                savedSelf.removeSubrange(firstRange)
                savedSelf.removeSubrange(secondRange)
            }
        }
        
        return attributedString
    }
}
