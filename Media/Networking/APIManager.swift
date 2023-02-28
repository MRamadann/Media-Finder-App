//
//  APIManager.swift
//  Media
//
//  Created by Apple on 20/01/2023.
//

import Alamofire

class APIManager{
    
    class func getDataFromAPI(term: String, media: String, compelation :@escaping (_ error:Error?, _ mediarray: [Media]?) -> Void ) {
        
        //Sending request to get data
        let params = ["term":term, "media":media]
        AF.request("https://itunes.apple.com/search?",
                   method: HTTPMethod.get,
                   parameters: params,
                   encoding: URLEncoding.default,
                   headers: nil).response { response in
            
            guard response.error == nil else {
                print(response.error!)
                compelation(response.error,nil)
                return
            }
            guard let data = response.data else {
                print("Cant get data from API")
                return
            }
            do {
                // Server Reply
                let decoder = JSONDecoder()
                let mediaArray = try decoder.decode(MediaResponse.self, from: data).results
                compelation(nil,mediaArray)
            } catch let error {
                compelation(error, nil)
            }
        }
    }
}

