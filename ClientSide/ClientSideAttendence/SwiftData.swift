import Foundation

class teacherList {
    
    static var myTeacher: teacher = teacher()
    
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
                    teacher.self, from: retrievedListData) {
            guard decodeTeacher.name != "" else {return}
            teacherList.myTeacher = decodeTeacher
            print("finish reading data")
        }
    }
}

class teacher: NSObject, Codable {
    var classList : [classroom] = []
    var name : String = ""
    var emailAddress : String = ""
}

class classroom: NSObject, Codable {
    var classTable : [student] = []
    var period : String
    var Grade : Int
    var Semester : String
    var Classname : String
    var courseCode : String
}

class student: NSObject, Codable {
    var name:String
    var attendence:Bool
    var absentTimes:Int
    var absentNote : [String]
}
