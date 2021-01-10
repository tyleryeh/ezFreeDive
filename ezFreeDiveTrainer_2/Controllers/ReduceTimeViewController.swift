//
//  TimeTimeViewController.swift
//  ezFreeDiveTrainer_2
//
//  Created by Che Chang Yeh on 2020/12/24.
//

import UIKit
import CoreData

class ReduceTimeViewController: UIViewController {

    @IBOutlet weak var myTableView: UITableView!
    //接資料
    var data: [TableData] = []
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        myTableView.delegate = self
        myTableView.dataSource = self
        self.view.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "091EternalConstance"))
        self.myTableView.backgroundColor = UIColor.clear
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super .viewDidAppear(animated)
        fetchCoreData()
        self.myTableView.reloadData()
    }
    
    func fetchCoreData() {
        let moc = CoreDataHelper.shared.managedObjectContext()
        let fetchRequest = NSFetchRequest<TableData>(entityName: "TableData")
        fetchRequest.predicate = NSPredicate(format: "whitchTable contains[cd] %@", "RT")
        let order = NSSortDescriptor(key: "saveDate", ascending: true)
        fetchRequest.sortDescriptors = [order]
        moc.performAndWait {
            do {
                self.data = try moc.fetch(fetchRequest)
            }catch {
                self.data = []
            }
        }
    }
    
    @IBAction func addBtnPressed(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(identifier: "RTSetVC") as! RTSetViewController
        show(vc, sender: nil)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "timerCountSegue" {
            if let indexPath = self.myTableView.indexPathForSelectedRow {
                guard let segueForLabelName = self.data[indexPath.row].tableName else {return}
                let vc = segue.destination as! RTCounterViewController
                vc.catchTableName = segueForLabelName
            }
        }
    }
    
}

extension ReduceTimeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension ReduceTimeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
//
////        cell.textLabel?.text = "666"
//        cell.textLabel?.text = self.data[indexPath.row].tableName
//        cell.detailTextLabel?.text = self.data[indexPath.row].saveDate
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ReduceTimeCellTableViewCell
        
//        cell.textLabel?.text = self.data[indexPath.row].tableName
//        cell.detailTextLabel?.text = self.data[indexPath.row].saveDate
        
        cell.myLabel.text = self.data[indexPath.row].tableName
//        cell.myImage.image = UIImage(named: "salutation")
//        cell.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "077ColdEvening"))
        return cell
        
    }
    
    
}
