
import Foundation
import UIKit


struct LoginResponse: Codable {
    let user_id: String
    let session_token: String
    let session_expiration: String
    let update_token: String
}

struct UserCoursesResponse: Codable {
    let user_id: String
    let courses_as_instructor: [Course]
    let courses_as_student: [Course]
}

struct User{
    let id: UUID?
    let name: String
    let username: String
    let courses_as_student: [Course]
    let courses_as_instructor: [Course]
    let timeslots_as_students: [Timeslot]
    let timeslots_as_instructor: [Timeslot]
}

struct Course: Codable {
    let id: UUID?
    let code: String
    let name: String
    let instructors: [User]
    let students: [User]
}

struct Timeslot: Codable {
    let id: UUID?
    let course_id: UUID?
    let date: String
    let start_time: String
    let end_time: String
    let total_joined: Int
}

