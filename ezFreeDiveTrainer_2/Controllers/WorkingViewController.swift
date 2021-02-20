//
//  WorkingViewController.swift
//  ezFreeDiveTrainer_2
//
//  Created by Che Chang Yeh on 2021/2/20.
//

import UIKit
import Lottie

class WorkingViewController: UIViewController {

    @IBOutlet weak var workLottieView: LottieView!
    
    let workingAnimation = AnimationView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "091EternalConstance"))

        //AnimationViewSetting
        workingAnimation.frame = workLottieView.bounds
        workingAnimation.animation = Animation.named("working")
        workingAnimation.contentMode = .scaleToFill
        workingAnimation.loopMode = .playOnce
        workingAnimation.animationSpeed = 1
        workLottieView.addSubview(workingAnimation)
        workLottieView.backgroundColor = UIColor.clear
        workingAnimation.play()
        
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
