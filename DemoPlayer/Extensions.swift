//
//  Extensions.swift
//  DemoPlayer
//
//  Created by Tomas Pollak on 05/11/2023.
//

import Foundation
import UIKit
import AVKit

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

extension Notification.Name {
    static let fileStatus = Notification.Name("FileStatus")
    
}
