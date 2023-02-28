//
//  AppDelegate.swift
//  Media
//
//  Created by Apple on 06/12/2022.
//


import IQKeyboardManagerSwift
import SQLite

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
//MARK: - Propreties.
    var window: UIWindow?
    //Connection
  
    
//MARK: - Application Methods.
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        handleRoot()
        IQKeyboardManager.shared.enable = true
        return true
    }
    
//MARK: - Public Methods
    func switchToMedia(){
        let MediaListVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MediaListVC")
        let navController = UINavigationController(rootViewController: MediaListVC)
         window?.rootViewController = navController
    }
    func switchToSignUp(){
       let SignUpVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SignUpVC")
       let navController = UINavigationController(rootViewController: SignUpVC)
        window?.rootViewController = navController
   }
   func switchToSignIn(){
       let SignInVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SignInVC")
       let navController = UINavigationController(rootViewController: SignInVC)
        window?.rootViewController = navController
   }
}
//MARK: - Private Methods
extension AppDelegate {
    private func handleRoot() {
        if UserDefaults.standard.string(forKey: "email") != nil {
            let isLoggedin = UserDefaults.standard.bool(forKey: "isLoggedIn")
            if isLoggedin {
                switchToMedia()
            } else {
                switchToSignUp()            }
        }
    }
}


