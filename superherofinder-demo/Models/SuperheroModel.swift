//
//  SuperheroModel.swift
//  superherofinder-demo
//
//  Created by Christian Alvarado on 8/3/25.
//

import Foundation

struct SuperheroSearchNameAPIResponse: Codable {
    let response, resultsFor: String
    let results: [SuperheroDTO]
}

struct SuperheroIdAPIResponse: Identifiable, Codable {
    let response, id, name: String
    let powerstats: Powerstats
    let biography: Biography
    let appearance: Appearance
    let work: Work
    let connections: Connections
    let image: SuperheroImage
}

extension SuperheroDTO {
    init(from apiResponse: SuperheroIdAPIResponse) {
        self.id = apiResponse.id
        self.name = apiResponse.name
        self.powerstats = apiResponse.powerstats
        self.biography = apiResponse.biography
        self.appearance = apiResponse.appearance
        self.work = apiResponse.work
        self.connections = apiResponse.connections
        self.image = apiResponse.image
    }
}

struct SuperheroDTO: Identifiable, Codable {
    let id, name: String
    let powerstats: Powerstats
    let biography: Biography
    let appearance: Appearance
    let work: Work
    let connections: Connections
    let image: SuperheroImage
}

struct Appearance: Codable {
    let gender, race: String
    let height, weight: [String]
    let eyeColor, hairColor: String
}

struct Biography: Codable {
    let fullName, alterEgos: String
    let aliases: [String]
    let placeOfBirth, firstAppearance, publisher, alignment: String
}

struct Connections: Codable {
    let groupAffiliation, relatives: String
}

struct SuperheroImage: Codable {
    let url: String
}

struct Powerstats: Codable {
    let intelligence, strength, speed, durability: String
    let power, combat: String
}

struct Work: Codable {
    let occupation, base: String
}
