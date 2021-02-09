//
//  NetworkManager.swift
//  RickAndMortyWiki
//
//  Created by Rodion Chikerenda on 18.12.2020.
//

import UIKit
import Alamofire
import SwiftyJSON
import AlamofireImage

protocol LaunchScreenDelegate {
    func didFinishDownloadingCharacters(array: [Character])
}

protocol MainPageDelegate {
    func didFinishDownloadingCharacters(array: [Character])
}

class NetworkManager {
    
    let charactersUrl = "https://rickandmortyapi.com/api/character/"
    var launchScreenDelegate: LaunchScreenDelegate?
    var mainPageDelegate: MainPageDelegate?
    
    func getCharacters(page: Int, isInitial: Bool = true) {
        var charactersArray = [Character]()
        let finalURL = "\(charactersUrl)?page=\(page)"
        AF.request(finalURL).validate().responseJSON { response in
            guard let value = response.value else {fatalError("Failed loading character data")}
            let jsonObject = JSON(value)
            let jsonArray = jsonObject["results"].arrayValue
            for object in jsonArray {
                let name = object["name"].stringValue
                let id = object["id"].intValue
                let status = object["status"].stringValue
                let gender = object["gender"].stringValue
                let species = object["species"].stringValue
                let imageUrl = object["image"].stringValue
                let origin = object["origin"]["name"].stringValue
                let location = object["location"]["name"].stringValue
                let newCharacter = Character(id: id, name: name, status: status, gender: gender, species: species, originName: origin, locationName: location, imageUrl: imageUrl)
                charactersArray.append(newCharacter)
            }
            if (isInitial) {
                self.launchScreenDelegate?.didFinishDownloadingCharacters(array: charactersArray)
            } else {
                self.mainPageDelegate?.didFinishDownloadingCharacters(array: charactersArray)
            }
        }.resume()
    }
}
