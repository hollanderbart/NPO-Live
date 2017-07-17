//
//  AppDelegate.swift
//  NPO Live
//
//  Created by Maurice van Breukelen on 21-11-15.
//  Copyright © 2015 Maurice van Breukelen. All rights reserved.
//

import UIKit

let gitHubURL = "https://api.github.com/repos/Mauricevb/NPO-Live-Apple-TV-4/releases"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
	
	var window: UIWindow?
	
	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
		checkForNewVersions()
		return true
	}
	
	func checkForNewVersions() {
//		guard let currentVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String else { return }
//		
//		let URL = Foundation.URL(string: gitHubURL)
//		let request = NSMutableURLRequest(url: URL!)
//		request.httpMethod = "GET"
//		request.addValue("application/vnd.github.v3+json", forHTTPHeaderField: "Accept")
//
//        
//		let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, _, error) in
//			if error == nil {
//				guard let data = data else { return }
//				do {
//					guard let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [AnyObject] else { return }
//					guard let lastVersion = json[0] as? NSDictionary, lastVersion["tag_name"] != nil else { return }
//					let version = lastVersion["tag_name"] as! String
//					
//					if version > currentVersion {
//						let alert = UIAlertController(title: "Update available", message: "Version \(version) is available. Your version is \(currentVersion)", preferredStyle: UIAlertControllerStyle.alert)
//						alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
//						
//						DispatchQueue.main.async {
//							if let vc = self.window?.rootViewController {
//								vc.present(alert, animated: true, completion: nil)
//							}
//						}
//					}
//				} catch {
//					print(error)
//				}
//			}
//		}) 
//		
//		task.resume()
	}
}
