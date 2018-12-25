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

class teacher:  NSObject, Codable {
    var classList : [classroom] = []
    var name : String = ""
    var emailAddress : String = ""
    func newClassroom() -> classroom {
        let myNewclassroom = classroom.init()
        return myNewclassroom
    }
    
}




class teacherList {
    static let fstore = Firestore.firestore()
    static var myTeacher : teacher = teacher()
    func saveData(){
        let dataToSave = teacherList.myTeacher
        print(dataToSave)
        print("Data is saving")
        let documentDictonary = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let archiveURL = documentDictonary.appendingPathComponent("Attendece").appendingPathExtension("plist")
        let propertyListEncoder = PropertyListEncoder()
        let encodeList = try? propertyListEncoder.encode(dataToSave)
        try? encodeList?.write(to: archiveURL,options:.noFileProtection)
    }
    
    
    func readData() {
        let documentDictonary = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let archiveURL = documentDictonary.appendingPathComponent("Attendence").appendingPathExtension("plist")
        let propertyListDecoder = PropertyListDecoder()
        print("readingData")
        if let retrievedListData = try? Data(contentsOf: archiveURL),
            let decodeTeacher = try?
                propertyListDecoder.decode(
                    teacher.self, from: retrievedListData){
            guard decodeTeacher.name != "" else {return}
            teacherList.myTeacher = decodeTeacher
            print("finish reading data")
            
        }
    }
    
    func updateData()  {
        let teacherEncode : teacher = teacherList.myTeacher
        let encodeTool = FirestoreEncoder()
        let data = try? encodeTool.encode(teacherEncode)
        let doc = teacherList.fstore.collection("teacher").document(Auth.auth().currentUser!.uid)
        doc.updateData(data!)
    }
    
}
