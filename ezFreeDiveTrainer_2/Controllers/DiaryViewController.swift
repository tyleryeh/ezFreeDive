//
//  DiaryViewController.swift
//  ezFreeDiveTrainer_2
//
//  Created by Che Chang Yeh on 2020/12/22.
//

import UIKit
import FSCalendar

class DiaryViewController: UIViewController {

    @IBOutlet weak var myFSCalendar: FSCalendar!
    @IBOutlet weak var myTableView: UITableView!
    
    var icons: [String] = ["bubbles", "cat-face", "hammerheadfishshape", "shark", "wave"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Diary"
        // Do any additional setup after loading the view.
        myTableView.delegate = self
        myTableView.dataSource = self
        myFSCalendar.delegate = self
        myFSCalendar.dataSource = self
        
        view.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "091EternalConstance"))
        
        myFSCalendar.backgroundColor =  UIColor.clear
        myFSCalendar.appearance.titleFont = UIFont.systemFont(ofSize: 20.0)
        myFSCalendar.appearance.titleDefaultColor = UIColor.darkText
//        myFSCalendar.appearance.headerTitleFont = UIFont.systemFont(ofSize: 16.0)
//        myFSCalendar.appearance.weekdayFont = UIFont.systemFont(ofSize: 14.0)
        
        myTableView.backgroundColor = UIColor.clear
        
    }
    override func viewWillAppear(_ animated: Bool) {
        myTableView.reloadData()
    }
    
//    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
//        self.myFSCalendar?.reloadData()
//    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension DiaryViewController: FSCalendarDelegate{
//    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
//
//            let defaultColor = appearance.titleDefaultColor
//
//            if #available(iOS 12.0, *) {
//                if self.traitCollection.userInterfaceStyle == .dark {
//                    return .orange
//                } else {
//                    return defaultColor
//                }
//            } else {
//                return defaultColor
//            }
//        }
    
    
}
extension DiaryViewController: FSCalendarDataSource{
    
}


extension DiaryViewController: UITableViewDelegate {
    
}

extension DiaryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! DiaryCellTableViewCell
        cell.myLabel.text = "小琉球海訓"
        let randomIndex = Int.random(in: 0..<icons.count)
        cell.myImageView.image = UIImage(named: icons[randomIndex])
        cell.selectionStyle = .none
        cell.backgroundColor = UIColor.clear
        return cell
    }

}
