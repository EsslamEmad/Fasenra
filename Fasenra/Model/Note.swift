//
//  Note.swift
//  Fasenra
//
//  Created by Esslam Emad on 23/1/19.
//  Copyright © 2019 Alyom Apps. All rights reserved.
//

import Foundation

class Note: Codable {
    var id: Int!
    var user = NoteUser()
    var patientID: Int!
    var note: String!
    var date: String!
    
    enum CodingKeys: String, CodingKey {
        case id
        case user
        case patientID = "patient"
        case note
        case date
    }
}
