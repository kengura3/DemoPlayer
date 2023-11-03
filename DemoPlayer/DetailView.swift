//
//  DetailView.swift
//  DemoPlayer
//
//  Created by Tomas Pollak on 02/11/2023.
//

import SwiftUI

struct DetailView: UIViewControllerRepresentable {
    
    @StateObject var detailViewModel : DetailViewModel
    
    typealias UIViewControllerType = DetailViewController
    
    func makeUIViewController(context: Context) -> DetailViewController {
        let detailVC = UIViewControllerType(nibName: "DetailViewController", bundle: nil)
        detailVC.videoURL = detailViewModel.videoURL

        return detailVC
        
    }
    
    func updateUIViewController(_ uiViewController: DetailViewController, context: Context) {
        uiViewController.videoName.text = detailViewModel.title
        uiViewController.videoDescription.text = detailViewModel.desc
        uiViewController.videoURL = detailViewModel.videoURL
    }
}

#Preview {
    DetailView(detailViewModel: DetailViewModel(title: "Title", desc: "Description", url: URL(string: "https://fksoftware.sk/video/production_id_4887473.mp4")!))
}

class DetailViewModel : ObservableObject {
    @Published var title : String = ""
    @Published var desc : String = ""
    @Published var videoURL : URL
    
    init(title: String, desc: String, url: URL ) {
        self.title = title
        self.desc = desc
        self.videoURL = url
    }
}
