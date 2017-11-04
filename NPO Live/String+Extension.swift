//
//  String+Extension.swift
//  NPO Live
//
//  Created by Maurice van Breukelen on 21-11-15.
//  Copyright © 2015 Maurice van Breukelen. All rights reserved.
//

import Foundation

extension String {
	
    var decodeJSONUri: String {
		return self.replacingOccurrences(of: "\\/", with: "/")
	}
}
