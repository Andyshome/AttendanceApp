    import UIKit
    import Firebase
    
    
    protocol AddStudentsViewControllerDelegate : class {
        func cancelAddStudents(_ controller:AddStudentTableViewController )
        func addStudentsViewController(_ controller:AddStudentTableViewController, didFinishAdding item:student)
    }
    
    
    class AddStudentTableViewController: UITableViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
        
        @IBOutlet weak var studentImage: UIImageView!
        
        @IBOutlet weak var nameTextField: UITextField!
        
        @IBOutlet weak var gradeTextFiled: UITextField!
        
        @IBOutlet weak var studentNumberTextField: UITextField!
        
        
        var myclassroom : classroom?
        var myDelegate : AddStudentsViewControllerDelegate?
        let storageRef = Storage.storage().reference()
        
        
        override func viewDidLoad() {
            super.viewDidLoad()
            self.tableView.separatorStyle = .none
            studentImage.layer.cornerRadius = studentImage.frame.width / 2
            studentImage.clipsToBounds = true
            studentImage.image = UIImage.init(named: "default")
            let imgTap = UITapGestureRecognizer(target: self, action: #selector(loadImg(recognizer:)))
            imgTap.numberOfTapsRequired = 1
            studentImage.isUserInteractionEnabled = true
            studentImage.addGestureRecognizer(imgTap)
        }
        @IBAction func Cancel(_ sender: Any) {
            myDelegate?.cancelAddStudents(self)
        }
        
        @IBAction func Done(_ sender: Any) {
            guard studentImage.image != UIImage.init(named: "default") && nameTextField.text != "" && gradeTextFiled.text != "" && studentNumberTextField.text != "" else {
                let alert = UIAlertController(title: "Warning!!!!", message: "You did not finish every textfield, please check it!", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok!Cool!", style: .default, handler: nil))
                
                self.present(alert, animated: true)
                return
            }
            submitImage()
        }
        @objc func loadImg(recognizer:UITapGestureRecognizer) -> Void {
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.sourceType = .photoLibrary
            picker.allowsEditing = true
            present(picker, animated: true, completion: nil)
            
        }
        func imagePickerController(_ picker: UIImagePickerController,
                                   didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            
            guard let selectedImage = info[.originalImage] as? UIImage else {
                print("select picture error!")
                return
            }
            
            studentImage.image = selectedImage
            dismiss(animated: true, completion: nil)
        }
        
        func submitImage() {
            let studentImageRef = storageRef.child("image/"+nameTextField.text! + ".jpg")
            if let imageData = studentImage.image!.jpegData(compressionQuality: 0.05) {
                let metadata = StorageMetadata.init()
                metadata.contentType = "image/jpeg"
                let sv = UITableViewController.displaySpinner(onView: self.view)
                let uploadTask = studentImageRef.putData(imageData, metadata: metadata) { (metadata, error) in
                    guard error == nil else {
                        print(error?.localizedDescription)
                        UITableViewController.removeSpinner(spinner: sv)
                        return
                    }
                    if let newStudent = self.myclassroom?.newStudents() {
                        UITableViewController.removeSpinner(spinner: sv)
                        newStudent.name = self.nameTextField.text!
                        newStudent.Grade = self.gradeTextFiled.text!
                        newStudent.studentNumber = self.studentNumberTextField.text!
                        newStudent.imageOfStudent = (metadata?.path)!
                        self.myDelegate?.addStudentsViewController(self, didFinishAdding: newStudent)
                    }
                }
            }
            
        }
        
        
}

extension UITableViewController {
    class func displaySpinner(onView : UIView) -> UIView {
        let spinnerView = UIView.init(frame: onView.bounds)
        spinnerView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let ai = UIActivityIndicatorView.init(style: .whiteLarge)
        ai.startAnimating()
        ai.center = spinnerView.center
            
        DispatchQueue.main.async {
            spinnerView.addSubview(ai)
            onView.addSubview(spinnerView)
        }
            
        return spinnerView
    }
        
    class func removeSpinner(spinner :UIView) {
        DispatchQueue.main.async {
            spinner.removeFromSuperview()
        }
    }
}
