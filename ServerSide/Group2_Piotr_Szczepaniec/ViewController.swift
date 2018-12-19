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
       
            let appdelegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate as! AppDelegate
            appdelegate.login()
        
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

