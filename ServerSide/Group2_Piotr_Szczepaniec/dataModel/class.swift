//
//  class.swift
//  AttendanceApp
//
//  Created by 邱子昂 on 2018/11/15.
//  Copyright © 2018 邱子昂. All rights reserved.
//

import Foundation

class classroom :  NSObject, Codable {
    var studentsList : [student] = []
    var attendenceList : [attendenceHistory] = []
    var period : String = ""
    var Grade : String = ""
    var Semester : String = ""
    var Classname : String = ""
    var courseCode : String = ""
    
    func countStudents() -> Int {
        return studentsList.count
    }
    
    func newStudents() -> student {
        let newStudent = student.init()
        return newStudent
    }
    func newAttendence() -> attendenceHistory {
        let newAttendence = attendenceHistory.init()
        for index in newAttendence.studentList {
            index.absentNote = ""
            index.attendence = true
        }
        return newAttendence
    }
}



