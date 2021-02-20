//
//  DiarySetViewController.swift
//  ezFreeDiveTrainer_2
//
//  Created by Che Chang Yeh on 2021/1/4.
//

import UIKit
import SCLAlertView

class DiaryNoteSetViewController: UIViewController {
    
    @IBOutlet weak var myCollectionView: UICollectionView!
    @IBOutlet weak var myCollectionVIewLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var myInfoLabelForThings: UILabel!
    @IBOutlet weak var myInfoLabelForDiveSite: UILabel!
    @IBOutlet weak var diaryNameTextField: UITextField!
    @IBOutlet weak var myTextView: UITextView!
    @IBOutlet var myshadowView: UIView!
    @IBOutlet var myInnerView: UIView!
    
    var location = ""
    var moodemoji = ""
    var weather = ""
    var tempMax = ""
    var tempMin = ""
    var weatherInfo = [String]()

    var mapDiveSiteData = [MapData]()
    var equipData: EquipData?
    
    var uuidString = ""
    var diaryData: [Diary]?
    let formatterr: DateFormatter = {
       let foramtter = DateFormatter()
        foramtter.timeStyle = .medium
        foramtter.dateStyle = .medium
        return foramtter
    }()
    
    var screenSize:CGRect?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myshadowView.layer.shadowColor = UIColor.darkGray.cgColor
        myshadowView.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        myshadowView.layer.shadowOpacity = 0.5
        myshadowView.layer.shadowRadius = 2
        myshadowView.layer.cornerRadius = 30
        myshadowView.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "077ColdEvening"))
        
        myInnerView.backgroundColor = UIColor.clear
        myTextView.backgroundColor = UIColor.clear
        myTextView.text = "Have a nice dive 🐋"
        myTextView.delegate = self
        addDoneButtonOnKeyboard_textView(textView: myTextView)
        
        screenSize = UIScreen.main.bounds
        
        myCollectionView.delegate = self
        myCollectionView.dataSource = self
        
        diaryNameTextField.delegate = self
        
        myCollectionVIewLayout.minimumInteritemSpacing = 1
        myCollectionVIewLayout.scrollDirection = .horizontal
        
        
        self.view.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "091EternalConstance"))
        myCollectionView.backgroundColor = UIColor.clear
        self.diaryData = SubFunctions.shared.fetchDiaryDataUUID(uuid: uuidString)
        reloadData(diaryData: self.diaryData)
        
    }
    
    //需要再更新，改成用不要用MapData or equdata or string 的資料格式傳輸
    //用CoreData的格式傳
    func reloadDataCoreData(diaryData: [Diary]?) {
        guard let count = diaryData?.count else {return}
        if count != 0 {
            //更新things
            guard let array = diaryData else {return}
            SubFunctions.shared.updateLabelForThings(label: myInfoLabelForThings, location: array[0].placeName ?? "", weather: array[0].placeWeatherName ?? "", temMax: array[0].placeTempMax ?? "", temMin: array[0].placeWeatherName ?? "", moodemoji: array[0].moodName ?? "")
            
            //更新diveSuit
            //需要再更新，改成用不要用MapData的資料格式傳輸
            //用CoreData的格式傳
            guard let mapLocation = array[0].toLocation?.allObjects as? [Location] else {return}
            if mapLocation.count != 0 {
                for i in 0..<mapLocation.count {
                    let mapData = MapData()
                    mapData.diveSiteName = mapLocation[i].name
                    mapData.diveSiteLat = mapLocation[i].lat
                    mapData.diveSiteLon = mapLocation[i].lon
                    mapDiveSiteData.append(mapData)
                }
                showDiveSuit(data: mapDiveSiteData)
            } else {
                print("No mapData")
            }
            //更新裝備
            
        } else {
            print("No data!")
        }
    
    }
    
    func reloadData(diaryData: [Diary]?) {
        if let count = diaryData?.count {
            //fetch 有沒有資料
            if count != 0 { //有資料
                guard let array = diaryData else {return}
                diaryNameTextField.text = array[0].diaryName
                myTextView.text = array[0].diaryTextView
                self.title = array[0].diaryDate
                
                moodemoji = array[0].moodName ?? ""
                location = array[0].placeName ?? ""
                tempMax =  array[0].placeTempMax ?? ""
                tempMin = array[0].placeTempMin ?? ""
                weather = array[0].placeWeatherName ?? ""
                
                let eData = EquipData()
                eData.mySuitText = array[0].eSuit!
                eData.myMaskText = array[0].eMask!
                eData.myFinsText = array[0].eFins!
                eData.myWeightText = array[0].eWeight!
                eData.circleVisibilityText = array[0].eVisibility!
                eData.circleMaxDepthText = array[0].eMaxDepth!
                eData.myDiveTimeText = array[0].eDiveTime!
                eData.myTempText = array[0].eWaterTemp!
                equipData = eData
                
                SubFunctions.shared.updateLabelForThings(label: myInfoLabelForThings, location: location, weather: weather, temMax: tempMax, temMin: tempMin, moodemoji: moodemoji)
                
                if let maplocation = array[0].toLocation?.allObjects as? [Location] {
                    if maplocation.count != 0 {
                        for i in 0..<maplocation.count {
                            let mapData = MapData()
                            mapData.diveSiteName = maplocation[i].name
                            mapData.diveSiteLat = maplocation[i].lat
                            mapData.diveSiteLon = maplocation[i].lon
                            mapDiveSiteData.append(mapData)
                        }
                    }
                    showDiveSuit(data: mapDiveSiteData)
                } else {
                    
                }
            } else { //沒資料
                print("No data")
            }
        }
    }
    
    
    @IBAction func doneBtnPressed(_ sender: Any) {
        //Save data to CoreData!
        let moc = CoreDataHelper.shared.managedObjectContext()
        guard let dataArray = self.diaryData else {return}
        
        //MARK: 處理潛水地點
        //處理潛水地點
        //刪除之前所有地點
        guard var array = dataArray[0].toLocation?.allObjects as? [Location] else {return}
        if array.count != 0 {
            for _ in 0..<array.count {
                let a = array.remove(at: 0)
                moc.performAndWait {
                    moc.delete(a)
                }
                CoreDataHelper.shared.saveContext()
            }
        }
        //儲存更新後的潛水地點
        //mapping資料給 dataArray
        for i in 0..<mapDiveSiteData.count {
            let newMapData = Location(context: moc)
            newMapData.name = mapDiveSiteData[i].diveSiteName
            newMapData.lat = mapDiveSiteData[i].diveSiteLat
            newMapData.lon = mapDiveSiteData[i].diveSiteLon
            dataArray[0].addToToLocation(newMapData)
        }
        
        //MARK: 處理日記名稱，內容，時間
        dataArray[0].diaryName = diaryNameTextField.text
        dataArray[0].diaryTextView = myTextView.text
        dataArray[0].diaryDate = self.title! //格式要改排序
        dataArray[0].saveDate = formatterr.string(from: Date())
        
        //MARK: 檢查裝備有沒有輸入完成
        if equipData != nil {
            //儲存
            CoreDataHelper.shared.saveContext()
            navigationController?.popViewController(animated: true)
        } else {
            let appearance = SCLAlertView.SCLAppearance(
                kCircleIconHeight: 30,
                kTitleFont: UIFont(name: "Chalkboard SE Regular", size: 22)!,
                kTextFont: UIFont(name: "Chalkboard SE Regular", size: 12)!,
                kButtonFont: UIFont(name: "Chalkboard SE Regular", size: 14)!,
                contentViewCornerRadius: 20
            )
            
            let alertView = SCLAlertView(appearance: appearance)
            alertView.view.backgroundColor = UIColor.clear
            alertView.addButton("Go to equipment settings.") {
                let vc = self.storyboard?.instantiateViewController(identifier: "equipVC") as! EquipViewController
                self.show(vc, sender: nil)
            }
            alertView.showNotice("You missed something~", subTitle: "🌟",closeButtonTitle: "Ok", circleIconImage: #imageLiteral(resourceName: "wave"))
        }
  
        
    }
    
    func showDiveSuit(data: [MapData]) {
        let showALLFriendsContent = NSMutableAttributedString()
        if data.count == 0 {
            showALLFriendsContent.append(NSAttributedString(string: ""))
            myInfoLabelForDiveSite.attributedText = showALLFriendsContent
        }
        for i in 0..<data.count {
            guard let name = data[i].diveSiteName else {return}
            if i == data.count - 1 {
                updateLabelForDiveSite(label: myInfoLabelForDiveSite, diveSiteName: name, isLastOne: true, content: showALLFriendsContent)
            } else {
                updateLabelForDiveSite(label: myInfoLabelForDiveSite, diveSiteName: name, isLastOne: false, content: showALLFriendsContent)
            }
        }
    }
    
    func updateLabelForDiveSite(label: UILabel, diveSiteName: String, isLastOne: Bool, content:  NSMutableAttributedString) {
        
        let siteImage = NSTextAttachment()
        siteImage.image = #imageLiteral(resourceName: "buoy")
        siteImage.bounds = CGRect(x: 0, y: -4.5, width: 20, height: 20)
        content.append(NSAttributedString(attachment: siteImage))
        
        if isLastOne == false {
            //我不是最後一個
            content.append(NSAttributedString(string: " • \(diveSiteName) "))
        } else {
            //我是最後一個
            content.append(NSAttributedString(string: " • \(diveSiteName)"))
        }
        
        label.attributedText = content
    }
    
    func addDoneButtonOnKeyboard_textView(textView: UITextView) {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        doneToolbar.barStyle = UIBarStyle.default
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem  = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(textViewResignFirst))
        
        var items = [UIBarButtonItem]()
        items.append(flexSpace)
        items.append(done)
        
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        textView.inputAccessoryView = doneToolbar
    }
    @objc func textViewResignFirst() {
        textViewResign(textView: self.myTextView)
    }
    func textViewResign(textView: UITextView) {
        textView.resignFirstResponder()
    }
    
    // MARK: - Navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "diveSiteSegue" {
//            let diveSiteVC = segue.destination as! MapViewController
//            diveSiteVC.delegateData = mapDiveSiteData
//        }
//    }
 

}
extension DiaryNoteSetViewController: UITextFieldDelegate{
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let arry = self.diaryData else {return}
        arry[0].diaryName = textField.text
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension DiaryNoteSetViewController: UICollectionViewDelegate {
    
}
extension DiaryNoteSetViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! DiaryMyCollectionViewCell
        
        cell.myBtn.layer.cornerRadius = cell.myBtn.frame.height / 2
        cell.myBtn.layer.masksToBounds = true
        cell.myBtn.backgroundColor = UIColor.clear
        
        if indexPath.row == 0 {
            cell.myBtn.setImage(UIImage(named: "camera"), for: .normal)
            cell.myBtn.addTarget(self, action: #selector(cameraBtn), for: .touchUpInside)
        } else if indexPath.row == 1 {
            cell.myBtn.setImage(UIImage(named: "diving"), for: .normal)
            cell.myBtn.addTarget(self, action: #selector(divingBtn(_:)), for: .touchUpInside)
        } else if indexPath.row == 2 {
            cell.myBtn.setImage(UIImage(named: "cheeky"), for: .normal)
            cell.myBtn.addTarget(self, action: #selector(moodBtn(_:)), for: .touchUpInside)
        } else if indexPath.row == 3{
            cell.myBtn.setImage(UIImage(named: "placeholder"), for: .normal)
            cell.myBtn.addTarget(self, action: #selector(loactionBtn), for: .touchUpInside)
        } else {
            cell.myBtn.setImage(UIImage(named: "cloudy"), for: .normal)
            cell.myBtn.addTarget(self, action: #selector(weatherBtn), for: .touchUpInside)
        }
        
        return cell
    }
    //相機
    @objc func cameraBtn() {
        print("cameraBtn")
    }
    //裝備
    @objc func divingBtn(_ sender: Any) {
        print("divingBtn")
        let equipVC = storyboard?.instantiateViewController(identifier: "equipVC") as! EquipViewController
        equipVC.delegate = self
        equipVC.transDataForEquip = equipData
        show(equipVC, sender: nil)
    }
    //心情
    @objc func moodBtn(_ sender: Any) {
        print("cheekyBtn")
        let button = sender as? UIButton
        let buttonFrame = button?.frame ?? CGRect.zero
        
        let popoverViewSize = CGSize(width: 320, height: 100)
        let popoverContentController = self.storyboard?.instantiateViewController(withIdentifier: "MoodVC") as? MoodViewController
        //設定彈出來多少
        popoverContentController?.preferredContentSize = popoverViewSize
        popoverContentController?.modalPresentationStyle = .popover
        
        if let popoverPresentationController = popoverContentController?.popoverPresentationController {
            popoverPresentationController.permittedArrowDirections = .up
            popoverPresentationController.sourceView = sender as? UIView
            popoverPresentationController.sourceRect = buttonFrame
            popoverPresentationController.delegate = self
            
            if let popoverController = popoverContentController {
                //MARK: moodDelegate
                popoverController.delegate = self
                present(popoverController, animated: true, completion: nil)
            }
        }
    }
    //定位
    @objc func loactionBtn() {
        print("placeholderBtn")
        let mapVC = storyboard?.instantiateViewController(identifier: "mapVC") as! MapViewController
        mapVC.delegate = self
        mapVC.delegateData = mapDiveSiteData
        show(mapVC, sender: nil)
    }
    //天氣
    @objc func weatherBtn() {
        print("cloudyBtn")
        let weatherVC = storyboard?.instantiateViewController(identifier: "weatherVC") as! WeatherViewController
        weatherVC.delegate = self
        show(weatherVC, sender: nil)
    }
    
    
}
//MARK: UIPopoverPresentationControllerDelegate
extension DiaryNoteSetViewController: UIPopoverPresentationControllerDelegate{
    //UIPopoverPresentationControllerDelegate inherits from UIAdaptivePresentationControllerDelegate, we will use this method to define the presentation style for popover presentation controller
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    //UIPopoverPresentationControllerDelegate
    func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
        
    }
    
    func popoverPresentationControllerShouldDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) -> Bool {
        return true
    }
}

//MARK: MoodViewControllerDelegate
extension DiaryNoteSetViewController: MoodViewControllerDelegate, WeatherViewControllerDelegate, MapViewControllerDelegate, EquipViewControllerDelegate {
    
    //裝備更新
    func didFinishUpdateEquip(update data: EquipData) {
        equipData = data
        if let eData = equipData {
            if let array = self.diaryData {
                array[0].eSuit = eData.mySuitText
                array[0].eMask = eData.myMaskText
                array[0].eFins = eData.myFinsText
                array[0].eWeight = eData.myWeightText
                array[0].eMaxDepth = eData.circleMaxDepthText
                array[0].eVisibility = eData.circleVisibilityText
                array[0].eDiveTime = eData.myDiveTimeText
                array[0].eWaterTemp = eData.myTempText
            } else {
                print("No diaryData for equ")
            }
            
        } else {
            print("No equData")
        }
    }
    
    //天氣更新
    func didUpdateWeatherInfo(updateWeatherInfo: [String]) {
        //hard code....
        location = updateWeatherInfo[0]
        weather = updateWeatherInfo[1]
        tempMax = updateWeatherInfo[2]
        tempMin = updateWeatherInfo[3]
        SubFunctions.shared.updateLabelForThings(label: myInfoLabelForThings, location: location, weather: weather, temMax: tempMax, temMin: tempMin, moodemoji: moodemoji)
        if let array = self.diaryData {
            array[0].placeName = location
            array[0].placeTempMax = tempMax
            array[0].placeTempMin = tempMin
            array[0].placeWeatherName = weather
        } else {
            print("No diaryData for weather")
        }
    }
    //心情更新
    func didUpdateMoodEmoji(emojiString: String) {
        moodemoji = emojiString
        SubFunctions.shared.updateLabelForThings(label: myInfoLabelForThings, location: location, weather: weather, temMax: tempMax, temMin: tempMin, moodemoji: moodemoji)
        if let array = self.diaryData {
            array[0].moodName = moodemoji
        } else {
            print("No diaryData for mood")
        }
    }
    //潛水地點更新
    func didUpdateDiveSite(updata data: [MapData]) {
        mapDiveSiteData = data
        showDiveSuit(data: mapDiveSiteData)
        //CoreData 去done那邊存，要更改潛水地點在存
    }
    
}

extension DiaryNoteSetViewController: UITextViewDelegate{
//    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
//        if(text == "\n") {
//            textView.resignFirstResponder()
//            return false
//        }
//        return true
//    }
}
