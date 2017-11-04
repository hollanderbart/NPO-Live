//
//  Channel.swift
//  NPOStream
//
//  Created by Bart den Hollander on 23/07/16.
//  Copyright © 2016 Bart den Hollander. All rights reserved.
//

import Foundation

public class Channel {
    public var title: String
    public var streamTitle: ChannelStreamTitle
    public var url: URL?
    
    public init(title: String, streamTitle: ChannelStreamTitle, url: URL?) {
        self.title = title
        self.streamTitle = streamTitle
        self.url = url
    }
}
