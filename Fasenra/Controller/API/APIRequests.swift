//
//  APIRequests.swift
//  Fasenra
//
//  Created by Esslam Emad on 23/1/19.
//  Copyright © 2019 Alyom Apps. All rights reserved.
//

import Foundation
import Moya

enum APIRequests {
    
    
    case login(email: String, password: String)
    case editUser(user: User)
    case register(user: User)
    case forgotPassword(email: String)
    case getUser(id: Int)
    case getUsersOf(nursingCompanyID: Int?, doctorID: Int?)
    case contactUs(name: String, email: String, message: String, phone: String, subject: String)
    case aboutApp
    case addNote(note: Note)
    case getNotes(userID: Int)
    case getDoes(userID: Int)
    case editDoes(does: Does)
    case addAppointment(appointment: Appointment)
    case getAppoinments(doctorID: Int)
    case getAppointments(patientID: Int)
    case deleteAppointment(id: Int)
    case addAnswer(answers: AnswersRequest)
    case getAnswers(patientID: Int)
    case getACTQAnswers(patientID: Int, actqID: Int)
    case getQuestions(patientID: Int)
    case editAppointment(id: Int, status: Int)
    case upload(image: UIImage?, file: URL?)
    case getInfo
    case requestAppointment
    case getNotifications
    
    
}


extension APIRequests: TargetType{
    var baseURL: URL{
        
        return URL(string: "https://fasenrafast.com/en/mobile")!
        
        
    }
    var path: String{
        switch self{
        case .register:
            return "addUser"
        case .login:
            return "login"
        case .editUser:
            return "editUser"
        case .forgotPassword:
            return "forgetPassword"
        case .getUsersOf:
            return "getUsers"
        case .aboutApp:
            return "aboutApp/\(Default.def.user!.type == 2 ? 1 : (Default.def.user!.type == 1 ? 2 : 3))"
        case .contactUs:
            return "contactUs"
        case .addNote:
            return "addNotes"
        case .getNotes(userID: let id):
            return "getPatientNotes/\(id)"
        case .getDoes(userID: let id):
            return "gePatientDoes/\(id)"
        case .editDoes:
            return "editDoes"
        case .addAppointment:
            return "addAppointment"
        case .getAppoinments:
            return "getAppointment"
        case .getAppointments:
            return "getAppointment"
        case .deleteAppointment(id: let id):
            return "deleteAppointment/\(id)"
        case .addAnswer:
            return "addAnswer"
        case .getAnswers(patientID: let id):
            return "getPatientAnswers/\(id)"
        case.getACTQAnswers(patientID: let pid, actqID: let id):
            return "getPatientAnswers/\(pid)/\(id)"
        case .getQuestions(patientID: let id):
            return "getQuestions/\(id)"
        case .editAppointment(id: let id, status: _):
            return "editAppointment/\(id)"
        case .upload:
            return "upload"
        case .getUser(id: let id):
            return "getUser/\(id)"
        case .getInfo:
            return "getSettings"
        case .requestAppointment:
            return "sendRequest/\(Default.def.user!.id ?? 0)"
        case .getNotifications:
            return "notifications/\(Default.def.user!.id ?? 0)"
        }
    }
    
    
    var method: Moya.Method{
        switch self{
        case .contactUs, .forgotPassword, .editUser, .login, .register, .getUsersOf, .addNote, .editDoes, .addAppointment, .addAnswer, .upload, .editAppointment:
            return .post
            
        default:
            return .get
        }
    }
    
    
    
    var task: Task{
        switch self{
            
        case .register(user: let user1):
            return .requestJSONEncodable(user1)
        case .login(email: let email, password: let password):
            return .requestParameters(parameters: ["email": email, "password": password], encoding: JSONEncoding.default)
        case.editUser(user: let user):
            return .requestJSONEncodable(user)
        //return .requestJSONEncodable(dict)
        case .forgotPassword(email: let email):
            return .requestParameters(parameters: ["email": email], encoding: JSONEncoding.default)
        case .contactUs(name: let name, email: let email , message: let message, phone: let phone, subject: let subject):
            return .requestParameters(parameters: ["name": name, "email": email, "message": message, "phone": phone, "subject": subject], encoding: JSONEncoding.default)
        case .getUsersOf(nursingCompanyID: let id1, doctorID: let id2):
            if let id = id1{
                return  .requestParameters(parameters: ["nursing_company": id], encoding: JSONEncoding.default)
            } else if let id = id2 {
                return .requestParameters(parameters: ["doctor": id], encoding: JSONEncoding.default)
            }
            return .requestPlain
        case .addNote(note: let note):
            return .requestParameters(parameters: ["user_id": note.user.id, "patient": note.patientID, "note": note.note], encoding: JSONEncoding.default)
        case .editDoes(does: let does):
            return .requestJSONEncodable(does)
        case .addAppointment(appointment: let app):
            //return .requestJSONEncodable(app)
            return .requestParameters(parameters: ["doctor": app.doctor.id, "patient": app.patient.id, "date": app.date, "time": app.time], encoding: JSONEncoding.default)
        case .addAnswer(answers: let answers):
            return .requestJSONEncodable(answers)
        case .editAppointment(id: _, status: let status):
            return .requestParameters(parameters: ["status": status], encoding: JSONEncoding.default)
        case .getAppoinments(doctorID: let id):
            return .requestCompositeData(bodyData: Data(), urlParameters: ["doctor": id])
        case .getAppointments(patientID: let id):
            return .requestCompositeData(bodyData: Data(), urlParameters: ["patient": id])
        case .upload(image: let image,file: let url):
            if let image = image{
                let data = image.jpegData(compressionQuality: 0.75)!
                let imageData = MultipartFormData(provider: .data(data), name: "image", fileName: "image.jpeg", mimeType: "image/jpeg")
                let multipartData = [imageData]
                return .uploadMultipart(multipartData)
            }
            else if let data = NSData(contentsOfFile: url!.path){
                let fileData = MultipartFormData(provider: .data(data as Data), name: "image", fileName: "record.m4a", mimeType: "audio/m4a")
                let multipartData = [fileData]
                return .uploadMultipart(multipartData)
            }
            return .requestPlain
        default:
            return .requestPlain
            
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var headers: [String: String]? {
        return ["Content-type": "application/json",
                "client": "0497cbe921f4bdb6ed1045f7ad7e5cf745513c1c",
                "secret": "c3396c59f51b445346c79005d62832ea7ea0f1c3"]
    }
}

