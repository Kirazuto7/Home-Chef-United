//
//  String+Sentences.swift
//  Home Chef United
//
//  Created by Jordan Sukhnandan on 4/23/23.
//

import Foundation
import UIKit

extension String {
    
    // Breaks a passed in string of text into sentences
    func convertToSentences() -> [String] {
        var steps = [String]()
        self.enumerateSubstrings(in: self.startIndex..<self.endIndex, options: .bySentences) { substring, substringRange, enclosingRange, stop in
            steps.append(substring!)
        }
        return steps
    }
    
    func removeWhiteSpacesInWord() -> String {
        let text = self.filter { !$0.isWhitespace }
        var words = [String]()
        text.enumerateSubstrings(in: self.startIndex..<self.endIndex, options: .byWords) { substring, substringRange, enclosingRange, stop in
            words.append(substring!)
        }
        var newText = ""
        for word in words {
            newText += word + " "
        }
        newText.popLast()
        return newText
    }

}
