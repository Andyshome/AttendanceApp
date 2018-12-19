    import UIKit
    import Firebase
    
    protocol StudentsDetailViewControllerDelegate: class {
        func finishAttendence(_ controller: StudentsDetailTableViewController)
    }
    
    class StudentsDetailTableViewController: UITableViewController {
        
        @IBAction func unwindToVC1(segue:UIStoryboardSegue) { }
        
        let storage = Storage.storage()
        
        @IBAction func segmentControl(_ sender: UISwitch) {
            if sender.isOn {
                myAttendeceSheet?.studentList[sender.tag].attendence = true
            } else {
                myAttendeceSheet?.studentList[sender.tag].attendence = false
            }
        }
        
        let superTeacher = teacherList.init()
        var indexOfCell : Int?
        var myAttendeceSheet : attendenceHistory?
        var myDelegate : StudentsDetailViewControllerDelegate?
        
        override func viewDidLoad() {
            super.viewDidLoad()
            self.tableView.separatorStyle = .none
            print(myAttendeceSheet?.states)
            print(myAttendeceSheet?.studentList.count)
        }

        @IBAction func submit(_ sender: Any) {
            myAttendeceSheet?.states = "Submitted"
            superTeacher.updateData()
            myDelegate?.finishAttendence(self)
        }
        
        override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return (myAttendeceSheet?.studentList.count)!
        }
        
        override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "studentListCell", for: indexPath) as? StudentTableViewCell
            print("generating")
            cell?.studentImage.layer.cornerRadius = (cell?.studentImage.frame.size.width)! / 2
            cell?.studentImage.clipsToBounds = true
            cell?.studentName.text = myAttendeceSheet?.studentList[indexPath.row].name
            cell?.studentNumber.text = myAttendeceSheet?.studentList[indexPath.row].studentNumber
            cell?.switchControl.tag = indexPath.row
            if myAttendeceSheet?.studentList[indexPath.row].attendence == true {
                cell?.switchControl.isOn = true
            } else {
                cell?.switchControl.isOn = false
            }
            
            cell?.detailTextLabel?.text = "Grade" + (myAttendeceSheet?.studentList[indexPath.row].Grade)!
            // Configure the cell...
            
            let pathRef = storage.reference(withPath: (myAttendeceSheet?.studentList[indexPath.row].imageOfStudent)!)
            pathRef.getData(maxSize: 1 * 1024 * 1024) { (data, error) in
                guard error == nil else {
                    cell?.studentImage.image = UIImage.init(named: "default")
                    return
                }
            cell?.studentImage.image = UIImage.init(data: data!)
            }
            
            return cell!
        }
        
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "addNotes" {
                if let AddDetailsTableViewController = segue.destination as? AddDetailsTableViewController {
                    if let indexPath = indexOfCell {
                        AddDetailsTableViewController.myStudent = myAttendeceSheet?.studentList[indexPath]
                    }
                }
            }
        }
        
        override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            print(indexPath.row)
            indexOfCell = indexPath.row
            self.performSegue(withIdentifier: "addNotes", sender: nil)
        }
        
        
    
}


