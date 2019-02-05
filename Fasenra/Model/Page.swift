//
//  Page.swift
//  Fasenra
//
//  Created by Esslam Emad on 23/1/19.
//  Copyright © 2019 Alyom Apps. All rights reserved.
//

import Foundation

struct Page: Codable{
    var title: String!
    var details: String!
    
    enum CodingKeys: String, CodingKey{
        case title
        case details
    }
}
