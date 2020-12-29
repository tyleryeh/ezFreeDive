//
//  TrainingModeTableViewCell.swift
//  ezFreeDiveTrainer_2
//
//  Created by Che Chang Yeh on 2020/12/22.
//

import UIKit

class TrainingModeTableViewCell: UITableViewCell {
    
    @IBOutlet var modeTital: UILabel!
    @IBOutlet var modeDescryption: UILabel!
    @IBOutlet var myshadowView: UIView!
    @IBOutlet var myInnerView: UIView!
    @IBOutlet var modeImageView: UIImageView!
    
    

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

        
        //modeImageView setting
        modeImageView.layer.cornerRadius = modeImageView.frame.size.width / 2
        modeImageView.clipsToBounds = true
        
        //畫漸層
//        let gradient = CAGradientLayer()
//        gradient.frame =  CGRect(origin: .zero, size: self.modeImageView.frame.size)
//        let color1 = UIColor(hexString: "#a6c0fe").cgColor
//        let color2 = UIColor(hexString: "#f68084").cgColor
//        gradient.colors = [color1, color2]
//        let shape = CAShapeLayer()
//        shape.lineWidth = 0.5
//        shape.path = UIBezierPath(arcCenter: CGPoint(x: 36, y: 36), radius: CGFloat(36), startAngle: CGFloat(0), endAngle:CGFloat(Double.pi * 2), clockwise: true).cgPath
//        shape.strokeColor = UIColor.black.cgColor
//        shape.fillColor = UIColor.clear.cgColor
//        gradient.mask = shape
//
//        self.modeImageView.layer.addSublayer(gradient)

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}

