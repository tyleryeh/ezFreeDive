//
//  TrainingModeCell2TableViewCell.swift
//  ezFreeDiveTrainer_2
//
//  Created by Che Chang Yeh on 2020/12/29.
//

import UIKit

class TrainingModeCell2TableViewCell: UITableViewCell {
    
    @IBOutlet var mode2Tital: UILabel!
    @IBOutlet var mode2Descryption: UILabel!
    @IBOutlet var myshadowView: UIView!
    @IBOutlet var myInnerView: UIView!
    @IBOutlet var mode2ImageView1: UIImageView!
    @IBOutlet var mode2ImageView2: UIImageView!
    @IBOutlet var mode2ImageInnerView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        //myshadowView setting
        myshadowView.layer.shadowColor = UIColor.darkGray.cgColor
        myshadowView.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        myshadowView.layer.shadowOpacity = 0.5
        myshadowView.layer.shadowRadius = 2
        myshadowView.layer.cornerRadius = 30
        
//        myInnerView.backgroundColor = UIColor.clear
        myshadowView.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "077ColdEvening"))
        myInnerView.backgroundColor = UIColor.clear
        mode2ImageInnerView.backgroundColor = UIColor.clear
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
