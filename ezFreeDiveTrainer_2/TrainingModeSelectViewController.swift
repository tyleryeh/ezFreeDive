//
//  TrainingModeSelectViewController.swift
//  ezFreeDiveTrainer_2
//
//  Created by Che Chang Yeh on 2020/12/22.
//

import UIKit

class TrainingModeSelectViewController: UIViewController {

    @IBOutlet weak var myTrainingModeTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        view.bringSubviewToFront(myTrainingModeTableView)
        // Do any additional setup after loading the view.
        myTrainingModeTableView.delegate = self
        myTrainingModeTableView.dataSource = self
        myTrainingModeTableView.separatorStyle = .none
        
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

extension TrainingModeSelectViewController: UITableViewDelegate {
    
}

extension TrainingModeSelectViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TrainingModeTableViewCell
//        cell.modeTital.text = "靜態閉氣"
//        cell.modeDescryption.text = "6666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666"
//        cell.modeImageView.image = UIImage(named: "salutation")
        
        switch indexPath.row {
        case 0:
            cell.modeTital.text = "時間遞減 + time"
            cell.modeDescryption.text = "66666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666"
            cell.modeImageView.image = UIImage(named: "salutation")
        case 1:
            cell.modeTital.text = "時間遞減 + 呼吸次數"
            cell.modeDescryption.text = "66666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666"
            cell.modeImageView.image = UIImage(named: "salutation")
        case 2:
            cell.modeTital.text = "步數遞減 + time"
            cell.modeDescryption.text = "66666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666"
            cell.modeImageView.image = UIImage(named: "salutation")
        case 3:
            cell.modeTital.text = "步數遞減 + 呼吸次數"
            cell.modeDescryption.text = "66666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666"
            cell.modeImageView.image = UIImage(named: "salutation")
            
        default:
            cell.modeTital.text = "TBD"
            cell.modeDescryption.text = "TBD"
            cell.modeImageView.image = UIImage(named: "salutation")
        }
        
        
        return cell
    }
    
    
}
