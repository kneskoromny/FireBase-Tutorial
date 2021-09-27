//
//  User.swift
//  ToDoFIRE
//
//  Created by Кирилл Нескоромный on 27.09.2021.
//  Copyright © 2021 Ivan Akulov. All rights reserved.
//

import Foundation
import Firebase

struct LocalUser {
    let uid: String
    let email: String
    
    //необходим для извлечения данных пользователя из Firebase и работы с ними локально
    init(user: User) {
        self.uid = user.uid
        self.email = user.email!
        
    }
}
