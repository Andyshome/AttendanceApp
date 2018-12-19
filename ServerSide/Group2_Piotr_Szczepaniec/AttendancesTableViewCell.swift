import UIKit

class AttendancesTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    @IBOutlet weak var dateOutlet: UILabel!
    @IBOutlet weak var myImage: UIImageView!
    @IBOutlet weak var extraOutlet: UILabel!
    
    
}
