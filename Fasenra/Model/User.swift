//
//  User.swift
//  Fasenra
//
//  Created by Esslam Emad on 23/1/19.
//  Copyright © 2019 Alyom Apps. All rights reserved.
//

import Foundation

struct User: Codable {
    var id: Int!
    var type: Int!
    var doctorID: Int?
    var nursingCompanyID: Int?
    var doesDays: Int?
    var doesBeganDay: String?
    var doesbegantime: String?
    var name: String!
    var email: String!
    var phone: String!
    var token: String!
    var insurance: String?
    var patientStatus: Int?
    var patients = [User]()
    var photo: String?
    var doctorNote: Note?
    var companyNote: Note?
    var photoURL: String?
    var currentDose: Does?
    var address: String!
    var addedType: Int!
    var additionalComments: String!
    var score: Int?
    var idForEdit: Int!
    var password: String!
    
    enum CodingKeys: String, CodingKey {
        case id
        case type
        case doctorID = "doctor"
        case nursingCompanyID =  "nursing_company"
        case doesDays = "does_days"
        case doesBeganDay = "does_began_date"
        case name
        case email
        case phone
        case token
        case insurance
        case patientStatus = "patient_status"
        case doesbegantime = "does_began_time"
        case photo
        case doctorNote = "lastDoctorNote"
        case companyNote = "lastNursingNote"
        case currentDose
        case photoURL = "photoUrl"
        case address
        case addedType = "added_type"
        case additionalComments = "additional_comments"
        case score
        case idForEdit = "user_id"
        case password
    }
    
}


struct NoteUser: Codable {
    var id: Int!
    var type: Int!
    var doctorID: Int?
    var nursingCompanyID: Int?
    var doesDays: Int?
    var doesBeganDay: String?
    var doesbegantime: String?
    var name: String!
    var email: String!
    var phone: String!
    var token: String!
    var insurance: String?
    var patientStatus: Int?
    var patients = [User]()
    var photo: String?
    var photoURL: String?
    var currentDose: Does?
    var address: String!
    
    enum CodingKeys: String, CodingKey {
        case id
        case type
        case doctorID = "doctor"
        case nursingCompanyID =  "nursing_company"
        case doesDays = "does_days"
        case doesBeganDay = "does_began_date"
        case name
        case email
        case phone
        case token
        case insurance
        case patientStatus = "patient_status"
        case doesbegantime = "does_began_time"
        case photo
        case currentDose
        case photoURL = "photoUrl"
        case address
    }
    
}
