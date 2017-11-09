//
//  AppDelegate.swift
//  NPO Live
//
//  Created by Maurice van Breukelen on 21-11-15.
//  Copyright © 2015 Maurice van Breukelen. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
	
	var window: UIWindow?
    let versionUtility = VersionUtility()

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        if let currentVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            versionUtility.checkForNewVersion(currentVersion) { result in
                switch result {
                case .newVersion(let newVersion):
                    let alert = UIAlertController(title: "Update available", message: "Version \(newVersion) is available. Your version is \(currentVersion).", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))

                    DispatchQueue.main.async {
                        if let rootViewController = self.window?.rootViewController {
                            rootViewController.present(alert, animated: true, completion: nil)
                        }
                    }
                case .noNewVersion:
                    break
                }

            }
        }
		return true
	}
}
