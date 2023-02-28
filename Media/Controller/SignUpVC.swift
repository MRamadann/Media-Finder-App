//
//  SignUpVC.swift
//  Media
//
//  Created by Apple on 06/12/2022.
//

import UIKit
import SDWebImage
import SQLite

class SignUpVC: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var userImageView: UIImageView!
    
    //MARK: - Properties
     let imagePicker = UIImagePickerController()
     let format = "SELF MATCHES %@"
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "SignUp"
        userImageView.image = UIImage(named: "user")
    }

    //MARK: - Actions
    @IBAction func addressBtnTapped(_ sender: UIButton) {
        goToMapVC()
    }
    @IBAction func signUpBtnTapped(_ sender: UIButton) {
        sighUpBtnTapped()
    }
    @IBAction func selectImgBtnTapped(_ sender: Any) {
        selectImageBtnTapped()
        self.title = " "
    }
    @IBAction func signInBtnTapped(_ sender: UIButton) {
        signIn()
    }
}
//MARK: - ImagePicked
extension SignUpVC: UIImagePickerControllerDelegate , UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let imagePicked = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            userImageView.image = imagePicked
        }
        dismiss(animated: true,completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true,completion: nil)
    }
}

//MARK: - AddressDelegation
extension SignUpVC: AddressDelegation {
    func sendAddress(location: String) {
        addressTextField.text = location
    }
}

//MARK: - Private Methods
extension SignUpVC{
    private func goToSignInVC(){
        let signIn = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SignInVC") as! SignInVC
        self.navigationController?.pushViewController(signIn, animated: true)
    }
    private func setUserDataToUserDefults(user: User){
        do{
            let userData = try JSONEncoder().encode(user) // convert object to data
            UserDefaults.standard.set(userData, forKey: "User")
        }
        catch{
            print(error.localizedDescription)
        }
    }
    private func goToMapVC(){
        let mapVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MapVC") as! MapVC
        self.navigationController?.pushViewController(mapVC, animated: true)
        mapVC.delegate = self
    }
    private func saveUserToSqlManager() -> Bool{
        let user = User(name: nameTextField.text!, email: emailTextField.text!, password: passwordTextField.text!, phone: phoneTextField.text!, address: addressTextField.text!,image: CodableImage(image: userImageView.image!))
       return SqlManager.shared.saveUser(user: user)
        
    }
//    private func saveDataToUserDefults() {
//        let user = User(name: nameTextField.text!, email: emailTextField.text!, password: passwordTextField.text!, phone: phoneTextField.text!, address: addressTextField.text!,image: CodableImage(image: userImageView.image!))
//        setUserDataToUserDefults(user: user)
//    }
    private func selectImageBtnTapped() {
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true)
    }
    private func sighUpBtnTapped() {
        if isDataEntered() {
            if isValidRegex() {
                if saveUserToSqlManager() {
                    goToSignInVC()
                } else {
                    showAlert(title: "Error", message: "Try Again")
                }
            }
        }
    }
    private func signIn(){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        appDelegate.switchToSignIn()
    }
    //MARK: - Regex
    private func isValidEmail(email: String) -> Bool {
        let regix = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format: format, regix)
        return emailPred.evaluate(with: email)
    }
    private func isValidPassword(Password: String) -> Bool {
        let regix = "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{8,}$"
        let PasswordPred = NSPredicate(format: format, regix)
        return PasswordPred.evaluate(with: Password)
    }
    private func isValidPhone(Phone: String) -> Bool {
        let regix = "[0-9]{11}$"
        let PhonePred = NSPredicate(format: format, regix)
        return PhonePred.evaluate(with: Phone)
    }
    private func isValidRegex() -> Bool{
        guard isValidEmail(email: emailTextField.text!) else {
            self.showAlert(title: "Sorry", message: "Please Enter Valid Email \n EX: email@gmail.com")
            return false
        }
        guard isValidPhone(Phone: phoneTextField.text!) else {
            self.showAlert(title: "Sorry", message: "Please Enter Valid Phone \n EX: 01002233556")
            return false
        }
        guard isValidPassword(Password: passwordTextField.text!) else {
            self.showAlert(title: "Sorry", message: "Please Enter Valid Password \n EX: Aa123456")
            return false
        }
        return true
    }
    private func isDataEntered() -> Bool {
        guard emailTextField.text != "" else { self.showAlert(title: "Sorry", message: "Please Enter Valid Email \n EX: email@gmail.com")
            return false
        }
        guard nameTextField.text != "" else { self.showAlert(title: "Sorry", message: "Please Enter Name")
            return false
        }
        guard phoneTextField.text != "" else { self.showAlert(title: "Sorry", message: "Please Enter Valid Phone \n EX: 01002233556")
            return false
        }
        guard passwordTextField.text != "" else { self.showAlert(title: "Sorry", message: "Please Enter Valid Password \n EX: Aa123456")
            return false
        }
        guard addressTextField.text != "" else { self.showAlert(title: "Sorry", message: "Please Enter Valid Address")
            return false
        }
        guard userImageView.image != UIImage(named: "user") else {
            showAlert(title: "Sorry", message: "Please Enter Valid photo")
            return false
        }
        return true
    }
}

