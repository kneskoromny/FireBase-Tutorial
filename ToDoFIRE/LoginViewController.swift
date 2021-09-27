//
//  ViewController.swift
//  ToDoFIRE
//
//  Created by Ivan Akulov on 28/02/2017.
//  Copyright © 2017 Ivan Akulov. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {

    @IBOutlet weak var warnLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var ref: DatabaseReference!
    let segueID = "tasksSegue"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // путь к базе
        ref = Database.database().reference(withPath: "users")
        warnLabel.alpha = 0
        // уведомления о показе и скрытии клавиатуры
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(kbDidShow),
            name: UIResponder.keyboardDidShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(kbDidHide),
            name: UIResponder.keyboardDidHideNotification,
            object: nil
        )
        // пропускает аутентификацию, если уже регался
        Auth.auth().addStateDidChangeListener { [weak self] auth, user in
            if user != nil {
                self?.performSegue(withIdentifier: (self?.segueID)!, sender: nil)
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        emailTextField.text = ""
        passwordTextField.text = ""
    }
    
    @objc func kbDidShow(notification: Notification) {
        // получаем словарь с данными
        guard let userInfo = notification.userInfo else { return }
        // из словаря получаем размер клавиатуры
        let kbFrameSize = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        // прибавляем к собственному размеру скроллвью размер клавиатуры
        (self.view as! UIScrollView).contentSize = CGSize(width: self.view.bounds.size.width, height: self.view.bounds.size.height + kbFrameSize.height)
        // устанавливаем ограничитель индикатора скролления
        (self.view as! UIScrollView).scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: kbFrameSize.height, right: 0)
    }
    @objc func kbDidHide(notification: Notification) {
        // восстанавливаем размер вью
        (self.view as! UIScrollView).contentSize = CGSize(width: self.view.bounds.size.width, height: self.view.bounds.size.height)
    }
    
    private func displayWarning(text: String) {
        warnLabel.text = text
        // меняем непрозрачность лейбла с анимацией
        UIView.animate(withDuration: 3, delay: 0, options: [.curveEaseInOut]) { [weak self] in
            self?.warnLabel.alpha = 1
        } completion: { [weak self] complete in
            self?.warnLabel.alpha = 0
        }

    }
    // работа с Firebase
    @IBAction func loginTapped(_ sender: UIButton) {
        guard let email = emailTextField.text, let password = passwordTextField.text, email != "", password != "" else {
            displayWarning(text: "Info is incorrect")
            return
        }
        // авторизация с Firebase
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] user, error in
            if error != nil {
                self?.displayWarning(text: "Error occured")
                return
            }
            // если все ок, то проходим дальше
            if user != nil {
                self?.performSegue(withIdentifier: (self?.segueID)!, sender: nil)
                return
            }
            self?.displayWarning(text: "No such user")
        }
    }
    // регистрация нового пользователя (для простоты в той же форме)
    @IBAction func registerTapped(_ sender: UIButton) {
        guard let email = emailTextField.text, let password = passwordTextField.text, email != "", password != "" else {
            displayWarning(text: "Info is incorrect")
            return
        }
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] user, error in
            // получаем user с типом данных AuthDataResult?
            guard error == nil, user != nil else {
                print("ERROR: \(error?.localizedDescription)")
                return
            }
            // получаем тип User
            guard let user = user?.user else {
                print("ERROR: \(error?.localizedDescription)")
                return
            }
            // создаем ссылку на пользователя в базе
            let userRef = self?.ref.child(user.uid)
            // устанавливаем значение email
            userRef?.setValue(["email": user.email])
        }
    }

}

