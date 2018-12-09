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
    @IBOutlet weak var partyLabelName: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var pictureSlot: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
