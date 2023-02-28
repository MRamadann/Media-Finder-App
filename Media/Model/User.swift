//
//  User.swift
//  Media
//
//  Created by Apple on 13/12/2022.
//

import UIKit

//MARK - Gender
enum Gender:String, Codable{
    case male = "Male"
    case female = "Female"
}

//MARK - User
struct User: Codable {
    var name: String!
    var email: String!
    var password: String!
    var phone: String!
    var address: String!
    var image: CodableImage!
}

//MARK - CodableImage
struct CodableImage: Codable {
    let imageData: Data?
    init(image: UIImage) {
        self.imageData = image.jpegData(compressionQuality: 1.0)
    }
    func getImage() -> UIImage? {
        guard let imageData = self.imageData else {return nil}
        let image = UIImage(data: imageData)
        return image
    }
}
