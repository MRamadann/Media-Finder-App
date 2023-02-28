//
//  Profile.swift
//  Media
//
//  Created by Apple on 06/12/2022.
//

import UIKit

class ProfileVC: UIViewController {
    
    //MARK: -OUTLETS
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    
    //MARK: -PROPRETIES
    private var user: User!
    
    //MARK: -Lifecycle METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationView()
        getUserFromSqlManager()
    }
    
    //MARK: -Actions

}

//MARK: -Private Methods
extension ProfileVC {
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
    private func getUserFromSqlManager (){
        let email = UserDefaults.standard.string(forKey: "email")
        if let user = SqlManager.shared.getUser(email: email ?? "") {
            nameLabel.text = user.name
            phoneLabel.text = user.phone
            emailLabel.text = user.email
            addressLabel.text = user.address
            imageView.image = user.image.getImage()
        } else {
            print("Error")
        }
    }
    private func setNavigationView () {
        self.navigationItem.title = "Profile"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "LogOut", style: .plain, target: self, action: #selector(logOut))
    }
    @objc private func logOut() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        appDelegate.switchToSignUp()
    }
}
