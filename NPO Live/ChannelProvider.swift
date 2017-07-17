import Foundation
import NPOStream

class ChannelProviderUtil {
	
    class func getActiveShowNamePerChannel(_ onCompletion: @escaping (_ showChanged: Bool) -> Void) {
		let url = URL(string: "https://www.tvgids24.nl/nustraks")!
		let task = URLSession.shared.dataTask(with: url, completionHandler: { data, _, error in
			if error == nil {
				guard let
					data = data,
					let content = String(data: data, encoding: String.Encoding.utf8) else { return }
				
				let matches = matchesForRegexInText("<a class=\"prog\".+>(.+)<\\/a><\\/li>", text: content)
				for (i, match) in matches.enumerated() {
					if i < 3 /* cookies! */ {
                        let subMatches = matchesForRegexInText("<a class=\"prog\".+>(.+)<\\/a><\\/li>", text: match)
						if let showName = match.sliceFrom(">", to: "<")?.htmlDecoded() {
							let channel = ChannelProvider.streams[i]
							if channel.activeShow != showName {
								channel.activeShow = showName
                                DispatchQueue.main.async {
                                    onCompletion(true)
                                }
							}
						}
					} else {
                        break
                    }
				}
			}
		}) 
		
		task.resume()
	}
	
	fileprivate class func matchesForRegexInText(_ regex: String!, text: String!) -> [String] {
		do {
			let regex = try NSRegularExpression(pattern: regex, options: [])
			let nsString = text as NSString
			let results = regex.matches(in: text, options: [], range: NSMakeRange(0, nsString.length))
			return results.map { nsString.substring(with: $0.range)}
		} catch {
			return []
		}
	}
	
}
