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
            List(videoListVM.videos.indices, id: \.self) { index in
//                NavigationLink {
//
//                    DetailView(selectedItem: index, nextVideoAvalaible: videoListVM.videos.count == (index + 1) ? false : true, videoListVM: videoListVM)
//
//                } label: {
//                    HStack {
//                        URLImage(url: videoListVM.videos[index].thumbnail)
//                            .frame(width: 80, height: 45)
//
//                        Text(videoListVM.videos[index].title)
//                            .font(.body)
//                            .accessibilityIdentifier("ListRowTitle")
//                            
//                    }
//                }
//                .tint(.blue)
//                .accessibilityIdentifier("ListRow\(index)")
                
                HStack {
                    URLImage(url: videoListVM.videos[index].thumbnail)
                        .frame(width: 80, height: 45)
                        .cornerRadius(4.0)
                    Text(videoListVM.videos[index].title)
                        .font(.body)
                        .accessibilityIdentifier("ListRowTitle")
                    Spacer()
                    Image(systemName: "chevron.right")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 7)
                        .foregroundColor(.blue.opacity(0.35))
                }
                .background(
                    NavigationLink(destination: DetailView(selectedItem: index, nextVideoAvalaible: videoListVM.videos.count == (index + 1) ? false : true, videoListVM: videoListVM)) {}
                        .opacity(0)
                )
                
                
                
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
