//
//  WeatherViewController.swift
//  ezFreeDiveTrainer_2
//
//  Created by Che Chang Yeh on 2021/1/5.
//

import UIKit

protocol WeatherViewControllerDelegate: class {
    func didUpdateWeatherInfo(updateWeatherInfo: [String])
}

class WeatherViewController: UIViewController, UISearchResultsUpdating {

    @IBOutlet weak var myTableView: UITableView!
    
    var mySearchBarController: UISearchController!
    var mydata = [WeatherData]()
    var filteredArray = [WeatherData]()
    var myRequestWeatherData = [Weather]()
    
    weak var delegate: WeatherViewControllerDelegate?
    
    let jsDecoder = JSONDecoder()
    let weaherRequest = "https://opendata.cwb.gov.tw/api/v1/rest/datastore/O-A0003-001?Authorization=CWB-F1E68D0A-07E8-4D9B-9379-AF7811E39746"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        weatherRequestLocation()
        
//        let vc = storyboard?.instantiateViewController(identifier: "diaryNoteVC") as! DiaryNoteSetViewController
        
        //Searchbar
        self.mySearchBarController = UISearchController(searchResultsController: nil)
        self.navigationItem.titleView = self.mySearchBarController.searchBar
        
        self.mySearchBarController.searchBar.placeholder = "台中市...eg"
        self.mySearchBarController.searchBar.sizeToFit()
        self.mySearchBarController.searchResultsUpdater = self
        self.mySearchBarController.searchBar.delegate = self
//        self.mySearchBarController.searchBar.showsCancelButton = true
        self.mySearchBarController.obscuresBackgroundDuringPresentation = false
        self.mySearchBarController.hidesNavigationBarDuringPresentation = false
        definesPresentationContext = true //searchbar記憶體配置不會因為換view而改變
        
        self.myTableView.delegate = self
        self.myTableView.dataSource = self
//        self.myTableView.tableHeaderView = self.mySearchBarController.searchBar
    }
    
    func updateSearchResults(for searchController: UISearchController) {
//        mySearchBarController.isActive = true
        if let searchText = searchController.searchBar.text {
            filterContent(for: searchText)
            print("mySearchBarController.isActive: \(mySearchBarController.isActive)")
            self.myTableView.reloadData()
        }
    }
    
    func filterContent(for searchText: String) {
        let text = searchText.replacingOccurrences(of: "台", with: "臺")
        self.filteredArray = self.mydata.filter({ (filterdata) -> Bool in
            if let location = filterdata.location {
                let isMatch = location.localizedCaseInsensitiveContains(text)
                return isMatch
            }
            return false
        })
    }
    
    func weatherRequestLocation(){
        //查詢
        var request = URLRequest(url: URL(string: weaherRequest)!)
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print(String(describing: error))
                return
            }
            do {
                let res = try self.jsDecoder.decode(Weather.self, from: data)
                //問題怎麼把res存出來
                self.myRequestWeatherData = [res]
//                print("\(self.myWeather)")
                //測試看看
//                print("\(res.result.results[0].A_Name_Ch)")
//                print("\(res.result.results[0].動物醫院名稱)")
//                print("\(res.result.results[0].Hname)")

                //看看count對不對
                let countnum = self.myRequestWeatherData[0].records.location.count
//                print("\(countnum)")
//                print("\(self.myHospital[0].result.results[0].addr)")
//                印出來看看
                for i in 0..<countnum {
                    let adddata = WeatherData()
                    print("\(i)")
                    
                    adddata.location = "\(self.myRequestWeatherData[0].records.location[i].parameter[0].parameterValue), \(self.myRequestWeatherData[0].records.location[i].parameter[2].parameterValue)"
                    adddata.weater = "\(self.myRequestWeatherData[0].records.location[i].weatherElement[20].elementValue)"
                    adddata.minTempture = "\(self.myRequestWeatherData[0].records.location[i].weatherElement[16].elementValue)"
                    adddata.maxTempture = "\(self.myRequestWeatherData[0].records.location[i].weatherElement[14].elementValue)"
                    
                    self.mydata.append(adddata)
                    
                    print("\(self.myRequestWeatherData[0].records.location[i].parameter[0].parameterValue), \(self.myRequestWeatherData[0].records.location[i].parameter[2].parameterValue), \(self.myRequestWeatherData[0].records.location[i].weatherElement[20].elementValue), \(self.myRequestWeatherData[0].records.location[i].weatherElement[16].elementValue), \(self.myRequestWeatherData[0].records.location[i].weatherElement[14].elementValue)")
                }
                
                //要丟東西到View寫這裡
                DispatchQueue.main.async {
//                    self.tableView.reloadData()
                    self.myTableView.reloadData()
                }
            } catch {
                print("jsDecoder Fail\(error)")
            }
        }
        task.resume()

    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func didSelectedData(data: WeatherData) -> [String]?{
        guard let location = data.location,
              let weather = data.weater,
              let maxT = data.maxTempture,
              let minT = data.minTempture else {
            return nil
        }
        var stringArray = [String]()
        stringArray.append(location)
        stringArray.append(weather)
        stringArray.append(maxT)
        stringArray.append(minT)
        
        return stringArray
    }

}

extension WeatherViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
//        let vc = storyboard?.instantiateViewController(identifier: "diaryNoteVC") as! DiaryNoteSetViewController
        
        if mySearchBarController.isActive {
            guard let resultData = didSelectedData(data: filteredArray[indexPath.row]) else {return}
            print("\(resultData[0]), \(resultData[1]), \(resultData[2]), \(resultData[3])")
            self.delegate?.didUpdateWeatherInfo(updateWeatherInfo: resultData)
            navigationController?.popViewController(animated: true)
        } else {
            guard let resultData = didSelectedData(data: mydata[indexPath.row]) else {return}
            print("\(resultData[0]), \(resultData[1]), \(resultData[2]), \(resultData[3])")
            self.delegate?.didUpdateWeatherInfo(updateWeatherInfo: resultData)
            navigationController?.popViewController(animated: true)
        }
    }
}
extension WeatherViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if mySearchBarController.isActive {
            return self.filteredArray.count
        } else {
            return self.mydata.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let resultArray = (mySearchBarController.isActive) ? self.filteredArray[indexPath.row] : self.mydata[indexPath.row]
        guard let location = resultArray.location,
              let weather = resultArray.weater,
              let maxT = resultArray.maxTempture,
              let minT = resultArray.minTempture else {
            return cell
        }
        cell.textLabel?.text = "\(location), \(weather), \(maxT), \(minT)"
        
        return cell
        
    }
}
extension WeatherViewController: UISearchBarDelegate {
    // 當在searchBar上開始輸入文字時
//    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
//        <#code#>
//    }
        
    // 點擊searchBar上的取消按鈕
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        // 依個人需求決定如何實作
        // ...
    }
    
    // 點擊searchBar的搜尋按鈕時
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // 法蘭克選擇不需要執行查詢的動作，因在「輸入文字時」即會觸發updateSearchResults的delegate做查詢的動作(可依個人需求決定如何實作)
        // 關閉瑩幕小鍵盤
//        self.searchController.searchBar.resignFirstResponder()
    }
}

