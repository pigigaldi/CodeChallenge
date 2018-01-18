//
//  Experience.swift
//  CodeChallenge
//
//  Created by Pierluigi Galdi on 18/01/18.
//  Copyright © 2018 Pierluigi Galdi. All rights reserved.
//

import Foundation

struct ExperienceArray: Codable {
    let experiences: [Experience]
}

struct Experience: Codable {
    let id: Int
    let title: String
    let price_usd_cents: Double
    let review_rating: Int
    let image: String
    let city: City
}
