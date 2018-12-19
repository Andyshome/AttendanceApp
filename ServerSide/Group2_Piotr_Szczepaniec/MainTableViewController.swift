import UIKit
import MultipeerConnectivity
import DropDown
import Firebase
import CodableFirebase
import FirebaseFirestore

var globalSelectedCoursesRow: Int = 0
var globalColorTheme: Bool = true

class MainTableViewController: UITableViewController, MCSessionDelegate, MCBrowserViewControllerDelegate {
    
    var fstore = Firestore.firestore()
    var myTeacher :teacher = teacher()
    var indexOfCell : Int?
    let myTeacherList = teacherList.init()
    
    @IBOutlet weak var extraItems: UIBarButtonItem!
    
    var myArray: [String] = ["image1", "image2", "image3", "image1", "image2", "image3", "image1", "image2", "image3", "image1", "image2", "image3", "image1", "image2", "image3", "image1", "image2", "image3", "image1", "image2", "image3", "image1", "image2", "image3", "image1", "image2", "image3", "image1", "image2", "image3", "image1", "image2", "image3", "image1", "image2", "image3", "image1", "image2", "image3", "image1", "image2", "image3", "image1", "image2", "image3", "image1", "image2", "image3", "image1", "image2", "image3", "image1", "image2", "image3", "image1", "image2", "image3", "image1", "image2", "image3"]
    
    @IBAction func extraItemsAction(_ sender: Any) {
        let dropDown = DropDown()
        dropDown.anchorView = extraItems
        dropDown.bottomOffset = CGPoint(x: 0, y:(dropDown.anchorView?.plainView.bounds.height)!)
        dropDown.dataSource = ["Add Classroom"]
        dropDown.show()
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            if index == 0 {
                self.performSegue(withIdentifier: "addClassroom", sender: nil)
            }
        }
    }


    var peerID: MCPeerID!
    var mcSession: MCSession!
    var mcAdvertiserAssistant: MCAdvertiserAssistant!
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.scrollsToTop = true
        /////
        /////
        self.tableView.separatorStyle = .none
        self.tableView.allowsSelection = true
        peerID = MCPeerID(displayName: UIDevice.current.name)
        mcSession = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .required)
        mcSession.delegate = self
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myTeacher.classList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "mainCell", for: indexPath) as? CoursesTableViewCell
        
        cell?.backgroundImage.image = UIImage(named: myArray[indexPath.row])
        //cell?.backgroundImage.isUserInteractionEnabled = true
        cell?.backgroundImage.layer.cornerRadius = 9
        cell?.backgroundImage.clipsToBounds = true
        cell?.courseName.text = myTeacher.classList[indexPath.row].Classname
        cell?.courseCode.text = myTeacher.classList[indexPath.row].courseCode
        cell?.studentCount.text = String(myTeacher.classList[indexPath.row].countStudents()) + " Students"
        //cell?.backgroundImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imageTapped)))
        
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        myTeacher.classList.remove(at: indexPath.row)
        myTeacherList.updateData()
        self.tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "addClassroom" {
            if let myAddCourseViewController = segue.destination as? AddClassroomTableViewController {
                myAddCourseViewController.teacher = myTeacher
                myAddCourseViewController.myDelegate = self
            }
            } else if segue.identifier == "fromCourses" {
                print("nope")
                if let myClassroomDetailViewController = segue.destination as? StudentTableViewController {
                    print("got here")
                    if let indexPath = indexOfCell {
                        let classroomToSend = myTeacher.classList[indexPath]
                        myClassroomDetailViewController.myclassroom = classroomToSend
                        print("finish sending classroom")
                    }
                }
            }
    }
    
    @IBAction func imageTapped(_ sender: UITapGestureRecognizer) {
        print("tapped")
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        
        indexOfCell = indexPath.row
        self.performSegue(withIdentifier: "fromCourses", sender: nil)
    }
    
    /////////////////////////
    
    ////////////////////////
    
    func startHosting(action: UIAlertAction!) {
        mcAdvertiserAssistant = MCAdvertiserAssistant(serviceType: "hws-kb", discoveryInfo: nil, session: mcSession)
        mcAdvertiserAssistant.start()
    }
    
    func joinSession(action: UIAlertAction!) {
        let mcBrowser = MCBrowserViewController(serviceType: "hws-kb", session: mcSession)
        mcBrowser.delegate = self
        present(mcBrowser, animated: true)
    }
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state {
        case MCSessionState.connected:
            print("Connected: \(peerID.displayName)")
            sendTeacherJSON()
        case MCSessionState.connecting:
            print("Connecting: \(peerID.displayName)")
        case MCSessionState.notConnected:
            print("Not Connected: \(peerID.displayName)")
        }
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        DispatchQueue.main.async { [unowned self] in
            //let jsonString = String(data: data, encoding: .utf8)
            //print(jsonString)
            /*
            var newTeacherStruct: teacher
            
            if let json = try? JSONDecoder().decode(teacher.self, from: data) {
                newTeacherStruct = json
                self.tableList.append(newTeacherStruct)
                print(newTeacherStruct.name)
            }
            
            self.tableView.reloadData()
 */
        }
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        
    }
    
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true)
    }
    
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true)
    }
    
    ////////////////////////
    
    func sendTeacherJSON() {
        
        var newOne: teacher = teacher()
        newOne.classList = []
        newOne.name = "PiotrR"
        newOne.emailAddress = "yes"
        
        do {
            
            let jsonData = try JSONEncoder().encode(newOne)
            
            if mcSession.connectedPeers.count > 0 {
                do {
                    try mcSession.send(jsonData, toPeers: mcSession.connectedPeers, with: .reliable)
                } catch let error as NSError {
                    let ac = UIAlertController(title: "Send error", message: error.localizedDescription, preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "OK", style: .default))
                    present(ac, animated: true)
                }
            }
            
        } catch {
            print(error)
        }
        
    }
    
    /////////////////////////

}

extension MainTableViewController: addCourseViewControllerDelegate {
    
    func cancelAddCourses(_ controller: AddClassroomTableViewController) {
        print("exited")
        navigationController?.popViewController(animated: true)
    }
    
    func addCourseViewController(_ controller: AddClassroomTableViewController, didFinishAdding item: classroom) {
        myTeacher.classList.append(item)
        print("try to exit")
        myTeacherList.updateData()
        tableView.reloadData()
        navigationController?.popViewController(animated: true)
    }
    
}
