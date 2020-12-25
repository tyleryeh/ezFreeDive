//
//  testViewController.swift
//  ezFreeDiveTrainer_2
//
//  Created by Che Chang Yeh on 2020/12/25.
//

import UIKit

class RTSetViewController: UIViewController {

    @IBOutlet weak var fastSetBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func fastSetBtnPressed(_ sender: Any) {
        let button = sender as? UIButton
        let buttonFrame = button?.frame ?? CGRect.zero
        let popoverViewSize = CGSize(width: 400, height: 200)
        let popoverContentController = self.storyboard?.instantiateViewController(withIdentifier: "RTFastSetShowVC") as? RTFastSetShowViewController
        //設定彈出來多少
        popoverContentController?.preferredContentSize = popoverViewSize
        
        popoverContentController?.modalPresentationStyle = .popover
        if let popoverPresentationController = popoverContentController?.popoverPresentationController {
            popoverPresentationController.permittedArrowDirections = .up
            popoverPresentationController.sourceView = self.view
            popoverPresentationController.sourceRect = buttonFrame
            popoverPresentationController.delegate = self
            
            if let popoverController = popoverContentController {
                present(popoverController, animated: true, completion: nil)
            }
            
            
        }
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

extension RTSetViewController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        
    }
    func presentationControllerShouldDismiss(_ presentationController: UIPresentationController) -> Bool {
        return true
    }
}
