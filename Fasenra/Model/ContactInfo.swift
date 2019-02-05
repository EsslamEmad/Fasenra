//
//  ContactInfo.swift
//  Fasenra
//
//  Created by Esslam Emad on 29/1/19.
//  Copyright © 2019 Alyom Apps. All rights reserved.
//

import Foundation

struct ContactInfo: Codable{
    var phone: String!
    var email: String!
    
    enum CodingKeys: String, CodingKey{
        case phone
        case email
    }
}
