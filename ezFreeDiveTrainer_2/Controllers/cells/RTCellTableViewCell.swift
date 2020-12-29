//
//  RTCellTableViewCell.swift
//  ezFreeDiveTrainer_2
//
//  Created by Che Chang Yeh on 2020/12/26.
//

import UIKit

class RTCellTableViewCell: UITableViewCell {
    
    @IBOutlet var breathtime: UILabel!
    @IBOutlet var holdtime: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
