//
//  TVCollectionViewController.swift
//  NPO Live
//
//  Created by Bart den Hollander on 12-11-17.
//  Copyright © 2017 Bart den Hollander. All rights reserved.
//

import UIKit
import AVKit
import NPOStream

final class TVCollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var topCollectionView: UICollectionView!
    @IBOutlet weak var bottomCollectionView: UICollectionView!

    let topCollectionStreams = Array(ChannelProvider.streams[0...2])
    let bottomCollectionStreams = Array(ChannelProvider.streams[3...])

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = bottomCollectionView.frame
        blurEffectView.alpha = 0.5
        view.addSubview(blurEffectView)
        view.bringSubview(toFront: bottomCollectionView)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchStreams(for: topCollectionStreams)
        fetchStreams(for: bottomCollectionStreams)
    }

    // MARK: - UICollectionViewDataSource

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionView == topCollectionView ? topCollectionStreams.count : bottomCollectionStreams.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == topCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BigChannelCell.identifier, for: indexPath) as? BigChannelCell else {
                fatalError("Expected BigChannelCell at index \(indexPath)")
            }
            cell.channel = topCollectionStreams[indexPath.row]
            if cell.channel.playLiveTiles {
                cell.playLiveTileWhenReady()
            }
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SmallChannelCell.identifier, for: indexPath) as? SmallChannelCell else {
                fatalError("Expected SmallChannelCell at index \(indexPath)")
            }
            cell.channel = bottomCollectionStreams[indexPath.row]
            if cell.channel.playLiveTiles {
                cell.playLiveTileWhenReady()
            }
            return cell
        }
    }

    // MARK: - UICollectionViewDelegate

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let channel = collectionView == topCollectionView ? topCollectionStreams[indexPath.row] :
            bottomCollectionStreams[indexPath.row]
        self.performSegue(withIdentifier: "streamChannel", sender: channel)
    }

    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        super.didUpdateFocus(in: context, with: coordinator)

        coordinator.addCoordinatedFocusingAnimations({ [weak self] (_) in
            guard let strongSelf = self else { return }
            switch context.nextFocusedView {
            case let cell as BigChannelCell:
                guard
                    let indexPath = strongSelf.topCollectionView.indexPath(for: cell),
                    case let channel = strongSelf.topCollectionStreams[indexPath.row],
                    !channel.playLiveTiles else { return }
                channel.playLiveTiles = true
                cell.channel = channel
                cell.playLiveTileWhenReady()
                DebugLog("next bigchannel: \(indexPath.row)")
            case let cell as SmallChannelCell:
                guard
                    let indexPath = strongSelf.bottomCollectionView.indexPath(for: cell),
                    case let channel = strongSelf.bottomCollectionStreams[indexPath.row],
                    !channel.playLiveTiles else { return }
                channel.playLiveTiles = true
                cell.channel = channel
                cell.playLiveTileWhenReady()
                DebugLog("next smallChannel: \(indexPath.row)")
            default:
                break
            }
        })

        coordinator.addCoordinatedUnfocusingAnimations({ [weak self] (_) in
            guard let strongSelf = self else { return }
            switch context.previouslyFocusedItem {
            case let cell as BigChannelCell:
                guard
                    let indexPath = strongSelf.topCollectionView.indexPath(for: cell),
                    case let channel = strongSelf.topCollectionStreams[indexPath.row],
                    channel.playLiveTiles else { return }
                channel.playLiveTiles = false
                cell.stopLiveTile()
                DebugLog("previous bigchannel: \(indexPath.row)")
            case let cell as SmallChannelCell:
                guard
                    let indexPath = strongSelf.bottomCollectionView.indexPath(for: cell),
                    case let channel = strongSelf.bottomCollectionStreams[indexPath.row],                channel.playLiveTiles else { return }
                channel.playLiveTiles = false
                cell.stopLiveTile()
                DebugLog("previous smallChannel: \(indexPath.row)")
            default:
                break
            }
        })
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard
            segue.identifier == "streamChannel",
            let destinationVC = segue.destination as? PlayerViewController,
            let channel = sender as? Channel,
            channel.url != nil else { return }
        destinationVC.channel = channel
    }

    // MARK: - Private

    private func fetchStreams(for channels: [Channel]) {
        channels.forEach { (channel) in
            if channel.url == nil {
                NPOStream.getStream(channel.streamTitle) { [weak self] (result) in
                    guard let strongSelf = self else { return }
                    switch result {
                    case .error(let error):
                        DebugLog(error.localizedDescription)
                    case .success(let streamUrl):
                        channel.url = streamUrl
                        if strongSelf.topCollectionStreams.contains(where: { $0.title == channel.title }) {
                            strongSelf.topCollectionView.reloadData()
                        } else if strongSelf.bottomCollectionStreams.contains(where: { $0.title == channel.title }) {
                            strongSelf.bottomCollectionView.reloadData()
                        }
                    }
                }
            }
        }
    }
}
