//
//  ReservationsHostTableViewCell.swift
//  ForgetMeNot
//
//  Created by Corey Baker on 12/1/18.
//  Copyright © 2018 Ray Wenderlich. All rights reserved.
//

import UIKit

//You should following naming conventions in Swift, look at how I renamed this class

class ReservationsHostTableViewCell: UITableViewCell {

    @IBOutlet weak var customerNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
