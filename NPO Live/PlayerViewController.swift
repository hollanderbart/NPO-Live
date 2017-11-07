import UIKit
import AVKit
import NPOStream

class PlayerViewController: AVPlayerViewController {
    
    var channel: Channel!

    lazy var metadataItem: AVMutableMetadataItem = {
        let logoMetadataItem = AVMutableMetadataItem()
        logoMetadataItem.locale = Locale.current
        logoMetadataItem.key = AVMetadataKey.commonKeyArtwork as NSCopying & NSObjectProtocol
        logoMetadataItem.keySpace = AVMetadataKeySpace.common
        return logoMetadataItem
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let url = channel.url else { return }
        let playerItem = AVPlayerItem(url: url)

        if
            let image = UIImage(named: channel.title),
            let imagePNGData = UIImagePNGRepresentation(image) {
                metadataItem.value = imagePNGData as NSCopying & NSObjectProtocol
                playerItem.externalMetadata.append(metadataItem)
                metadataItem.value = channel.title as NSCopying & NSObjectProtocol
                playerItem.externalMetadata.append(metadataItem)
        }

        player = AVPlayer(playerItem: playerItem)
        player?.play()
    }
}
