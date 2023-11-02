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
        return detailVC
        
    }
    
    func updateUIViewController(_ uiViewController: DetailViewController, context: Context) {
        uiViewController.videoName.text = detailViewModel.title
        uiViewController.videoDescription.text = detailViewModel.desc
    }
}

#Preview {
    DetailView(detailViewModel: DetailViewModel(title: "Title", desc: "Description"))
}

class DetailViewModel : ObservableObject {
    @Published var title : String = ""
    @Published var desc : String = ""
    
    init(title: String, desc: String) {
        self.title = title
        self.desc = desc
    }
}
