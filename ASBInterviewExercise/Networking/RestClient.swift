//
//  RestClient.swift
//  ASBInterviewExercise
//
//  Created by ASB on 29/07/21.
//

import Foundation

class RestClient {
    
    private var session: URLSession
    
    init() {
        session = URLSession(configuration: .default)
    }
    
    func getUrl() -> URL?{
        let baseURLString = "https://gist.githubusercontent.com/Josh-Ng/500f2716604dc1e8e2a3c6d31ad01830/raw/4d73acaa7caa1167676445c922835554c5572e82/test-data.json"
        return URL(string: baseURLString)
    }
    
    func prepareURLRequest() -> URLRequest? {
        guard let url = getUrl() else {
            return nil
        }
        
        var request = URLRequest(url: url)
        
        //To demonstrate functionality we can have with URLRequest, the following line does not allow app to process the request over the celular and expensive networks.
        request.allowsCellularAccess = false
        request.allowsExpensiveNetworkAccess = false
        request.allowsConstrainedNetworkAccess = false
        
        return request
    }
    
    func prepareAndCallApi<T: Decodable>(type: T.Type, completion: @escaping(Result<T,APIErrors>) -> Void) -> URLSessionTask? {
        guard let request = prepareURLRequest() else {
            let error = APIErrors.badURL
            completion(Result.failure(error))
            return nil
        }
        
        let apiCompletionHandler: (Data?, URLResponse?, Error?) -> Void = { data, response, error in
            
            if let error = error as? URLError {
                completion(Result.failure(APIErrors.urlSession(error)))
            } else if let response = response as? HTTPURLResponse, !(200...299).contains(response.statusCode) {
                completion(Result.failure(APIErrors.badResponse(response.statusCode)))
            } else if let data = data {
                
                do {
                    let result = try JSONDecoder().decode(type, from: data)
                    completion(Result.success(result))
                } catch {
                    completion(Result.failure(.decoding(error as? DecodingError)))
                }
            }
        }
        
        let sessionTask = apiRequest(request, completionHandler: apiCompletionHandler)
        return sessionTask
    }
    
    func apiRequest(_ request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionTask {
        
        let sessionTask = session.dataTask(with: request, completionHandler: completionHandler)
        sessionTask.resume()
        return sessionTask
    }
    
    func cancelAllTasks() {
        session.getAllTasks { (tasks) in
            for task in tasks {
                task.cancel()
            }
        }
    }
}
