//
//  SuperheroRepository.swift
//  superherofinder-demo
//
//  Created by Christian Alvarado on 8/3/25.
//

import Foundation

struct KebabCaseKey: CodingKey {
    let stringValue: String
    init?(stringValue: String) { self.stringValue = stringValue }
    
    var intValue: Int? { return nil }
    init?(intValue: Int) { return nil }
}

extension JSONDecoder.KeyDecodingStrategy {
    static var convertFromKebabCase: JSONDecoder.KeyDecodingStrategy {
        return .custom { keys in
            let lastKey = keys.last!
            let stringValue = lastKey.stringValue
            
            // Do not convert if there are no hyphens
            guard stringValue.contains("-") else {
                return lastKey
            }
            
            // Transform kebab-case to camelCase
            let components = stringValue.components(separatedBy: "-")
            guard !components.isEmpty else { return lastKey }
            
            let firstComponent = components[0].lowercased()
            let remainingComponents = components.dropFirst().map {
                $0.prefix(1).uppercased() + $0.dropFirst().lowercased()
            }
            
            let camelCaseString = firstComponent + remainingComponents.joined()
            
            return KebabCaseKey(stringValue: camelCaseString)!
        }
    }
}

protocol SuperheroDataRepository {
    func searchByName(_ name: String) async throws -> [SuperheroDTO]
    func getById(_ id: String) async throws -> SuperheroDTO
}

struct SuperheroAPIRepository: SuperheroDataRepository {
    private let baseURL: URL
    private let accessToken: String
    
    init(baseURL: URL = API.apiBaseURL, accessToken: String = API.apiKey) {
        self.baseURL = baseURL
        self.accessToken = accessToken
    }
    
    func searchByName(_ name: String) async throws -> [SuperheroDTO] {
        guard let encodedName = name.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed),
              let url = URL(string: "\(baseURL.absoluteString)/\(accessToken)/search/\(encodedName)") else {
            throw URLError(.badURL)
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromKebabCase
        
        return try decoder.decode(SuperheroSearchNameAPIResponse.self, from: data).results
    }
    
    func getById(_ id: String) async throws -> SuperheroDTO {
        guard let url = URL(string: "\(baseURL.absoluteString)/\(accessToken)/\(id)") else {
            throw URLError(.badURL)
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromKebabCase
        
        let apiResponse = try decoder.decode(SuperheroIdAPIResponse.self, from: data)
        
        guard apiResponse.id == id else {
            throw NSError(domain: "SuperheroError", code: 404, userInfo: [NSLocalizedDescriptionKey: "Superhero not found"])
        }
        
        return SuperheroDTO(from: apiResponse)
    }
}

struct SuperheroLocalRepository: SuperheroDataRepository {
    func searchByName(_ name: String) async throws -> [SuperheroDTO] {
        let data = try Data(contentsOf: Bundle.main.url(forResource: "superhero-api-response-test", withExtension: "json")!)
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromKebabCase
        
        let response = try decoder.decode(SuperheroSearchNameAPIResponse.self, from: data)
        
        return response.results.filter { $0.name.lowercased().contains(name.lowercased()) }
    }
    
    func getById(_ id: String) async throws -> SuperheroDTO {
        let data = try Data(contentsOf: Bundle.main.url(forResource: "superhero-id-api-response-test", withExtension: "json")!)
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromKebabCase
        
        let apiResponse = try decoder.decode(SuperheroIdAPIResponse.self, from: data)
        
        guard apiResponse.id == id else {
            throw NSError(domain: "SuperheroError", code: 404, userInfo: [NSLocalizedDescriptionKey: "Superhero not found"])
        }
        
        return SuperheroDTO(from: apiResponse)
    }
    
    //    func getByIdSimple(_ id: String) async throws -> SuperheroDTO {
    //        let data = try Data(contentsOf: searchJSONURL)
    //
    //        let decoder = JSONDecoder()
    //        decoder.keyDecodingStrategy = .convertFromKebabCase
    //
    //        let response = try decoder.decode(SuperheroAPIResponse.self, from: data)
    //
    //        return response.results.first(where: { $0.id == id }) ?? response.results.first!
    //    }
}

struct SuperheroMockRepository: SuperheroDataRepository {
    func searchByName(_ name: String) async throws -> [SuperheroDTO] {
        return [Self.getMockElement()]
    }
    
    func getById(_ id: String) async throws -> SuperheroDTO {
        return try await searchByName("")[0]
    }
    
    static func getMockElement() -> SuperheroDTO {
        return SuperheroDTO(
            id: "1",
            name: "A-Bomb",
            powerstats: Powerstats(
                intelligence: "38",
                strength: "100",
                speed: "17",
                durability: "80",
                power: "24",
                combat: "64"
            ),
            biography: Biography(
                fullName: "Richard Milhouse Jones",
                alterEgos: "No alter egos found.",
                aliases: ["Rick Jones"],
                placeOfBirth: "Scarsdale, Arizona",
                firstAppearance: "Hulk Vol 2 #2 (April, 2008) (as A-Bomb)",
                publisher: "Marvel Comics",
                alignment: "good"
            ),
            appearance: Appearance(
                gender: "Male",
                race: "Human",
                height: ["6'8", "203 cm"],
                weight: ["980 lb", "441 kg"],
                eyeColor: "Yellow",
                hairColor: "No Hair"
            ),
            work: Work(
                occupation: "Musician, adventurer, author; formerly talk show host",
                base: "-"
            ),
            connections: Connections(
                groupAffiliation: "Hulk Family; Excelsior (sponsor), Avengers (honorary member); formerly partner of the Hulk, Captain America and Captain Marvel; Teen Brigade; ally of Rom",
                relatives: "Marlo Chandler-Jones (wife); Polly (aunt); Mrs. Chandler (mother-in-law); Keith Chandler, Ray Chandler, three unidentified others (brothers-in-law); unidentified father (deceased); Jackie Shorr (alleged mother; unconfirmed)"
            ),
            image: SuperheroImage(
                url: "https://www.superherodb.com/pictures2/portraits/10/100/10060.jpg"
            )
        )
    }
}
