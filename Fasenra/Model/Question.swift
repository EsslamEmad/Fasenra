//
//  Question.swift
//  Fasenra
//
//  Created by Esslam Emad on 23/1/19.
//  Copyright © 2019 Alyom Apps. All rights reserved.
//

import Foundation

struct Question: Codable {
    var id: Int!
    var title: String!
    var answers: [Answer]!
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case answers
    }
}
