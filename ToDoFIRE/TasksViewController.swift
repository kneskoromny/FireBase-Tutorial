//
//  TasksViewController.swift
//  ToDoFIRE
//
//  Created by Ivan Akulov on 28/02/2017.
//  Copyright © 2017 Ivan Akulov. All rights reserved.
//

import UIKit
import Firebase

class TasksViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    // для прикрепления задачи к текущему пользователю
    var user: LocalUser!
    // ссылка на базу
    var ref: DatabaseReference!
    var tasks: [Task] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // получаем данные текщего пользователя, тип данных User Firebase
        guard let currentUser = Auth.auth().currentUser else { return }
        // присваиваем значение currentUser переменной для работы локально, тип данных LocalUser
        user = LocalUser(user: currentUser)
        // создаем ссылку и указываем путь до tasks конкретного пользователя
        // .child - проваливаемся внутрь папки в базе
        ref = Database.database().reference(withPath: "users").child(user.uid).child("tasks")
    }
    
    @IBAction func addTapped(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "New Task", message: "Add new task", preferredStyle: .alert)
        alert.addTextField()
        let save = UIAlertAction(title: "Save", style: .default) { [weak self] _ in
            guard let textField = alert.textFields?.first, textField.text != "" else { return }
            // создаем задачу
            let task = Task(title: textField.text!, userId: (self?.user.uid)!)
            // создаем путь к задаче в базе
            let taskRef = self?.ref.child(task.title.lowercased())
            // записываем задачу с атрибутами в базу
            taskRef?.setValue(["title": task.title, "userID": task.userId, "completed": task.completed ] )
            
        }
        let cancel = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        alert.addAction(save)
        alert.addAction(cancel)
        
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func signOut(_ sender: UIBarButtonItem) {
        do {
           try Auth.auth().signOut()
        } catch let error {
            print(error.localizedDescription)
        }
        dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        cell.backgroundColor = .clear
        cell.textLabel?.text = "This is cell number \(indexPath.row)"
        cell.textLabel?.textColor = .white
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
}
