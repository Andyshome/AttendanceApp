import UIKit
import Firebase
import FirebaseUI
import CodableFirebase
import FirebaseFirestore

class ViewController: UIViewController, FUIAuthDelegate {
    
    @IBOutlet weak var btnLogin: UIButton!
    
    var authUI : FUIAuth?
    var fstore : Firestore!
    override func viewDidLoad() {
        super.viewDidLoad()
        authUI = FUIAuth.defaultAuthUI()
        authUI?.delegate = self
        fstore = Firestore.firestore()
    }
    // Do any additional setup after loading the view, typically from a nib.
    
    func authUI(_ authUI: FUIAuth, didSignInWith authDataResult: AuthDataResult?, error: Error?) {
        guard error == nil else {
            return
        }
        let userName : String = (Auth.auth().currentUser?.displayName)!
        let userEmail : String = (Auth.auth().currentUser?.email)!
        let useruid : String = (Auth.auth().currentUser?.uid)!
        if error == nil {
            btnLogin.setTitle("Logout", for: .normal)
        }
        let doc = fstore.collection("teacher").document(Auth.auth().currentUser!.uid)
        doc.getDocument { (document, error) in
            guard error == nil else {
                print(error?.localizedDescription)
                return
            }
            if let document = document, document.exists {
                let dataDescription = document.data()
                print(dataDescription)
            } else {
                var newTeacher = teacher.init()
                newTeacher.name = userName
                newTeacher.emailAddress = userEmail
                newTeacher.uid = useruid
                let encodeTool = FirestoreEncoder()
                let data = try? encodeTool.encode(newTeacher)
                self.fstore.collection("teacher").document(Auth.auth().currentUser!.uid).setData(data!)
            }
            let appdelegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate as! AppDelegate
            appdelegate.login()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    @IBAction func doBtnLogin(_ sender: Any) {
        if Auth.auth().currentUser == nil {
            if let authVC = authUI?.authViewController(){
                present(authVC, animated: true, completion: nil)
            }
        }
        else {
            do {
                try Auth.auth().signOut()
                self.btnLogin.setTitle("login", for: .normal)
            }
            catch {}
        }
    }
    
}

