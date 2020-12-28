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
    var showData:[String] = []
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        myTableView.delegate = self
        myTableView.dataSource = self

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
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "setVCSegue" {
//            let setVC = segue.destination as! RTSetViewController
//            setVC.delegate = self
//            setVC.currentData =
//        }
//    }
    

}

extension ReduceTimeViewController: UITableViewDelegate {
    
}

extension ReduceTimeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
//        cell.textLabel?.text = "666"
        cell.textLabel?.text = self.data[indexPath.row].tableName
        cell.detailTextLabel?.text = self.data[indexPath.row].saveDate
        
        return cell
        
    }
    
    
}
