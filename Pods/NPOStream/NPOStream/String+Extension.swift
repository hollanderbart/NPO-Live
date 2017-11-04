//
//  String+Extension.swift
//  NPOStream
//
//  Created by Bart den Hollander on 21-11-15.
//  Copyright © 2016 Bart den Hollander. All rights reserved.
//

import Foundation

extension String {
    
    func sliceFrom(_ start: String, to: String) -> String? {
        return (range(of: start)?.upperBound)
            .flatMap { startIndex in
                (range(of: to, range: startIndex..<endIndex)?.lowerBound)
                    .map { endIndex in
                        String(self[startIndex..<endIndex])
            }
        }
    }

    var decodeJSONUri: String {
        return self.replacingOccurrences(of: "\\/", with: "/")
    }
    
    func htmlDecoded() -> String {
        guard (self != "") else { return self }
        var newStr = self
        let entities = [
            "&quot;"    : "\"",
            "&amp;"     : "&",
            "&apos;"    : "'",
            "&lt;"      : "<",
            "&gt;"      : ">",
        ]
        
        for (name,value) in entities {
            newStr = newStr.replacingOccurrences(of: name, with: value)
        }
        return newStr
    }
}
