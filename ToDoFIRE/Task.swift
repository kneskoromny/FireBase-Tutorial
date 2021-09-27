//
//  Task.swift
//  ToDoFIRE
//
//  Created by Кирилл Нескоромный on 27.09.2021.
//  Copyright © 2021 Ivan Akulov. All rights reserved.
//

import Foundation
import Firebase

struct Task {
    let title: String
    // по нему будем получать задачи для конкретного пользователя
    let userId: String
    // по нему будем получать точный адрес объекта в базе данных
    let ref: DatabaseReference?
    var completed = false
    
    // для записи в базу
    init(title: String, userId: String) {
        self.title = title
        self.userId = userId
        self.ref = nil
    }
    // для восстановления из базы
    init(snapshot: DataSnapshot) {
        // AnyObject тк точно не знаем какой тип данных у value, key всегда String
        let snapshotValue = snapshot.value as! [String: AnyObject]
        title = snapshotValue["title"] as! String
        userId = snapshotValue["userId"] as! String
        completed = snapshotValue["completed"] as! Bool
        // ключа в данном случае не видно
        ref = snapshot.ref
    }
    
    
}
