import UIKit
import Firebase
import DropDown

class StudentTableViewController: UITableViewController {

    var myclassroom: classroom?
    let myTeacherList = teacherList.init()
    let storage = Storage.storage()
    
    @IBOutlet weak var extraItems: UIBarButtonItem!
    
    @IBAction func extraItemsAction(_ sender: Any) {
        let dropDown = DropDown()
        dropDown.anchorView = extraItems
        dropDown.bottomOffset = CGPoint(x: 0, y:(dropDown.anchorView?.plainView.bounds.height)!)
        dropDown.dataSource = ["Add Student", "Attendances"]
        dropDown.show()
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            if index == 0 {
                self.performSegue(withIdentifier: "addStudent", sender: nil)
            } else if index == 1 {
                self.performSegue(withIdentifier: "startAttendence", sender: nil)
            }
        }
    }
    
    @IBOutlet var myTableView: UITableView!
    
    @IBAction func addStudent(_ sender: Any) {
        performSegue(withIdentifier: "addStudent", sender: nil)
    }
    
    @IBAction func startAttendence(_ sender: Any) {
        performSegue(withIdentifier: "startAttendence", sender: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.separatorStyle = .none
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (myclassroom?.studentsList.count)!
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "mainCell2", for: indexPath) as? StudentTableViewCell

        cell?.studentImage.layer.cornerRadius = (cell?.studentImage.frame.size.width)! / 2
        cell?.studentImage.clipsToBounds = true
        cell?.studentName.text = myclassroom?.studentsList[indexPath.row].name
        cell?.studentNumber.text = myclassroom?.studentsList[indexPath.row].studentNumber
        let pathRef = storage.reference(withPath: myclassroom!.studentsList[indexPath.row].imageOfStudent)
        pathRef.getData(maxSize: 1 * 1024 * 1024) { (data, error) in
            guard error == nil else {
                cell?.studentImage.image = UIImage.init(named: "default")
                return
            }
            cell?.studentImage.image = UIImage.init(data: data!)
        }
        

        return cell!
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        myclassroom?.studentsList.remove(at: indexPath.row)
        myTeacherList.updateData()
        self.tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("sureeeeeeee")
        if segue.identifier == "addStudent" {
            if let myAddStudentsViewController = segue.destination as? AddStudentTableViewController {
                myAddStudentsViewController.myclassroom = myclassroom
                myAddStudentsViewController.myDelegate = self
                }
            } else if segue.identifier == "startAttendence" {
                print("letttts go")
                if let attendeceVC = segue.destination as? AttendenceHistoryTableViewController {
                    attendeceVC.myClassroom = myclassroom
                }
        }
    }
    func verifyUrl(urlString: String?) -> Bool {
        if let urlString = urlString {
            if let url = URL(string: urlString) {
                return UIApplication.shared.canOpenURL(url)
            }
        }
        return false
    }

}

extension StudentTableViewController: AddStudentsViewControllerDelegate {
    func cancelAddStudents(_ controller: AddStudentTableViewController) {
        navigationController?.popViewController(animated: true)
    }
    
    func addStudentsViewController(_ controller: AddStudentTableViewController, didFinishAdding item: student) {
        navigationController?.popViewController(animated: true)
        myclassroom?.studentsList.append(item)
        myTeacherList.updateData()
        print("this is working good")
    }
}
