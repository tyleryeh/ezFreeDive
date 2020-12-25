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

    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if let identifier = segue.identifier {
//            switch identifier {
//            case "timetimeSegue":
//                let vc = segue.destination as! TimeTimeViewController
//            default:
//                break
//            }
//        }
//    }
    
}

extension TrainingModeSelectViewController: UITableViewDelegate {
    
}

extension TrainingModeSelectViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TrainingModeTableViewCell
        
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
            break
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0: reduceTime()
        case 1: reduceTimeBreath()
        case 2: reduceStep()
        case 3: reduceStepBreath()
        default: break
        }
    }
    func reduceTime() {
        if let controller = storyboard?.instantiateViewController(withIdentifier: "ReduceTime") {
            show(controller, sender: nil)
        }
    }
    func reduceTimeBreath() {
        if let controller = storyboard?.instantiateViewController(withIdentifier: "ReduceTimeBreath") {
            show(controller, sender: nil)
        }
    }
    func reduceStep() {
        if let controller = storyboard?.instantiateViewController(withIdentifier: "ReduceStep") {
            show(controller, sender: nil)
        }
    }
    func reduceStepBreath() {
        if let controller = storyboard?.instantiateViewController(withIdentifier: "ReduceStepBreath") {
            show(controller, sender: nil)
        }
    }
    
}
