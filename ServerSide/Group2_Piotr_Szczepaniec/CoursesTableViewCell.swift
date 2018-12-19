import UIKit

class CoursesTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var courseName: UILabel!
    @IBOutlet weak var courseCode: UILabel!
    @IBOutlet weak var studentCount: UILabel!
    
}
