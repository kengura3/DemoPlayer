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
    
    @State var selectedVideo = 0
    
    var body: some View {
        NavigationView {
            List(videoListVM.videos.indices, id: \.self) { index in
                HStack {
                    URLImage(url: videoListVM.videos[index].thumbnail)
                        .frame(width: 80, height: 45)
                        .cornerRadius(4.0)
                    Text(videoListVM.videos[index].title)
                        .font(.body)
                    Spacer()
                    Image(systemName: "chevron.right")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 7)
                        .foregroundColor(.blue.opacity(0.35))
                }
                .background(alignment: .center, content: {
                    
                    NavigationLink(destination: DetailView(selectedItem: index, nextVideoAvalaible: videoListVM.videos.count == (index + 1) ? false : true, videoListVM: videoListVM)) {}
                    .opacity(0)

                })
                
                .accessibilityIdentifier("ListRow\(index)")
                
                
                
            } .task {
                await videoListVM.populateVideos()
            }
            .listStyle(.plain)
            .navigationBarTitleDisplayMode(.automatic)
            .navigationTitle("Videá")
        }
        
        
        .preferredColorScheme(.dark)
        
    }
}

#Preview {
    ContentView()
        
}
