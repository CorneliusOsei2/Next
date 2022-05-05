

struct User{
    let id: String
    let name: String
    let username: String
    let courses_as_student: [Course]
    let courses_as_instructor: [Course]
    let timeslots_as_students: [Timeslot]
    let timeslots_as_instructor: [Timeslot]
}



struct Course {
    let id: String
    let code: String
    let name: String
    let instructors: Array
}