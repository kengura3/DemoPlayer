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

extension Notification.Name {
    static let fileStatus = Notification.Name("FileStatus")
    
}
