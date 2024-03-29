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
    
    var icons: [String] = ["bubbles", "cat-face", "hammerheadfishshape", "shark", "wave", "buoy"]
    var selectedDate = ""
    var showData: [Diary]?
    
    let formatterr: DateFormatter = {
       let foramtter = DateFormatter()
//        foramtter.timeStyle = .medium
        foramtter.dateStyle = .medium
        return foramtter
    }()
    
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
        myFSCalendar.appearance.titleFont = UIFont.systemFont(ofSize: 16.0)
        myFSCalendar.appearance.titleDefaultColor = UIColor.darkText
//        myFSCalendar.appearance.headerTitleFont = UIFont.systemFont(ofSize: 16.0)
//        myFSCalendar.appearance.weekdayFont = UIFont.systemFont(ofSize: 14.0)
        
        myTableView.backgroundColor = UIColor.clear
        
        //到此頁面如果使用者沒有選日期，就給今天的日期
        selectedDate = formatterr.string(from: Date())
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fetchCoreData()
    }
    
    func fetchCoreData() {
        self.showData = SubFunctions.shared.fetchDiaryDataDate(date: selectedDate)
        self.myTableView.reloadData()
    }
    
//    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
//        self.myFSCalendar?.reloadData()
//    }
    
    func newObjectAttributeForEquip(data: Diary) {
        data.eSuit = ""
        data.eMask = ""
        data.eFins = ""
        data.eWeight = ""
        data.eVisibility = ""
        data.eMaxDepth = ""
        data.eDiveTime = ""
        data.eWaterTemp = ""
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addNote" {
            let vc = segue.destination as! DiaryNoteSetViewController
            vc.title = "\(selectedDate)"
            
            //創新物件，傳過去
            let moc = CoreDataHelper.shared.managedObjectContext()
            let diary = Diary(context: moc)
            diary.diaryId = UUID().uuidString
            diary.diaryDate = selectedDate
            newObjectAttributeForEquip(data: diary)
            CoreDataHelper.shared.saveContext()
            
            if let uuid = diary.diaryId {
                vc.uuidString = uuid
            }
            
        }
    }
    

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
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        //使用者選完日期，更新選擇的日期
        selectedDate = formatterr.string(from: date)
        fetchCoreData()
    }
    
    
}
extension DiaryViewController: FSCalendarDataSource{
    
}


extension DiaryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let uuid = self.showData?[indexPath.row].diaryId {
            let vc = storyboard?.instantiateViewController(identifier: "diaryNoteVC") as! DiaryNoteSetViewController
            vc.uuidString = uuid
            self.show(vc, sender: nil)
        } else {
            print("No uuid in calendar.")
        }
        
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let rmdata = self.showData?.remove(at: indexPath.row)
            let moc = CoreDataHelper.shared.managedObjectContext()
            moc.performAndWait {
                moc.delete(rmdata!)
            }
            CoreDataHelper.shared.saveContext()
            self.myTableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}

extension DiaryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return showData?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! DiaryCellTableViewCell
        cell.selectionStyle = .none
        cell.backgroundColor = UIColor.clear
        
        guard let array = self.showData else {return cell}
        if array.count != 0 {
            cell.myLabel.text = array[indexPath.row].diaryName
            let randomIndex = Int.random(in: 0..<icons.count)
            cell.myImageView.image = UIImage(named: icons[randomIndex])
            return cell
        } else {
            return cell
        }
        
    }

}
