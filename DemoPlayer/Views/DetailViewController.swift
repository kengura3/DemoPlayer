//
//  DetailViewController.swift
//  DemoPlayer
//
//  Created by Tomas Pollak on 02/11/2023.
//

import UIKit
import AVKit
import AVFoundation

protocol DetailViewControllerProtocol {
    func updateNavigationBarButton(status: FileOperationStatus)
}

class DetailViewController: UIViewController, DetailViewControllerProtocol {

    @IBOutlet weak var videoName: UILabel!
    @IBOutlet weak var videoDescription: UITextView!
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var playButton: UIView!
    @IBAction func nextButtonAction(_ sender: UIButton) {
        delegate?.nextVideo()
        
        videoName.setNeedsDisplay()
    }
    
    var videoURL : URL? {
        didSet {
            if let url = videoURL {
                let fileName = url.lastPathComponent
                if let localURL = FileOperationManager.shared.getDocumentsDirectory(fileName: fileName) {
                    self.player?.replaceCurrentItem(with: AVPlayerItem(url: localURL))
                } else {
                        self.player?.replaceCurrentItem(with: AVPlayerItem(url: url))
                }
                
                self.inicializeRightNavigationButton()
            }
        }
    }
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
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.statusFileNotificationReceived(notification:)), name: Notification.Name.fileStatus, object: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if (UIDevice.current.userInterfaceIdiom == .phone){
            videoDescription.adjustUITextViewHeight()
        } else {
            nextButton.isHidden = true
        }
        
        inicializeRightNavigationButton()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        player?.pause()
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
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(startPlayingVideo))
        playButton.addGestureRecognizer(tapGesture)
        playButton.isUserInteractionEnabled = true
    }
    
    func inicializeRightNavigationButton() {
        if let directory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first  {
            let fileUrl = directory.appendingPathComponent(videoURL!.lastPathComponent)
            print(fileUrl)
            
            if FileManager.default.fileExists(atPath: fileUrl.path) {
                self.parent?.navigationItem.setRightBarButton(self.customDownloadBarButton(status: .saved), animated: false)
            } else {
                self.parent?.navigationItem.setRightBarButton(self.customDownloadBarButton(status: .notSaved), animated: false)
            }
        }
    }
    
    func customDownloadBarButton(status: FileOperationStatus) -> UIBarButtonItem {
        
        let button = UIButton(type: .system)
        
        switch status {
            
        case .saved:
            button.setImage(UIImage(systemName: "trash"), for: .normal)
            button.setTitle("Delete", for: .normal)
            button.addTarget(self, action: #selector(deleteVideoFile), for: UIControl.Event.touchUpInside)
            button.isHidden = false
        case .downloading:
            button.isHidden = true
        case .notSaved:
            button.setImage(UIImage(systemName: "icloud.and.arrow.down"), for: .normal)
            button.setTitle("Download", for: .normal)
            button.addTarget(self, action: #selector(startDownloadingVideo), for: UIControl.Event.touchUpInside)
            button.isHidden = false
        }

        button.sizeToFit()
            
        return UIBarButtonItem(customView: button)
        
    }
    
    func updateNavigationBarButton(status: FileOperationStatus) {
        self.parent?.navigationItem.setRightBarButton(self.customDownloadBarButton(status: status), animated: false)
    }
    
    
    @objc func deleteVideoFile() {
        if let url = videoURL {
            FileOperationManager.shared.deleteFile(url: url)
        }
    }
    
    @objc private func startPlayingVideo() {
        player?.play()
        playButton.isHidden = true
    }
    
    @objc func startDownloadingVideo() {
        
        let downloadingViewController = DownloadingViewController()
        downloadingViewController.modalPresentationStyle = .overFullScreen
        downloadingViewController.modalTransitionStyle = .crossDissolve
        downloadingViewController.delegate = self
       
        present(downloadingViewController, animated: true)
        
        if let url = videoURL {
            FileOperationManager.shared.download(url: url, fileName: url.lastPathComponent)
            
        }
    }
    
    @objc func statusFileNotificationReceived(notification: Notification) {
        if let fileName = notification.object as? String {
            if let url = videoURL {
                if url.lastPathComponent == fileName {
                    if let status = notification.userInfo?["status"] as? FileOperationStatus {
                        DispatchQueue.main.async {
                            self.updateNavigationBarButton(status: status)
                            if status == .saved {
                                self.player?.replaceCurrentItem(with: AVPlayerItem(url: url))
                            }
                        }
                    }
                }
                
            }
        }
    }
                                                                   
                                                                   

}






