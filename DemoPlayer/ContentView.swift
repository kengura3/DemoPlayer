//
//  ContentView.swift
//  DemoPlayer
//
//  Created by Tomas Pollak on 02/11/2023.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @StateObject private var videoListVM = VideoListViewModel()

    var body: some View {
        NavigationView {
            List(videoListVM.videos) { video in
                NavigationLink {
                    
                } label: {
                    HStack {
                        URLImage(url: video.thumbnail)
                            .frame(width: 80, height: 45)

                        Text(video.title)
                            .font(.body)
                    }
                }

                
                
            } .task {
                await videoListVM.populateVideos()
            }
            .listStyle(.plain)
            .navigationTitle("Videá")
        }
        .preferredColorScheme(.dark)
    }
}

#Preview {
    ContentView()
        
}
