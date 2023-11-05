//
//  DetailViewModel.swift
//  DemoPlayer
//
//  Created by Tomas Pollak on 03/11/2023.
//

import Foundation

class DetailViewModel : ObservableObject {
    @Published var detailViewData : DetailViewData
    @Published var nextVideo : (() -> Void)?
    
    init(detailViewData: DetailViewData, nextVideo: @escaping () -> Void) {
        self.detailViewData = detailViewData
        self.nextVideo = nextVideo
    }
    
}

struct DetailViewData {
    var title : String
    var desc : String
    var videoURL : URL?
    
}
