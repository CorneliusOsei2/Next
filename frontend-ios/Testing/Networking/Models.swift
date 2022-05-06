
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
    let user_name: String
    let courses_as_instructor: [CourseNoUsers]
    let courses_as_student: [CourseNoUsers]
}

struct TimeslotsResponse: Codable {
    let timeslots: [Timeslot]
}

struct Timeslot: Codable {
    let id: String
    let title: String
    let course_id: String
    let date: String
    let start_time: String
    let end_time: String
    let instructors: [UserInTimeslot]
}

struct UserInTimeslot: Codable {
    let id: String
    let name: String
    let username: String
}

struct User: Codable {
    let id: String
    let name: String
    let username: String
    let courses_as_student: [CourseNoUsers]
    let courses_as_instructor: [CourseNoUsers]
    let timeslots_as_students: [Timeslot]
    let timeslots_as_instructor: [Timeslot]
}

struct CourseNoUsers: Codable {
    let id: String
    let code: String
    let name: String
    let color: String
}

struct CourseWithUsers: Codable {
    let id: String
    let code: String
    let name: String
    let color: String
    let instructors: [User]
    let students: [User]
}

