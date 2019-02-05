//
//  Appointment.swift
//  Fasenra
//
//  Created by Esslam Emad on 23/1/19.
//  Copyright © 2019 Alyom Apps. All rights reserved.
//

import Foundation

struct Appointment: Codable {
    var id: Int!
    var patient: User!
    var doctor: User!
    var date: String!
    var time: String!
    var status: Int!
    
    enum CodingKeys: String, CodingKey {
        case id
        case patient
        case doctor
        case date
        case time
        case status
    }
}
