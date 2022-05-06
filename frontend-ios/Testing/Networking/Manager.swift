
import Foundation
import Alamofire
import SwiftyJSON

struct NetworkManager{
    static let api = "http://0.0.0.0:4500/"
    static let defaultSession = URLSession(configuration: .default)

    static var decoder: JSONDecoder = {
        let dec = JSONDecoder()
        dec.dateDecodingStrategy = .iso8601
        return dec
    }()
    
    enum RequestType: String {
        case get = "GET"
        case post = "POST"
        case put = "PUT"
        case delete = "DELETE"
    }
    
    enum RequestError: Error {
        case notFound
        case badRequest
        case uncategorized
        case decodingError(Error)
    }

    static func get_courses(fromSessionToken sessionToken: String, completion: @escaping (UserCoursesResponse) -> Void ) {
        let headers : HTTPHeaders = [
            "Authorization" : "Bearer " + sessionToken
        ]

        let getUserCourseURL = api + "next/courses/"

        AF.request(getUserCourseURL, method: .get, parameters: [:], headers: headers).validate().responseData { (response) in
            switch response.result {
            case .success(let data):
                let decoder = JSONDecoder()
                if let userCourseResponse = try? decoder.decode(UserCoursesResponse.self, from: data) {
                    completion(userCourseResponse.self)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

//    static func getAllMonths(completionHandler: @escaping (Result<[Month], RequestError>) -> Void) throws {
//        try networkingCall(route: "months/", requestType: .get, completionHandler: completionHandler)
//    }
//
//
//
//
//    private static func networkingCall<T: Codable>(route: String = "", requestType: RequestType, content: Song? = nil, parameters: CustomStringConvertible..., completionHandler: @escaping (Result<T, RequestError>) -> Void) throws {
//        guard let url = URL(string: api + route + parameters.map({$0.description + "/"}).reduce("", +)) else { return }
//
//        var request = URLRequest(url: url)
//        request.httpMethod = requestType.rawValue
//
//        if let content = content {
//            let encodedData = try JSONEncoder().encode(content)
//            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//            request.addValue("application/json", forHTTPHeaderField: "accept")
//            request.httpBody = encodedData
//        }
//        let dataTask = defaultSession.dataTask(with: request) { data, response, error in
//            if let error = error {
//                print(error)
//                return
//            } else if let data = data {
//                if let response = response as? HTTPURLResponse, response.statusCode != 200 {
//                    let unwrappedError: RequestError = {
//                        switch response.statusCode {
//                            case 404: return .notFound
//                            case 400: return .badRequest
//                            default: return .uncategorized
//                        }
//                    }()
//                    print(String(data: data, encoding: String.Encoding.utf8) as Any)
//                    completionHandler(.failure(unwrappedError))
//                    return
//                }
//
//                do {
//                    let decodedData = try decoder.decode(T.self, from: data)
//                    completionHandler(.success(decodedData))
//                } catch {
//                    completionHandler(.failure(.decodingError(error)))
//                }
//            } else {
//                completionHandler(.failure(.uncategorized))
//            }
//        }
//        dataTask.resume()
//    }
}
