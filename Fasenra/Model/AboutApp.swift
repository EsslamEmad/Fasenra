//
//  AboutApp.swift
//  Fasenra
//
//  Created by Esslam Emad on 28/1/19.
//  Copyright © 2019 Alyom Apps. All rights reserved.
//

import Foundation

struct AboutApp: Codable{
    var video: String!
    var title: String!
    var details: String!
    
    enum CodingKeys: String, CodingKey{
        case video
        case title
        case details
    }
}
