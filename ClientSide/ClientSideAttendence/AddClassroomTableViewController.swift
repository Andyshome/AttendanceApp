import UIKit

protocol addCourseViewControllerDelegate : class {
    func cancelAddCourses(_ controller:AddClassroomTableViewController )
    func addCourseViewController(_ controller:AddClassroomTableViewController, didFinishAdding item:classroom)
}

class AddClassroomTableViewController: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource,UITextFieldDelegate {
    
    var teacher:teacher?
    var newClassroom : classroom?
    var myDelegate : addCourseViewControllerDelegate?
    
    @IBOutlet weak var courseName: UITextField!
    @IBOutlet weak var courseCode: UITextField!
    
        @IBOutlet weak var studentGradePicker: UIPickerView!
        @IBOutlet weak var semesterPicker: UIPickerView!
        @IBOutlet weak var periodPicker: UIPickerView!
    
        var studentGradeValue: String = "9"
        var semesterValue: String = "1"
        var periodValue: String = "1"
    
        var studentGradePickerData: [String] = ["9", "10", "11", "12"]
        var semesterPickerData: [String] = ["1", "2"]
        var periodPickerData: [String] = ["1", "2", "3", "4"]
        
        override func viewDidLoad() {
            super.viewDidLoad()
            self.studentGradePicker.delegate = self
            self.studentGradePicker.dataSource = self
            
            self.semesterPicker.delegate = self
            self.semesterPicker.dataSource = self
            
            self.periodPicker.delegate = self
            self.periodPicker.dataSource = self
            
            self.courseCode.delegate = self
            self.courseName.delegate = self
        }
        
        override func numberOfSections(in tableView: UITableView) -> Int {
            return 4
        }
        
        func numberOfComponents(in pickerView: UIPickerView) -> Int {
            return 1
        }
        
        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            if pickerView.tag == 0 {
                return studentGradePickerData.count
            } else if pickerView.tag  == 1 {
                return semesterPickerData.count
            } else if pickerView.tag  == 2 {
                return periodPickerData.count
            }
            return 0
        }
    override func viewDidAppear(_ animated: Bool) {
        self.courseName.becomeFirstResponder()
    }
        func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            if pickerView.tag == 0 {
                return studentGradePickerData[row]
            } else if pickerView.tag  == 1 {
                return semesterPickerData[row]
            } else if pickerView.tag  == 2 {
                return periodPickerData[row]
            }
            return ""
        }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    @IBAction func done(_ sender: Any) {
        guard courseName.text != "" && courseCode.text != "" && periodValue != "" && semesterValue != "" && studentGradeValue != "" else {
            let alert = UIAlertController(title: "Warning!!!!", message: "You did not finish every textfield, please check it!", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Ok!Cool!", style: .default, handler: nil))
            
            self.present(alert, animated: true)
            return
        }
        print("just testing")
        if let classroom = teacher?.newClassroom() {
            print("wonder why")
            if let text = courseCode.text {
                classroom.courseCode = text
            }
            print("yup")
            if let text = courseName.text {
                classroom.Classname = text
            }
            classroom.period = periodValue
            classroom.Semester = semesterValue
            classroom.Grade = studentGradeValue
            
            print("this part is working")
            myDelegate?.addCourseViewController(self, didFinishAdding: classroom)
        }
        print("sure")
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 0 {
            studentGradeValue = studentGradePickerData[row]
        } else if pickerView.tag  == 1 {
            semesterValue = semesterPickerData[row]
        } else if pickerView.tag  == 2 {
            periodValue = periodPickerData[row]
        }
    }
    
}
