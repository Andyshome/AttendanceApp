//
//  AttendenceHistory.swift
//  AttendanceApp
//
//  Created by 邱子昂 on 2018/11/29.
//  Copyright © 2018 邱子昂. All rights reserved.
//

import Foundation

class attendenceHistory :  NSObject, Codable {
    var date : Date = Date.init()
    var studentList : [student] = []
    var states : String = "Unsubmitted"
}
