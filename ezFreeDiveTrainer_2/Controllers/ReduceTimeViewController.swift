//
//  TimeTimeViewController.swift
//  ezFreeDiveTrainer_2
//
//  Created by Che Chang Yeh on 2020/12/24.
//

import UIKit

class ReduceTimeViewController: UIViewController {

    @IBOutlet weak var myTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        myTableView.delegate = self
        myTableView.dataSource = self
    }
    
    @IBAction func addBtnPressed(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(identifier: "RTSetVC") as! RTSetViewController
        show(vc, sender: nil)
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

extension ReduceTimeViewController: UITableViewDelegate {
    
}

extension ReduceTimeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = "666"
        
        return cell
        
    }
    
    
}
