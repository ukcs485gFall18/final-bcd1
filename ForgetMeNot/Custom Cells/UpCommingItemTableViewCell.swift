/*
 * Copyright (c) 2017 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import UIKit

class UpCommingItemTableViewCell: UITableViewCell {
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblSize: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var checkInLabel: UILabel!
    @IBOutlet weak var lblLocation: UILabel!

    //@IBOutlet weak var imgIcon: UIImageView!
    
    /*
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }*/
    
  var item: Item? = nil {
    didSet {
      if let item = item {
        //imgIcon.image = Icons(rawValue: item.icon)?.image()
        lblDate.text = item.getItemDate()
        lblName.text = item.name
        lblSize.text = String(item.size)
        lblTime.text = item.getItemTime()
        checkInLabel.text = "Pending ❌"
        lblLocation.text = item.locationString()
      } else {
        //imgIcon.image = nil
        lblName.text = ""
        lblLocation.text = ""
      }
    }
  }
  
  func refreshLocation() {
    lblLocation.text = item?.locationString() ?? ""
  }
    
    func checkedIn() { // Used to switch the status of a check-in
        checkInLabel.text = "Check in Status: ✅"
    }
    
    func checkedInTest() -> Bool{ // Test if a reservation has been checked in
        if (checkInLabel.text == "Check in Status: ✅"){
            return true
        }
        else{
            return false
        }
    }
}
