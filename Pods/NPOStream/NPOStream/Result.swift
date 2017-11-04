//
//  Result.swift
//  NPOStream
//
//  Created by Bart den Hollander on 26/09/2017.
//  Copyright © 2017 Bart den Hollander. All rights reserved.
//

import Foundation

public enum Result<Element> {
    case success(Element)
    case error(Error)
    
    // Allow optional transforms (chaining).
    public func map<TransformedElement>(_ transform: (Element) throws -> TransformedElement) rethrows -> Result<TransformedElement> {
        switch self {
        case .success(let val):
            return Result<TransformedElement>.success(try transform(val))
        case .error(let error):
            return Result<TransformedElement>.error(error)
        }
    }
    
}
