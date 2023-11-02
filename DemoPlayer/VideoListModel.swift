//
//  VideoListModel.swift
//  DemoPlayer
//
//  Created by Tomas Pollak on 02/11/2023.
//

import Foundation

@MainActor
class VideoListViewModel : ObservableObject {
    
    @Published var videos: [VideoViewModel] = []
    
    func populateVideos() async {
        do {
            let videos = try await WebService().getVideos()
            self.videos = videos.map(VideoViewModel.init)
        } catch {
            print(error)
        }
    }
}

struct VideoViewModel: Identifiable {
    private var video : Video
    
    init(video: Video) {
        self.video = video
    }
    
    var id = UUID()
    
    var title: String {
        video.name
    }
    
    var description: String {
        video.description
    }
    
    var thumbnail: URL? {
        URL(string: video.thumbnail)
    }
    
    var video_url: URL? {
        URL(string: video.video_url)
    }
}
