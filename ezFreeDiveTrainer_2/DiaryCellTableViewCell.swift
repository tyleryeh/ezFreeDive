//
//  DiaryCellTableViewCell.swift
//  ezFreeDiveTrainer_2
//
//  Created by Che Chang Yeh on 2020/12/30.
//

import UIKit

class DiaryCellTableViewCell: UITableViewCell {

    @IBOutlet var myLabel: UILabel!
    @IBOutlet var myshadowView: UIView!
    @IBOutlet var myInnerView: UIView!
    @IBOutlet var myImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //myshadowView setting
        myshadowView.layer.shadowColor = UIColor.darkGray.cgColor
        myshadowView.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        myshadowView.layer.shadowOpacity = 0.5
        myshadowView.layer.shadowRadius = 2
        myshadowView.layer.cornerRadius = 30
        
//        myInnerView.backgroundColor = UIColor.clear
        myshadowView.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "077ColdEvening"))
        myInnerView.backgroundColor = UIColor.clear

        
        //modeImageView setting
        myImageView.layer.cornerRadius = myImageView.frame.size.width / 2
        myImageView.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
