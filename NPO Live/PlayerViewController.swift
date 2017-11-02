import UIKit
import AVKit
import NPOStream

class PlayerViewController: AVPlayerViewController {
    
    var channel: Channel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let url = channel.url else { return }
        let playerItem = AVPlayerItem(url: url)
        
        let titleMetadataItem: AVMetadataItem = {
            let _titleMetadataItem = AVMutableMetadataItem()
            _titleMetadataItem.locale = Locale.current
            _titleMetadataItem.key = AVMetadataKey.commonKeyTitle as NSCopying & NSObjectProtocol
            _titleMetadataItem.keySpace = AVMetadataKeySpace.common
            _titleMetadataItem.value = channel.title as NSCopying & NSObjectProtocol
//            _titleMetadataItem.value = (channel.activeShow != nil) ? channel.activeShow : channel.title
            
            return _titleMetadataItem
        }()
        
        playerItem.externalMetadata.append(titleMetadataItem)
        
        if let image = UIImage(named: channel.title) {
            let logo: AVMetadataItem = {
                let _logo = AVMutableMetadataItem()
                _logo.locale = Locale.current
                _logo.key = AVMetadataKey.commonKeyArtwork as NSCopying & NSObjectProtocol
                _logo.keySpace = AVMetadataKeySpace.common
                _logo.value = UIImagePNGRepresentation(image) as? NSCopying & NSObjectProtocol
                
                return _logo
            }()
            
            playerItem.externalMetadata.append(logo)
        }
        
        player = AVPlayer(playerItem: playerItem)
        player?.play()
    }
}
