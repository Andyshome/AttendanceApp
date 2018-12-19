import UIKit

class AddDetailsTableViewController: UITableViewController {

    let superTeacher = teacherList.init()
    var myStudent: student?
    var myDelegate: StudentsDetailViewControllerDelegate?
    
    @IBOutlet weak var noteText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        noteText.text = myStudent?.absentNote
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    @IBAction func save(_ sender: Any) {
        myStudent?.absentNote = noteText.text!
        self.performSegue(withIdentifier: "unwindFromDetails", sender: nil)
    }
    
}
