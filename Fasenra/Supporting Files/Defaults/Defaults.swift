//
//  Defaults.swift
//  Fasenra
//
//  Created by Esslam Emad on 23/1/19.
//  Copyright © 2019 Alyom Apps. All rights reserved.
//

import Foundation
import DefaultsKit
import PromiseKit


class Default {
    
    static let def = Default()
    
    var user: User? {
        get {
            return Defaults().get(for: Key<User>("user"))
        }
        set {
            if let value = newValue {
                Defaults().set(value, for: Key<User>("user"))
            } else {
                UserDefaults.standard.set(nil, forKey: "user")
                UserDefaults.standard.synchronize()
            }
        }
    }
    
    
    var fcmToken: String! {
        get{
            return Defaults().get(for: Key<String>("Token"))
        }
        set {
            if let value = newValue {
                Defaults().set(value, for: Key<String>("Token"))
            }
        }
    }
    
    func updateToken(){
        print(1)
        if user != nil {
            if user!.token != fcmToken{
                var user1 = User()
                user1.idForEdit = user!.id
                user1.token = fcmToken
                firstly{
                    return API.CallApi(APIRequests.editUser(user: user1))
                    } .done {
                        self.user = try! JSONDecoder().decode(User.self, from: $0)
                        print("Token updated")
                    }.catch { error in
                        print("Unable to update token")
                }
            }
        }
    }
    
    private init() {
    }
}

