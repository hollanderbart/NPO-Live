# NPOStream
Swift framework to get real-time streams of Dutch broadcasting studio (NPO).

| Available NPO channels    |
| ------------------------- |
| NPO1                      |
| NPO2                      |
| NPO3                      |
| NPONieuws                 |
| NPOPolitiek               |
| NPO101                    |
| NPOCultura                |
| NPOZappXtra               |
| NPORadio1                 |
| NPORadio2                 |
| NPO3FM                    |
| NPORadio4                 |

# Usage
1. Import framework in Xcode project using Cocoapods ```pod "NPOStream"```
2. Declare: ```import NPOStream``` on top of your swift file
3. Call the NPOStream.getStream function with a ChannelTitle enum case. ChannelTitle is a enum with all available NPO TV channels that NPOStream can provide.

```NPOStream.getStream(ChannelTitle, onCompletion: (URL?, NSError?) -> Void)```


# Example
```
NPOStream.getStream(ChannelTitle.NPO3) { (url: URL?, error: NSError?) in
  guard let streamURL = url, error == nil else { return }
  self.performSegue(withIdentifier: "player", sender: streamURL)
}
```

Take a look at the Example project for more details..
