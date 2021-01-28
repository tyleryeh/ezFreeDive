//
//  HistoryViewController.swift
//  ezFreeDiveTrainer_2
//
//  Created by Che Chang Yeh on 2021/1/3.
//

import UIKit
import CoreData

class HistoryViewController: UIViewController {
    
    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet var myshadowView: UIView!
    @IBOutlet var myInnerView: UIView!
    
    var data: [TableData] = []
    var diaryData: [Diary]?
//    var locationData: [DiveLocation]?
    // TimelinePoint, Timeline back color, title, description, lineInfo, thumbnails, illustration
//    var showData = [Int: [(TimelinePoint, UIColor, String, String, String?, [String]?, String?)]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myshadowView.layer.shadowColor = UIColor.darkGray.cgColor
        myshadowView.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        myshadowView.layer.shadowOpacity = 0.5
        myshadowView.layer.shadowRadius = 2
        myshadowView.layer.cornerRadius = 30
        myshadowView.backgroundColor = UIColor.clear
        myInnerView.backgroundColor = UIColor.clear
        
        self.view.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "091EternalConstance"))
        self.title = "History"
        myTableView.delegate = self
        myTableView.dataSource = self
        myTableView.backgroundColor = UIColor.clear
        
        let timelineTableViewCellNib = UINib(nibName: "TimelineTableViewCell", bundle: Bundle(for: TimelineTableViewCell.self))
        self.myTableView.register(timelineTableViewCellNib, forCellReuseIdentifier: "cell")
//        testAddCoreData()
        fetchCoreData()
        
    }
    
    func testAddCoreData() {
        let moc = CoreDataHelper.shared.managedObjectContext()
        let diary = Diary(context: moc)
        diary.diaryId = UUID().uuidString

        let location = Location(context: moc)
        location.name = "我是測試一號"
        location.lon = "23.4444"
        location.lat = "6666223"
        let locationObjc2 = Location(context: moc)
        locationObjc2.name = "我是測試二號"
        locationObjc2.lon = "36"
        locationObjc2.lat = "6688"
        
        diary.addToToLocation(NSSet(array: [location, locationObjc2]))

        CoreDataHelper.shared.saveContext()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super .viewDidAppear(animated)
    }
    
    func fetchCoreData() {
        self.data = SubFunctions.shared.fetchTableData()
        self.diaryData = SubFunctions.shared.fetchDiaryData()
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

extension HistoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension HistoryViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return self.data.count
        case 1:
            return self.diaryData?.count ?? 0
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TimelineTableViewCell
        
        cell.backgroundColor = UIColor.clear
        cell.bubbleColor = UIColor.clear
        cell.bubbleEnabled = false
        cell.titleLabel.font = UIFont.init(name: "Chalkboard SE Regular", size: 26)
        cell.descriptionLabel.font = UIFont.systemFont(ofSize: 14)
        cell.timeline.width = 3.5
        cell.timelinePoint = TimelinePoint(diameter: 10, lineWidth: 1, color: UIColor.black, filled: true)
        
        cell.timeline.leftMargin = tableView.bounds.width * 0.18
        
        
        //時間軸設定
        if indexPath.row == 0 {
            cell.timeline.backColor = UIColor.black  //時間軸的線
            cell.timeline.frontColor = UIColor.clear //圓點連接處
        } else if indexPath.row == self.data.count - 1 {
            cell.timeline.backColor = UIColor.clear
            cell.timeline.frontColor = UIColor.black
        } else {
            cell.timeline.backColor = UIColor.black
            cell.timeline.frontColor = UIColor.black
        }

        switch indexPath.section {
        case 0:
            guard let breath = self.data[indexPath.row].breath,
                  let hold = self.data[indexPath.row].hold,
                  let set = self.data[indexPath.row].set else {
                return cell
            }
            cell.titleLabel.text = self.data[indexPath.row].tableName
            cell.descriptionLabel.text = "BreathTime: \(breath), HoldTime: \(hold), Set: \(set)"
            if indexPath.row == 0 {
                cell.illustrationImageView.image = UIImage(named: "wallclock")
                cell.illustrationSize.constant = 40
                cell.viewsInStackView = [UIImageView(image: UIImage(named: "wallclock"))]
            }
            return cell
        case 1:
            
            if let array = self.diaryData?[indexPath.row],
               let locationArray = array.toLocation?.allObjects as? [Location] {
                
                cell.titleLabel.text = array.diaryId
                if locationArray.count != 0 {
                    var descriptionLabelText = ""
                    for i in 0..<locationArray.count {
                        if let name = locationArray[i].name,
                           let lon = locationArray[i].lon,
                           let lat = locationArray[i].lat {
                            descriptionLabelText.append(name)
                            descriptionLabelText.append(",")
                            descriptionLabelText.append(lon)
                            descriptionLabelText.append(",")
                            descriptionLabelText.append(lat)
                        } else {
                            print("No cell Data!")
                        }
                    }
                    cell.descriptionLabel.text = descriptionLabelText
                }
                return cell
            } else {
                return cell
            }
        default:
            return cell
        }
        
        
        // TimelinePoint, Timeline back color, title, description, lineInfo, thumbnails, illustration
//        let data:[Int: [(TimelinePoint, UIColor, String, String, String?, [String]?, String?)]] = [0:[
//                (TimelinePoint(), UIColor.black, "12:30", "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.", nil, nil, "Sun")

    }
    
    
}
