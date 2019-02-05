//
//  UserNotification.swift
//  Fasenra
//
//  Created by Esslam Emad on 31/1/19.
//  Copyright © 2019 Alyom Apps. All rights reserved.
//

import Foundation

struct UserNotification: Codable{
    var message: String!
    var title: String!
    var type: Int!
    var patient: Int!
    var doctor: Int!
    var company: Int!
    var item: Int!
    
    enum CodingKeys: String, CodingKey{
        case message
        case title
        case type
        case patient = "patient_id"
        case doctor = "doctor_id"
        case company = "nurs_id"
        case item = "item_id"
    }
}
