//
//  ReduceTimeCellTableViewCell.swift
//  ezFreeDiveTrainer_2
//
//  Created by Che Chang Yeh on 2020/12/28.
//

import UIKit

class ReduceTimeCellTableViewCell: UITableViewCell {
    
    @IBOutlet var myImage: UIImageView!
    @IBOutlet var myLabel: UILabel!
    
    @IBOutlet var myshadowView: UIView!
    @IBOutlet var myInnerView: UIView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        myshadowView.layer.shadowColor = UIColor.darkGray.cgColor
        myshadowView.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        myshadowView.layer.shadowOpacity = 0.5
        myshadowView.layer.shadowRadius = 2
        myshadowView.layer.cornerRadius = 30
        myshadowView.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "077ColdEvening"))
        
        //modeImageView setting
        myImage.layer.cornerRadius = myImage.frame.size.width / 2
        myImage.clipsToBounds = true
        myImage.image = UIImage(named: "wallclock")
        
        myInnerView.backgroundColor = UIColor.clear
        
    }

}
