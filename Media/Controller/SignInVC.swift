//
//  SignInVC.swift
//  Media
//
//  Created by Apple on 10/12/2022.
//

import UIKit

class SignInVC: UIViewController {
    
    //MARK: -OUTLETS
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    // MARK: -PROPRETIES
    private var user: User!
    
    //MARK: -Lifecycle METHODS
    override func viewDidLoad() {
        setNavigationView()
        super.viewDidLoad()
        UserDefaults.standard.set(false, forKey: "isLoggedIn")
    }
    
    //MARK: -Actions
    @IBAction func signInBtnTapped(_ sender: UIButton) {
        signInBtnIsTapped()
    }
}

//MARK: - Private Methods
extension SignInVC {
    private func goToMedia(){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        appDelegate.switchToMedia()
    }
    private func signInBtnIsTapped(){
        if isEnteredData() {
            if isCorrectData() {
                goToMedia()
            } else {
                showAlert(title: "Sorry", message: "Email or address is wrong")
            }
        } else {
            showAlert(title: "Sorry", message: "All data is required")
        }
    }
    private func isEnteredData() -> Bool {
        guard let enteredEmail = emailTextField.text , enteredEmail != "",
              let enteredPassword = passwordTextField.text, enteredPassword != "" else {return false}
        return true
    }
    private func isCorrectData() -> Bool {
        return SqlManager.shared.isCorrectData(email: emailTextField.text!,
                                               password: passwordTextField.text!)
    }
    private func setNavigationView () {
        self.navigationItem.title = "SignIn"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "<-SignUp", style: .plain, target: self, action: #selector(signUp))
    }
    @objc private func signUp() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        appDelegate.switchToSignUp()
    }
//    private func getUserDataFromUserDefults() -> User? {
//        if let userData = UserDefaults.standard.data(forKey: "User") {
//            do {
//                let userObject = try JSONDecoder().decode(User.self, from: userData)
//                return userObject
//            } catch  {
//                print(error.localizedDescription)
//            }
//        }
//        return nil
//    }
}
