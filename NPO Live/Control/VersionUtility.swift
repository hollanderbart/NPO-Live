//
//  AppVersionController.swift
//  NPO Live
//
//  Created by Bart den Hollander on 08/11/2017.
//  Copyright © 2017 Bart den Hollander. All rights reserved.
//

import Foundation
import NPOStream

enum VersionControllerResult {
    case newVersion(String)
    case noNewVersion
}

struct Release: Codable {
    var tag_name: String
    var name: String
}

class VersionUtility {

    static let gitHubLatestReleaseURLString = "https://api.github.com/repos/hollanderbart/NPO-Live/releases/latest"

    func checkForNewVersion(_ currentVersion: String, onCompletion: @escaping (VersionControllerResult) -> Void) {
        guard let gitHubLatestReleaseURL = URL(string: VersionUtility.gitHubLatestReleaseURLString) else { return }

        getVersionTagFromLatestRelease(gitHubLatestReleaseURL) { (result) in
            switch result {
            case .success(let version):
                if version > currentVersion {
                    onCompletion(.newVersion(version))
                } else {
                    onCompletion(.noNewVersion)
                }
            case .error(let error):
                print(error)
            }
        }
    }

    private func getVersionTagFromLatestRelease(_ url: URL, onCompletion: @escaping (Result<String>) -> Void) {
        let decoder = JSONDecoder()
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/vnd.github.v3+json", forHTTPHeaderField: "Accept")

        let task = URLSession.shared.dataTask(with: request as URLRequest) { (data, _, error) in
            if let responseData = data {
                do {
                    let response = try decoder.decode(Release.self, from: responseData)
                    onCompletion(.success(response.tag_name))
                } catch {
                    onCompletion(.error(error))
                }
            } else {
                if let error = error {
                    onCompletion(.error(error))
                }
            }
        }
        task.resume()
    }
}
