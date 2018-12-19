//
//  File.swift
//  AttendanceApp
//
//  Created by 邱子昂 on 2018/11/12.
//  Copyright © 2018 邱子昂. All rights reserved.
//

import Foundation
import UIKit

class student: NSObject, Codable {
    var name:String = ""
    var imageOfStudent : String = ""
    var studentNumber : String = ""
    var Grade:String = ""
    var attendence:Bool = true
    var absentTimes:Int = 0
    var absentNote : String = ""
}


