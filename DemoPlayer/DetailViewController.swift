//
//  DetailViewController.swift
//  DemoPlayer
//
//  Created by Tomas Pollak on 02/11/2023.
//

import UIKit
import AVKit
import AVFoundation

class DetailViewController: UIViewController {

    @IBOutlet weak var videoName: UILabel!
    @IBOutlet weak var videoDescription: UITextView!
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var playButton: UIView!
    @IBAction func nextButtonAction(_ sender: UIButton) {
        delegate?.nextVideo()
        
        videoName.setNeedsDisplay()
    }
    
    var videoURL : URL?
    var nextVideoAvalaible = true {
        didSet {
            if nextVideoAvalaible == false {
                if let nextButton = nextButton {
                    nextButton.isHidden = true
                }
            }
        }
    }
    var player: AVPlayer?
    var avpController = AVPlayerViewController()
    
    var delegate : DetailViewProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurePlayButton()
        configureVideoPlayer()
        if nextVideoAvalaible == false {
            if let nextButton = nextButton {
                nextButton.isHidden = true
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        videoDescription.adjustUITextViewHeight()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        player?.pause()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
            super.viewWillTransition(to: size, with: coordinator)
            if UIDevice.current.orientation.isLandscape {
                
                avpController.enterFullScreen(animated: true)
                
                
            } else {
                avpController.exitFullScreen(animated: true)
                avpController.dismiss(animated: true)
            }
        }
    
    
    private func configureVideoPlayer() {
        
       guard let url = videoURL else { return }
       player = AVPlayer(url: url)
        avpController.player = player
        avpController.view.frame.size.height = videoView.frame.size.height
        avpController.view.frame.size.width = videoView.frame.size.width
        avpController.delegate = self
        
        self.videoView.addSubview(avpController.view)
        
        
    }
    
    private func configurePlayButton() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture))
        playButton.addGestureRecognizer(tapGesture)
        playButton.isUserInteractionEnabled = true
    }
    
    @objc private func handleTapGesture() {
        player?.play()
        playButton.isHidden = true
    }

}

extension AVPlayerViewController {
    func enterFullScreen(animated: Bool) {
        perform(NSSelectorFromString("enterFullScreenAnimated:completionHandler:"), with: animated, with: nil)
        
    }
    func exitFullScreen(animated: Bool) {
        perform(NSSelectorFromString("exitFullScreenAnimated:completionHandler:"), with: animated, with: nil)
    }
}

extension UITextView {
    func adjustUITextViewHeight() {
        self.translatesAutoresizingMaskIntoConstraints = true
        self.sizeToFit()
        self.isScrollEnabled = false
    }
}

extension DetailViewController: AVPlayerViewControllerDelegate {

    func playerViewController(_ playerViewController: AVPlayerViewController, willEndFullScreenPresentationWithAnimationCoordinator coordinator: UIViewControllerTransitionCoordinator) {

        // The system pauses when returning from full screen, we need to 'resume' manually.
        coordinator.animate(alongsideTransition: nil) { transitionContext in
            self.avpController.player?.play()
        }
    }
    
    func playerViewController(_ playerViewController: AVPlayerViewController, willBeginFullScreenPresentationWithAnimationCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: nil) { transitionContext in
            self.avpController.player?.play()
        }
    }
    
    
}



