//
//  URLImage.swift
//  DemoPlayer
//
//  Created by Tomas Pollak on 02/11/2023.
//

import SwiftUI

struct URLImage: View {
    
    let url: URL?
    @StateObject private var thumbnailImageLoader = ThumbnailImageLoader()
    
    var body: some View {
        
        VStack {
            if let uiImage = thumbnailImageLoader.uiImage {
                Image(uiImage: uiImage)
                    .resizable()
            } else {
                ProgressView("Loading")
            }
        } .task {
            await downloadImage()
        }
    }
    
    private func downloadImage() async {
        do {
            try await thumbnailImageLoader.fetchImage(url)
        } catch {
            print(error)
        }
    }
    
}

#Preview {
    URLImage(url: URL(string: "https://fksoftware.sk/video/video.png"))
        .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/,height: 100)
}
