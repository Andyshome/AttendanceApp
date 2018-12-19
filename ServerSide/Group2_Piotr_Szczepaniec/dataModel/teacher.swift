//
//  teacher.swift
//  AttendanceApp
//
//  Created by 邱子昂 on 2018/11/15.
//  Copyright © 2018 邱子昂. All rights reserved.
//

import Foundation
import Firebase
import CodableFirebase
import FirebaseFirestore



class teacher: NSObject, Codable {
    var classList: [classroom] = []
    var name : String = ""
    var uid : String = ""
    var emailAddress : String = ""
    
    func newClassroom() -> classroom {
        let myNewclassroom = classroom.init()
        return myNewclassroom
    }
    
}




class teacherList {
    static let fstore = Firestore.firestore()
    static var myTeacher : [teacher] = []
    
    
    
    func updateData()  {
        let teacherEncode : [teacher] = teacherList.myTeacher
        for index in teacherEncode {
            let encodeTool = FirestoreEncoder()
            let data = try? encodeTool.encode(index)
            let doc = teacherList.fstore.collection("teacher").document(index.uid)
            doc.updateData(data!)
        }
    }
    
}
