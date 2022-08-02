//
//  APIErrors.swift
//  ASBInterviewExercise
//
//  Created by Paresh Kacha on 1/08/22.
//

import Foundation

enum APIErrors: Error, CustomStringConvertible {
    
    case badURL
    case urlSession(URLError?)
    case badResponse(Int)
    case decoding(DecodingError?)
    case unknown
    
    var description: String {
        switch self {
            case .badURL:
                return "badURL"
            case .urlSession(let error):
                return "urlSession error: \(error.debugDescription)"
            case .badResponse(let statusCode):
                return "bad response with status code: \(statusCode)"
            case .decoding(let decodingError):
                return "decoding error: \(String(describing: decodingError))"
            case .unknown:
                return "unknown error"
        }
    }
    
    var localizedDescription: String {
        switch self {
            case .badURL, .unknown:
               return "something went wrong"
            case .urlSession(let urlError):
                return urlError?.localizedDescription ?? "something went wrong"
            case .badResponse(let discription):
                return "Bad response \(discription),\nsomething went wrong"
            case .decoding(let decodingError):
                return decodingError?.localizedDescription ?? "something went wrong"
        }
    }
}

