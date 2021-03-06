
import Foundation
import Alamofire
import SwiftyJSON

struct NetworkManager{
    static let baseUrl = "http://0.0.0.0:5000/next/"
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
    
    static func login(forUsername username: String, forPassword password: String, completion: @escaping (LoginResponse) -> Void) {
        let loginURL = baseUrl + "login/"
        let parameters : Parameters = [
            "username": username,
            "password": password
        ]
        
        AF.request(loginURL, method: .post, parameters: parameters, encoding: JSONEncoding.default).validate().responseData { (response) in
            switch response.result {
            case .success(let data):
                let decoder = JSONDecoder()
                if let loginResponse = try? decoder.decode(LoginResponse.self, from: data) {
                    completion(loginResponse)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    static func get_courses(fromSessionToken sessionToken: String, completion: @escaping (UserCoursesResponse) -> Void ) {
        let headers : HTTPHeaders = [
            "Authorization" : "Bearer " + sessionToken
        ]

        let getUserCourseURL = baseUrl + "courses/"
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
    
    static func get_timeslots(fromSessionToken sessionToken: String, forCourseId courseId: String, forMonth month: String, forDay day: String, completion: @escaping (TimeslotsResponse) -> Void) {
        let headers : HTTPHeaders = [
            "Authorization" : "Bearer " + sessionToken
        ]

        let getTimeslotsUrl = baseUrl + "courses/" + courseId + "/" + month + "/" + day + "/timeslots/"
        AF.request(getTimeslotsUrl, method: .get, parameters: [:], headers: headers).validate().responseData { (response) in
            switch response.result {
            case .success(let data):
                let decoder = JSONDecoder()
                if let timeslotsResponse = try? decoder.decode(TimeslotsResponse.self, from: data) {
                    completion(timeslotsResponse.self)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    static func get_queue_info(fromSessionToken sessionToken: String, forCourseId courseId: String, forTimeslotId timeslotId: String, completion: @escaping (QueueInfoResponse) -> Void) {
        let headers : HTTPHeaders = [
            "Authorization" : "Bearer " + sessionToken
        ]

        let getQueueInfoUrl = baseUrl + "courses/" + courseId + "/queues/" + timeslotId + "/"
        AF.request(getQueueInfoUrl, method: .get, parameters: [:], headers: headers).validate().responseData { (response) in
            switch response.result {
            case .success(let data):
                let decoder = JSONDecoder()
                if let queueInfoResponse = try? decoder.decode(QueueInfoResponse.self, from: data) {
                    completion(queueInfoResponse.self)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    static func join_queue(fromSessionToken sessionToken: String, forCourseId courseId: String, forTimeslotId timeslotId: String, completion: @escaping (JoinLeaveQueueResponse) -> Void) {
        let headers : HTTPHeaders = [
            "Authorization" : "Bearer " + sessionToken
        ]
        let joinQueueUrl = baseUrl + "courses/" + courseId + "/timeslots/" + timeslotId + "/join/"

        AF.request(joinQueueUrl, method: .post, parameters: [:], headers: headers).validate().responseData { (response) in
            switch response.result {
            case .success(let data):
                let decoder = JSONDecoder()
                if let joinQueueResponse = try? decoder.decode(JoinLeaveQueueResponse.self, from: data) {
                    completion(joinQueueResponse)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    static func leave_queue(fromSessionToken sessionToken: String, forCourseId courseId: String, forTimeslotId timeslotId: String, completion: @escaping (JoinLeaveQueueResponse) -> Void) {
        let headers : HTTPHeaders = [
            "Authorization" : "Bearer " + sessionToken
        ]
        let leaveQueueUrl = baseUrl + "courses/" + courseId + "/timeslots/" + timeslotId + "/leave/"

        AF.request(leaveQueueUrl, method: .post, parameters: [:], headers: headers).validate().responseData { (response) in
            switch response.result {
            case .success(let data):
                let decoder = JSONDecoder()
                if let leaveQueueResponse = try? decoder.decode(JoinLeaveQueueResponse.self, from: data) {
                    completion(leaveQueueResponse)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }


//    static func add_timeslot(fromSessionToken sessionToken: String, forCourseId courseId: String, forTimeslotId timeslotId: String, completion: @escaping (AddTimeslotResponse) -> Void) {
//        let headers : HTTPHeaders = [
//            "Authorization" : "Bearer " + sessionToken
//        ]
//        let addTimeslotUrl = baseUrl + "/courses/" + courseId + "/timeslots/" + timeslotId + "/"
//        let parameters : Parameters = [
//            "start_time": start_time,
//            "end_time": end_time
//        ]
//
//        AF.request(loginURL, method: .post, parameters: parameters, encoding: JSONEncoding.default).validate().responseData { (response) in
//            switch response.result {
//            case .success(let data):
//                let decoder = JSONDecoder()
//                if let addTimeslotResponse = try? decoder.decode(AddTimeslotResponse.self, from: data) {
//                    completion(addTimeslotResponse)
//                }
//            case .failure(let error):
//                print(error.localizedDescription)
//            }
//        }
//    }


}
