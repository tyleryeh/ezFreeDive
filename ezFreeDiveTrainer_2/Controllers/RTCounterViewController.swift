//
//  RTCounterViewController.swift
//  ezFreeDiveTrainer_2
//
//  Created by Che Chang Yeh on 2020/12/28.
//

import UIKit
import CoreData
import UICircularProgressRing

class RTCounterViewController: UIViewController {

    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet weak var myImageView: UIImageView!
    @IBOutlet weak var myTitalLabel: UILabel!
    @IBOutlet weak var myTimerLabel: UILabel!
    @IBOutlet weak var progressView: UICircularProgressRing!{
        didSet {
            progressLabelInit()
        }
    }
    
    func progressLabelInit() {
        progressView.fullCircle = false
        progressView.startAngle = 135
        progressView.endAngle = 45
        progressView.style = .inside
        progressView.minValue = 0
        progressView.valueKnobStyle = .default
        progressView.shouldShowValueText = false
        
        progressView.valueFormatter = UICircularProgressRingFormatter(valueIndicator: SubFunctions.shared.intToStringForTimeFormatter(input: 60), rightToLeft: false, showFloatingPoint: false, decimalPlaces: 1)
        
        progressView.gradientOptions = UICircularRingGradientOptions(startPosition: .left, endPosition: .right, colors: [.green, .yellow, .orange], colorLocations: [0, 0.4, 0.9])
        
        progressView.animationTimingFunction = .linear
        progressView.value = 0  /// Good at visual, starts from there
    }
    
    var catchTableName = ""
    var data: [TableData] = []
    var showDataBreath: [String] = []
    var showDataHold: [String] = []
    var caculateDataBreath: [Int] = []
    var caculateDataHold: [Int] = []
    var progressCounterBreath = 0
    var progressCounterHold = 0
    var progressCounter = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myTableView.delegate = self
        myTableView.dataSource = self
        
        view.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "091EternalConstance"))
        myTableView.backgroundColor = UIColor.clear
        myImageView.image = UIImage(named: "wallclock")
        self.myTitalLabel.text = self.catchTableName
        
        progressView.delegate = self
        
        fetchCoreData()
        caculateTimeProgress(data: data)
        
    }
    
    @IBAction func startTimerBtnPRessed(_ sender: Any) {
        progressView.resetProgress()
        progressLabelInit()
        progressView.maxValue = CGFloat(caculateDataBreath[0])
        progressView.startProgress(to: CGFloat(caculateDataBreath[0]), duration: TimeInterval(caculateDataBreath[0]))
        NotificationCenter.default.addObserver(self, selector: #selector(continueTimeProgress), name: .finishProgress, object: nil)
//        let celllabel = myTableView.dequeueReusableCell(withIdentifier: "cell") as! RTCellTableViewCell
//        celllabel.breathtime.backgroundColor = .yellow
        progressCounterBreath += 1
        progressCounter += 1
    }
    
    @objc func continueTimeProgress() {
        let celllabel = myTableView.dequeueReusableCell(withIdentifier: "cell") as! RTCellTableViewCell
        celllabel.breathtime.backgroundColor = UIColor.clear
        celllabel.holdtime.backgroundColor = UIColor.clear
        
        if progressCounter < ( caculateDataBreath.count * 2) {
            progressView.resetProgress()
            print("progressCounter: \(progressCounter)")
            if progressCounter % 2 == 0 {
                //呼吸端
                progressView.resetProgress()
//                progressView.minValue = 0
//                progressView.value = 0
                progressLabelInit()
                progressView.maxValue = CGFloat(caculateDataBreath[progressCounterBreath])
                progressView.startProgress(to: CGFloat(caculateDataBreath[progressCounterBreath]), duration: TimeInterval(caculateDataBreath[progressCounterBreath]))
//                celllabel.breathtime.backgroundColor = .yellow
                print("progressCounterBreath: \(progressCounterBreath)")
                progressCounterBreath += 1
            } else {
                //憋氣端
                progressView.resetProgress()
//                progressView.minValue = 0
//                progressView.value = 0
                progressLabelInit()
                progressView.maxValue = CGFloat(caculateDataHold[progressCounterHold])
                progressView.startProgress(to: CGFloat(caculateDataHold[progressCounterHold]), duration: TimeInterval(caculateDataHold[progressCounterHold]))
//                celllabel.holdtime.backgroundColor = .yellow
                print("progressCounterHold: \(progressCounterHold)")
                progressCounterHold += 1
            }
            progressCounter += 1
        } else {
            progressCounterBreath = 0
            progressCounterHold = 0
            progressCounter = 0
            progressView.resetProgress()
            celllabel.breathtime.backgroundColor = UIColor.clear
            celllabel.holdtime.backgroundColor = UIColor.clear
        }
        
    }
    
    
    func tranceferToTimeFormatterWithString(interval: Int) -> String {
        let min = interval / 60 % 60
        let sec = interval % 60
        return String(format: "%02i:%02i", min, sec)
    }
    
    func fetchCoreData() {
        let moc = CoreDataHelper.shared.managedObjectContext()
        let fetchRequest = NSFetchRequest<TableData>(entityName: "TableData")
        fetchRequest.predicate = NSPredicate(format: "tableName contains[cd] %@", self.catchTableName)

        moc.performAndWait {
            do {
                self.data = try moc.fetch(fetchRequest)
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
            self.caculateDataBreath.append(interval)
            self.caculateDataHold.append(totalHoldTime)
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
extension RTCounterViewController: UITableViewDelegate {
    
}

extension RTCounterViewController: UITableViewDataSource {
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

extension RTCounterViewController: UICircularProgressRingDelegate {
    func didFinishProgress(for ring: UICircularProgressRing) {
//        self.progressView.resetProgress()
        
        NotificationCenter.default.post(name: .finishProgress, object: nil)
    }
    
    func didPauseProgress(for ring: UICircularProgressRing) {
        
    }
    
    func didContinueProgress(for ring: UICircularProgressRing) {
        
    }
    
    func didUpdateProgressValue(for ring: UICircularProgressRing, to newValue: CGFloat) {
        self.myTimerLabel.text = String(format: "%02i:%02i", Int(newValue)/60 % 60 ,Int(newValue) % 60)
    }
    
    func willDisplayLabel(for ring: UICircularProgressRing, _ label: UILabel) {

    }
    
}

