//
//  DataManager.swift
//  RickAndMortyWiki
//
//  Created by Rodion Chikerenda on 18.12.2020.
//

import Foundation

class DataManager {
    static let instance = DataManager()
    
    private var charactersArrray = [Character]()
    private var charactersPageCounter = 2
    
    // MARK: -  Getters
    func getCharacters() -> [Character] {
        return charactersArrray
    }
    
    func getPagesNumber() -> Int {
        return charactersPageCounter
    }
    
    // MARK: -  Setters
    func setCharactersArray(with array: [Character]) {
        charactersArrray.append(contentsOf: array)
    }
    
    func increasePagesNumber() {
        charactersPageCounter += 1
    }
}
