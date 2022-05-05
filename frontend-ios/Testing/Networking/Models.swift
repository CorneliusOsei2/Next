
import Foundation
import UIKit


struct LoginResponse: Codable {
    let user_id: String
    let session_token: String
    let session_expiration: String
    let update_token: String
}

struct User{
    let id: String
    let name: String
    let username: String
    let courses_as_student: [Course]
    let courses_as_instructor: [Course]
//    let timeslots_as_students: [Timeslot]
//    let timeslots_as_instructor: [Timeslot]
}

struct UserCoursesResponse: Codable {
    let user_id: String
    let courses_as_instructor: [Course]
    let courses_as_student: [Course]
}

struct Course: Codable {
    let id: String
    let code: String
    let name: String
}


