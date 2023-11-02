//
//  WebService.swift
//  DemoPlayer
//
//  Created by Tomas Pollak on 02/11/2023.
//

import Foundation

struct Lesson: Decodable  {
    let lessons : [Video]
}

class WebService {
    func getVideos() async throws -> [Video] {
        let (data, _) = try await URLSession.shared.data(from: URL(string: "https://fksoftware.sk/video/data.json")!)
        return try JSONDecoder().decode(Lesson.self, from: data).lessons
    }
}

struct Video : Decodable {
        let id: Int
        let name: String
        let description: String
        let thumbnail : String
        let video_url : String
}
