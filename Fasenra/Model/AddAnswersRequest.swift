//
//  AddAnswersRequest.swift
//  Fasenra
//
//  Created by Esslam Emad on 30/1/19.
//  Copyright © 2019 Alyom Apps. All rights reserved.
//

import Foundation

struct AnswersRequest: Codable{
    var patient: Int!
    var answers = [SampleAnswerRequest]()
    
    enum CodingKeys: String, CodingKey{
        case patient
        case answers
    }
    
    
}

struct SampleAnswerRequest: Codable{
    var answerID: Int!
    var questionID: Int!
    
    enum CodingKeys: String, CodingKey{
        case answerID = "answer_id"
        case questionID = "quest_id"
    }
}
