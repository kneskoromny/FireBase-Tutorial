//
//  ViewController.swift
//  ToDoFIRE
//
//  Created by Ivan Akulov on 28/02/2017.
//  Copyright © 2017 Ivan Akulov. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var warnLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
    @IBAction func loginTapped(_ sender: UIButton) {
        
    }
    
    @IBAction func registerTapped(_ sender: UIButton) {
        
    }

}

