//
//  DebugLog.swift
//  NPO Live
//
//  Created by Bart den Hollander on 01/04/2018.
//  Copyright © 2018 Bart den Hollander. All rights reserved.
//

internal func DebugLog(_ log: String) {
    #if DEBUG
    print(log)
    #endif
}
