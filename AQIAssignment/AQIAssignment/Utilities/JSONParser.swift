//
//  JSONParser.swift
//  AQIAssignment
//
//  Created by Ankur Batham on 23/11/21.
//

import Foundation
class JSONParser {
    typealias ResultBlock<T> = (Result <T, Error>) -> Void

    static func parse<T: Decodable>(of type: T.Type,
                                      from data: Data,
                                      completion: @escaping ResultBlock<T>) {

        do {
            let decodedData: T = try JSONDecoder().decode(T.self, from: data)
            completion(.success(decodedData))
        }
        catch let error {
            print(error)
            completion(.failure(error))
        }
    }
}
