//
//  Does.swift
//  Fasenra
//
//  Created by Esslam Emad on 23/1/19.
//  Copyright © 2019 Alyom Apps. All rights reserved.
//

import Foundation

struct Does: Codable {
    var id: Int!
    var patientID: Int!
    var date: String!
    var time: String!
    var status: Int!
    
    enum CodingKeys: String, CodingKey {
        case id
        case patientID = "patient"
        case date
        case time
        case status
    }
}
