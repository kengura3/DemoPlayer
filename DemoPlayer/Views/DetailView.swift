//
//  DetailView.swift
//  DemoPlayer
//
//  Created by Tomas Pollak on 02/11/2023.
//

import SwiftUI
import AVKit

protocol DetailViewProtocol {
    func nextVideo()
}

struct DetailView: UIViewControllerRepresentable, DetailViewProtocol {
        
    @State var selectedItem : Int
    @State var nextVideoAvalaible : Bool
    @ObservedObject var videoListVM :  VideoListViewModel
    
    func nextVideo() {
        guard selectedItem < videoListVM.videos.count - 1 else {
            return
        }
        if selectedItem == videoListVM.videos.count - 2  {
            nextVideoAvalaible = false
        }
        selectedItem = selectedItem + 1
    }
    

    typealias UIViewControllerType = DetailViewController
    
    
    func makeUIViewController(context: Context) -> DetailViewController {
        let detailVC = UIViewControllerType(nibName: "DetailViewController", bundle: nil)
        
        detailVC.videoURL = videoListVM.videos[selectedItem].video_url!
        detailVC.nextVideoAvalaible = nextVideoAvalaible
        detailVC.delegate = self
        return detailVC
        
    }
    
    func updateUIViewController(_ uiViewController: DetailViewController, context: Context) {
        uiViewController.videoURL = videoListVM.videos[selectedItem].video_url
        uiViewController.videoName.text = videoListVM.videos[selectedItem].title
        uiViewController.videoDescription.text = videoListVM.videos[selectedItem].description
        uiViewController.nextVideoAvalaible = nextVideoAvalaible
    }
}

//#Preview {
//
//    DetailView(selectedItem: 0, nextVideoAvalaible: true, videoListVM: VideoListViewModel())
//
//}

