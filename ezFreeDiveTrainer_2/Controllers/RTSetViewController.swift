//
//  testViewController.swift
//  ezFreeDiveTrainer_2
//
//  Created by Che Chang Yeh on 2020/12/25.
//

import UIKit
import CoreData

class RTSetViewController: UIViewController {

    @IBOutlet weak var setBtn: UIButton!
    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet weak var tableRTName: UITextField!
    @IBOutlet weak var tableBreathTime: UITextField!
    @IBOutlet weak var tableReduceTime: UITextField!
    @IBOutlet weak var tableHoldTime: UITextField!
    @IBOutlet weak var tableSet: UITextField!
    
    //要傳送給前一頁(ReduceTimeViewController)的資料
    var currentData: [TableData] = []
    var data:[TableData] = []
    var showDataBreath:[String] = []
    var showDataHold:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        myTableView.delegate = self
        myTableView.dataSource = self
        
        textPlaceHolderColorSet(textfiled: tableRTName, string: "Table名稱", color: UIColor.gray)
        textPlaceHolderColorSet(textfiled: tableBreathTime, string: "調息時間sec, e.g 90", color: UIColor.gray)
        textPlaceHolderColorSet(textfiled: tableSet, string: "組數, e.g 5", color: UIColor.gray)
        textPlaceHolderColorSet(textfiled: tableHoldTime, string: "閉氣時間sec, e.g 90", color: UIColor.gray)
        textPlaceHolderColorSet(textfiled: tableReduceTime, string: "遞減時間sec, e.g 5", color: UIColor.gray)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
        view.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "091EternalConstance"))
        myTableView.backgroundColor = UIColor.clear
        
        tableBreathTime.backgroundColor = UIColor.clear
        tableReduceTime.backgroundColor = UIColor.clear
        tableHoldTime.backgroundColor = UIColor.clear
        tableSet.backgroundColor = UIColor.clear
        tableRTName.backgroundColor = UIColor.clear
        
//        refreshCoreData()
        
    }
    
    func textPlaceHolderColorSet(textfiled: UITextField, string: String, color: UIColor) {
        let set = NSAttributedString(string: string, attributes: [NSAttributedString.Key.foregroundColor: color])
        textfiled.attributedPlaceholder = set
    }
    
    @objc func hideKeyboard(){
        view.endEditing(true)
    }
    
    func refreshCoreData() {
        let moc = CoreDataHelper.shared.managedObjectContext()
        let fetchRequest = NSFetchRequest<TableData>(entityName: "TableData")
        moc.performAndWait {
            do {
                self.data = try moc.fetch(fetchRequest)
            } catch {
                self.data = []
            }
        }
        if self.data.count != 0 {
            let num = self.data.count
            for _ in 0..<num{
                let obj = self.data.remove(at: 0)
                moc.performAndWait {
                    moc.delete(obj)
                }
                CoreDataHelper.shared.saveContext()
            }
        }

    }
    
    
    @IBAction func setBtnPressed(_ sender: Any) {
        if tableRTName.text != "" &&
            tableBreathTime.text != "" &&
            tableReduceTime.text != "" &&
            tableHoldTime.text != "" &&
            tableSet.text != "" {
            guard let totalBreathTime = Int(tableBreathTime.text!),
                  let reduceTime = Int(tableReduceTime.text!),
                  let holeTime = Int(tableHoldTime.text!) else {
                return
            }
            
            //判斷組數遞減有沒有減過頭
            
            if let setNumber = Int(tableSet.text!) {
                for i in 0..<setNumber {
                    let interval = totalBreathTime - reduceTime * i
                    self.showDataBreath.append(intToStringForTimeFormatter(input: interval))
                    self.showDataHold.append(intToStringForTimeFormatter(input: holeTime))
                    self.myTableView.reloadData()
                }
            }
        } else {
            print("missing information")
            return
        }
 
    }
    
    func intToStringForTimeFormatter(input: Int) -> String{
        let min = input / 60 % 60
        let sec = input % 60
        return String(format: "%02i:%02i", min, sec)
    }
    
    @IBAction func saveBtnPressed(_ sender: Any) {
        if tableRTName.text != "" &&
            tableBreathTime.text != "" &&
            tableReduceTime.text != "" &&
            tableHoldTime.text != "" &&
            tableSet.text != "" {
            let now = DateFormatter.localizedString(from: Date(), dateStyle: .short, timeStyle: .medium)
            //CoreData只存一組就好等下取出來再做運算
            let tdata = TableData(context: CoreDataHelper.shared.managedObjectContext())
            tdata.breath = tableBreathTime.text
            tdata.hold = tableHoldTime.text
            tdata.reduce = tableReduceTime.text
            tdata.tableName = tableRTName.text
            tdata.set = tableSet.text
            tdata.saveDate = now
            tdata.whitchTable = "RT"
            self.data.append(tdata)
            CoreDataHelper.shared.saveContext()
            
        } else {
            print("missing information")
            return
        }
        self.navigationController?.popViewController(animated: true)
        
    }
    @IBAction func cancelBtnPressed(_ sender: Any) {
        if self.showDataHold.count != 0 && self.showDataBreath.count != 0 {
            self.showDataHold.removeAll()
            self.showDataBreath.removeAll()
            self.myTableView.reloadData()
        } else {
            self.myTableView.reloadData()
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

extension RTSetViewController: UITableViewDelegate {
    
}

extension RTSetViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.showDataBreath.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! RTCellTableViewCell
        
        cell.breathtime.text = self.showDataBreath[indexPath.row]
        cell.holdtime.text = self.showDataHold[indexPath.row]
        
        cell.backgroundColor = UIColor.clear
        
        return cell
    }
    
    
}

extension RTSetViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        for textField in self.view.subviews where textField is UITextField {
            textField.resignFirstResponder()
        }
        return true
    }
}
