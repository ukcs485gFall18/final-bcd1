//
//  ReservationCell.swift
//  ForgetMeNot
//
//  Created by Blake Sweet on 11/27/18.
//

import Foundation
import UIKit

//You should follow naming conventions in Swift, look at how I renamed this class
class ReservationsCustomerTableViewCell : UITableViewCell{
    @IBOutlet weak var companyLabelName: UILabel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
