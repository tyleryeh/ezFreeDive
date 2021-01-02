//
//  RTCounter2ViewController.swift
//  ezFreeDiveTrainer_2
//
//  Created by Che Chang Yeh on 2021/1/2.
//

import UIKit
import CoreData

class RTCounter2ViewController: UIViewController {

    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet weak var myImageView: UIImageView!
    @IBOutlet weak var myTitalLabel: UILabel!
    @IBOutlet weak var myTimerLabel: UILabel!
    @IBOutlet weak var myCircleView: CircleUIView!
    
    var data: [TableData] = []
    var showDataBreath: [String] = []
    var showDataHold: [String] = []
    var circleBreath = [Double]()
    var circleHold = [Int]()
    var catchTableName = ""
    var duration = 0
    var flowControlCount = 0
    var holdArrayCounter = 0
    var breathArrayCounter = 0
    
    var timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        myTableView.delegate = self
        myTableView.dataSource = self
        myTableView.backgroundColor = UIColor.clear
        myImageView.image = UIImage(named: "wallclock")
        view.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "091EternalConstance"))
        
        myCircleView.backgroundColor = UIColor.clear
        
        self.myTitalLabel.text = self.catchTableName
        
        NotificationCenter.default.addObserver(self, selector: #selector(didFinishTimer), name: .timerFinish, object: nil)
        
        
        fetchCoreData()
        
    }
    
    @objc func didFinishTimer() {
        if flowControlCount < circleBreath.count * 2 {
            flowControlCount += 1
            //吐字串
            guard let interval = valueReset(index: flowControlCount) else {
                return
            }
            duration = Int(interval)
            let trans = SubFunctions.shared.intToStringForTimeFormatter(input: duration)
            myTimerLabel.text = "\(trans)"
            myCircleView.addAnimation(interval: interval)
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(upDateCircle), userInfo: nil, repeats: true)
        } else {
            flowControlCount = 0
            holdArrayCounter = 0
            breathArrayCounter = 0
            print("over")
        }
    }
    
    func valueReset(index: Int) -> Double?{
        if index % 2 == 0 {
            //Hold side
            print("holdC : \(holdArrayCounter)")
            let interval = Double(circleHold[holdArrayCounter])
            holdArrayCounter += 1
            return interval
        } else {
            //Breath side
            breathArrayCounter += 1
            print("breathC : \(breathArrayCounter)")
            let interval = Double(circleBreath[breathArrayCounter])
            return interval
        }
        
    }
    
    @IBAction func start() {
        duration = Int(circleBreath[0])
        let trans = SubFunctions.shared.intToStringForTimeFormatter(input: duration)
        myTimerLabel.text = "\(trans)"
        
        myCircleView.addAnimation(interval: circleBreath[0]) //只能執行一次，跟變數一樣
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(upDateCircle), userInfo: nil, repeats: true)
        flowControlCount = 0
        flowControlCount += 1
    }
    
    @objc func upDateCircle() {
        textUpdate()
    }
    //timer會一直叫
    func textUpdate() {
        if duration < 1 {
            //Stop timer
            timer.invalidate()
            //結束發送通知進行更新
            NotificationCenter.default.post(name: .timerFinish, object: nil)
        } else {
            duration = duration - 1
            let trans = SubFunctions.shared.intToStringForTimeFormatter(input: duration)
            myTimerLabel.text = "\(trans)"
        }
    }
    
    func fetchCoreData() {
        let moc = CoreDataHelper.shared.managedObjectContext()
        let fetchRequest = NSFetchRequest<TableData>(entityName: "TableData")
        fetchRequest.predicate = NSPredicate(format: "tableName contains[cd] %@", self.catchTableName)

        moc.performAndWait {
            do {
                self.data = try moc.fetch(fetchRequest)
                caculateTimeProgress(data: self.data)
            }catch {
                self.data = []
            }
        }
    }
    
    func caculateTimeProgress(data: [TableData]) {
        guard let totalBreath = Int(data[0].breath!),
              let totalReduce = Int(data[0].reduce!),
              let totalHoldTime = Int(data[0].hold!),
              let totalSet = Int(data[0].set!) else {
            return
        }
        for i in 0..<totalSet {
            let interval = totalBreath - totalReduce * i
            self.showDataBreath.append(SubFunctions.shared.intToStringForTimeFormatter(input: interval))
            self.showDataHold.append(SubFunctions.shared.intToStringForTimeFormatter(input: totalHoldTime))
            self.circleBreath.append(Double(interval))
            self.circleHold.append(totalHoldTime)
        }
        self.myTableView.reloadData()
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

extension RTCounter2ViewController: UITableViewDelegate {
    
}

extension RTCounter2ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.showDataBreath.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! RTCellTableViewCell
        cell.backgroundColor = UIColor.clear
        
        cell.breathtime.text = self.showDataBreath[indexPath.row]
        cell.holdtime.text = self.showDataHold[indexPath.row]
        
        return cell
    }
    
}
