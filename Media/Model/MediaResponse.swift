//
//  MediaResponse.swift
//  Media
//
//  Created by Apple on 20/01/2023.
//

import Foundation

enum MediaType: String, Codable {
    case movie = "movie"
    case tvShow = "tvShow"
    case music = "music"
    case all = "all"
}

struct mediaData: Codable {
    var type : MediaType!
    var data : [Media]!
}

struct MediaResponse: Codable {
    var resultCount: Int
    var results: [Media]!
}

struct Media: Codable {
    var artistName: String?
    var trackName: String?
    var previewUrl: String?
    var longDescription: String?
    var artworkUrl: String?

    enum CodingKeys: String, CodingKey {
        case artistName,trackName,previewUrl,longDescription
        case artworkUrl = "artworkUrl100"
    }
}
