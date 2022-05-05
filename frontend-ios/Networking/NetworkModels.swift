

struct User{
    let id: UUID?
    let name: String
    let username: String
    let courses_as_student: [Course]
    let courses_as_instructor: [Course]
    let timeslots_as_students: [Timeslot]
    let timeslots_as_instructor: [Timeslot]
}

struct Course {
    let id: UUID?
    let code: String
    let name: String
    let instructors: [User]
    let students: [User]
}

struct Month {
    let id: Int
    let number: Int
    let active: Int
    let days: [Day]
}

struct Day {
    let id: Int
    let number: Int
    let active: Int
    let month: Int
}