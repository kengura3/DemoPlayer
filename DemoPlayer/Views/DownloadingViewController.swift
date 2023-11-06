//
//  DownloadingViewController.swift
//  DemoPlayer
//
//  Created by Tomas Pollak on 06/11/2023.
//

import UIKit

class DownloadingViewController: UIViewController {

    @IBOutlet weak var progressBar: UIProgressView!
    @IBAction func cancelButtonAction(_ sender: UIButton) {
        FileOperationManager.shared.stopDownloading()
        dismiss(animated: true)
    }
    
    var progress : Float = 0
    var delegate : DetailViewControllerProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        progressBar.progress = progress
        NotificationCenter.default.addObserver(self, selector: #selector(self.statusFileNotificationReceived(notification:)), name: Notification.Name.fileStatus, object: nil)
    }

    
    @objc func statusFileNotificationReceived(notification: Notification) {
        
        if let progress = notification.userInfo?["progress"] as? Float {
            DispatchQueue.main.async {
                self.progressBar.progress = Float(progress)
                print(progress)
                self.progressBar.setNeedsDisplay()
            }
        }
        
        
        if let status = notification.userInfo?["status"] as? FileOperationStatus {
            DispatchQueue.main.async {
                if status == .saved {
                    self.delegate?.updateNavigationBarButton(status: status)
                    self.dismiss(animated: true)
                }
            }
        }
        
        
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
