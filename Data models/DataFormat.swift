//
//  Popular.swift
//  collection view sample
//
//  Created by sabari-pt4418 on 16/10/21.
//

import Foundation

struct DataFormat: Codable{
    let page: Int?
    let total_pages: Int?
    let results: [Movie]?
}

struct Movie: Codable {
    let poster_path: String?
    let adult: Bool?
    let backdrop_path: String?
    let genre_id: [Int]?
    let id: Int?
    let original_language: String?
    let original_title: String
    let overview: String?
    let popularity: Double?
    let release_date: String?
    let title: String?
    let video: Bool?
    let vote_average: Double?
    let vote_count: Int?
}



struct Genre: Codable{
    let id: Int?
    let name: String?
}








