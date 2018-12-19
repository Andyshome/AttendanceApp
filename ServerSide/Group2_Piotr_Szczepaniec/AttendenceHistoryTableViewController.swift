    import UIKit
    
    class AttendenceHistoryTableViewController: UITableViewController {
        
        var myClassroom : classroom?
        var indexOfCell : Int?
        let superTeacher = teacherList.init()
        @IBOutlet var myTableView: UITableView!
        
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(false)
            self.tableView.reloadData()
        }
        
        override func viewDidLoad() {
            super.viewDidLoad()
            self.tableView.separatorStyle = .none
        }
        
        override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return myClassroom!.attendenceList.count
        }
        
        @IBAction func startNewAttendence(_ sender: Any) {
            if let newAttendence = myClassroom?.newAttendence() {
                newAttendence.studentList = myClassroom!.studentsList
                newAttendence.date = Date.init()
                for index in newAttendence.studentList {
                    index.absentNote = ""
                    index.attendence = true
                }
                myClassroom?.attendenceList.append(newAttendence)
                superTeacher.updateData()
                self.tableView.reloadData()
            }
        }
        
        override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            guard myClassroom?.attendenceList[indexPath.row].states != "Submitted" else {
                let alert = UIAlertController(title: "Warning!!!!", message: "You already submit this attendence sheet you can not delete it", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "Ok!Cool!", style: .default, handler: nil))
                
                
                self.present(alert, animated: true)
                return
            }
            
            myClassroom?.attendenceList.remove(at: indexPath.row)
            superTeacher.updateData()
            self.tableView.reloadData()
        }
        
        override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "attendenceCell", for: indexPath) as? AttendancesTableViewCell
            
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            let myString = formatter.string(from: (myClassroom?.attendenceList[indexPath.row].date)!)
            
            cell?.dateOutlet.text = myString
            cell?.extraOutlet.text = myClassroom?.attendenceList[indexPath.row].states
            
            if myClassroom?.attendenceList[indexPath.row].states == "Unsubmitted" {
                cell?.myImage.image = UIImage(named: "newwarning")
                cell?.extraOutlet.text = "Not submitted"
                cell?.extraOutlet.textColor = UIColor.red
            } else {
                cell?.myImage.image = UIImage(named: "sentimage")
                cell?.extraOutlet.text = myClassroom?.attendenceList[indexPath.row].states
                cell?.extraOutlet.textColor = UIColor.green
            }
            
            return cell!
        }
        
        override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            print(indexPath.row)
            
            indexOfCell = indexPath.row
            self.performSegue(withIdentifier: "goToStudentList", sender: nil)
        }
        
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "goToStudentList" {
                if let studentListVC = segue.destination as? StudentsDetailTableViewController {
                    print("I am going to do something")
                    studentListVC.myDelegate = self
                    studentListVC.myAttendeceSheet = myClassroom?.attendenceList[indexOfCell!]
                }
            }
        }
        
       
    }
    
    extension AttendenceHistoryTableViewController : StudentsDetailViewControllerDelegate {
        func finishAttendence(_ controller: StudentsDetailTableViewController) {
            navigationController?.popViewController(animated: true)
        }
        
        
        
}
