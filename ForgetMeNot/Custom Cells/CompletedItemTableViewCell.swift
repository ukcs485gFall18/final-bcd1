//
//  CompletedReservationTableViewCell.swift
//
//  Created by David Mercado on 12/10/18.
//

import UIKit

class CompletedItemTableViewCell: UITableViewCell {
    @IBOutlet weak var LblDate: UILabel!
    @IBOutlet weak var LblName: UILabel!
    @IBOutlet weak var LblSize: UILabel!
    @IBOutlet weak var LblTime: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func modCompletedCell(res: MyReservation){
        print("ModCell: \(res)")
        
        LblDate.text = res.getMonthDay()
        LblName.text = res.getPartyName()
        LblSize.text = String(res.getPartySize())
        LblTime.text = res.getHourMin()
    }
}
