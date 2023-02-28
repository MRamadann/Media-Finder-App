//
//  SqlManager.swift
//  Media
//
//  Created by Apple on 24/02/2023.
//

import Foundation
import SQLite

class SqlManager {
    private var dataBase: Connection!
    private let userTable = Table("users")
    private let mediaTable = Table("media")
    private let email = Expression<String>("email")
    private var userData = Expression<Data>("user")
    private let mediaSearch = Expression<String>("mediaSearch")
    static let shared = SqlManager()
    
    private init() {
        setupConnection()
    }
//MARK: - UserTable
   private func setupConnection() {
        do{
            let documentDirectory = try FileManager.default.url(for: .documentDirectory,
                                                     in: .userDomainMask,
                                                     appropriateFor: nil,
                                                     create: true)
            let fileUrl = documentDirectory.appendingPathComponent("users").appendingPathExtension("sqlite3")
            let dataBase = try Connection(fileUrl.path)
            self.dataBase = dataBase
        } catch {
            print(error.localizedDescription)
        }
    }
    private func creatUserTable() {
        do {
            try self.dataBase.run(userTable.create(ifNotExists: true, block: { table in
                table.column(self.email, primaryKey: true)
                table.column(self.userData)
            }))
        } catch {
            print(error.localizedDescription)
        }
    }
    func saveUser(user: User) -> Bool {
        do {
            creatUserTable()
            let data = try JSONEncoder().encode(user)
            try self.dataBase.run(userTable.insert(self.email <- user.email,
                                                   self.userData <- data))
            return true
        } catch {
            print(error.localizedDescription)
            return false
        }
    }
    func getUser(email: String) -> User? {
        do {
            let users = try self.dataBase.prepare(self.userTable)
            var userData: User?
            for user in users where user[self.email] == email {
                let data = try JSONDecoder().decode(User.self, from: user[self.userData])
                userData = data
            }
            return userData
        } catch {
            print(error.localizedDescription)
        }
        return nil
    }
    func isCorrectData(email: String, password: String) -> Bool {
        if let user = getUser(email: email) {
            if user.email == email && user.password == password {
                UserDefaults.standard.set(email, forKey: "email")
                return true
            } 
        }
        return false
    }
}
