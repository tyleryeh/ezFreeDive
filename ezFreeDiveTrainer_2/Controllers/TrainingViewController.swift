//
//  TariningViewController.swift
//  ezFreeDiveTrainer_2
//
//  Created by Che Chang Yeh on 2020/12/22.
//

import UIKit

class TrainingViewController: UIViewController {
    
    let fullScreenSize = UIScreen.main.bounds.size
    
    @IBOutlet weak var addBtnPressed: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "訓練"
        self.view.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "091EternalConstance"))
    }
    
    @objc func clickButton() {
        
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension UIButton {
    
}
