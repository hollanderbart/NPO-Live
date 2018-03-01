//
//  NPOStream.swift
//  NPOStreamFramework
//
//  Created by Bart den Hollander on 28-01-16.
//  Copyright © 2016 Bart den Hollander. All rights reserved.
//

import Foundation
import UIKit

open class NPOStream {
    
    open static func getStream(_ channelTitle: ChannelStreamTitle, onCompletion: @escaping (Result<URL>) -> Void) {
    
    let API_URL = URL(string: "http://ida.omroep.nl/app.php/")
    let TOKEN_URL = URL(string: "http://ida.omroep.nl/app.php/auth")
    
    DispatchQueue.global().async {

    guard
        let API_URL = API_URL,
        let TOKEN_URL = TOKEN_URL else { return onCompletion(.error(NPOStreamError.initialiseURLFailed)) }
    let FirstURLtask = URLSession.shared.dataTask(with: TOKEN_URL) { (data, response, error) in

        guard
            let data = data,
            let response = String(data: data, encoding: String.Encoding.utf8),
            let token:String = response.sliceFrom("token\":\"", to: "\""),
            let secondURL = URL(string: API_URL.absoluteString + channelTitle.rawValue + "?adaptive=yes&token=" + token) else {
                return onCompletion(.error(NPOStreamError.initialiseURLFailed))
            }
        
            let SecondURLtask = URLSession.shared.dataTask(with: secondURL) { (data, response, error) in
            guard
                let rawStreamURLData = data,
                let rawStreamURLString = String.init(data: rawStreamURLData, encoding: String.Encoding.utf8),
                let url:String = rawStreamURLString.sliceFrom("url\":\"", to: "\",\""),
                let finalURL = URL(string: url.decodeJSONUri) else {
                    return onCompletion(.error(NPOStreamError.initialiseURLFailed))
                }
                    
                let ThirdURLtask = URLSession.shared.dataTask(with: finalURL) { (data, response, error) in
                    guard
                        let finalStreamURL = data,
                        let response = String(data: finalStreamURL, encoding: String.Encoding.utf8),
                        let url = response.sliceFrom("setSource(\"", to: "\""),
                        let resultURL = URL(string: url.decodeJSONUri) else {
                            return onCompletion(.error(NPOStreamError.initialiseURLFailed))
                        }
                        
                    DispatchQueue.main.async {
                        onCompletion(.success(resultURL))
                    }
                }
                ThirdURLtask.resume()
            }
            SecondURLtask.resume()
    }
    FirstURLtask.resume()
    }
    }
}
