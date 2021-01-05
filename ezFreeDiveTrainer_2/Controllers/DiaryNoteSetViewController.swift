//
//  DiarySetViewController.swift
//  ezFreeDiveTrainer_2
//
//  Created by Che Chang Yeh on 2021/1/4.
//

import UIKit

class DiaryNoteSetViewController: UIViewController {
    
    @IBOutlet weak var myCollectionView: UICollectionView!
    @IBOutlet weak var myCollectionVIewLayout: UICollectionViewFlowLayout!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myCollectionView.delegate = self
        myCollectionView.dataSource = self
        
        myCollectionVIewLayout.minimumInteritemSpacing = 1
        myCollectionVIewLayout.scrollDirection = .horizontal
        
        self.view.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "091EternalConstance"))
        myCollectionView.backgroundColor = UIColor.clear
        
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
            cell.myBtn.addTarget(self, action: #selector(divingBtn), for: .touchUpInside)
        } else if indexPath.row == 2 {
            cell.myBtn.setImage(UIImage(named: "cheeky"), for: .normal)
            cell.myBtn.addTarget(self, action: #selector(cheekyBtn), for: .touchUpInside)
        } else if indexPath.row == 3{
            cell.myBtn.setImage(UIImage(named: "placeholder"), for: .normal)
            cell.myBtn.addTarget(self, action: #selector(placeholderBtn), for: .touchUpInside)
        } else {
            cell.myBtn.setImage(UIImage(named: "cloudy"), for: .normal)
            cell.myBtn.addTarget(self, action: #selector(cloudyBtn), for: .touchUpInside)
        }
        
        return cell
    }
    
    @objc func cameraBtn() {
        print("cameraBtn")
    }
    @objc func divingBtn() {
        print("divingBtn")
    }
    @objc func cheekyBtn() {
        print("cheekyBtn")
    }
    @objc func placeholderBtn() {
        print("placeholderBtn")
    }
    @objc func sharkBtn() {
        print("sharkBtn")
    }
    @objc func cloudyBtn() {
        print("cloudyBtn")
    }
    
    
}
