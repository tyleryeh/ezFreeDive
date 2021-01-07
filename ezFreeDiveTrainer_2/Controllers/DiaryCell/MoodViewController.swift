//
//  MoodViewController.swift
//  ezFreeDiveTrainer_2
//
//  Created by Che Chang Yeh on 2021/1/6.
//

import UIKit

protocol MoodViewControllerDelegate: class {
    func didUpdateMoodEmoji(emojiString: String)
}

class MoodViewController: UIViewController {

    @IBOutlet weak var myCollectionView: UICollectionView!
    @IBOutlet weak var myCollectionLayOut: UICollectionViewFlowLayout!
    
    var moodItems = ["cheeky", "crazy", "shock", "smug", "swearing"]
    weak var delegate: MoodViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        myCollectionView.delegate = self
        myCollectionView.dataSource = self
        
        myCollectionLayOut.minimumInteritemSpacing = 1
        myCollectionLayOut.scrollDirection = .horizontal
        
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
extension MoodViewController: UICollectionViewDelegate {
    
}

extension MoodViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return moodItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MoodViewCollectionViewCell
        
        cell.myBtn.layer.cornerRadius = cell.myBtn.frame.height / 2
        cell.myBtn.layer.masksToBounds = true
        cell.myBtn.backgroundColor = UIColor.clear
        
        cell.myBtn.setImage(UIImage(named: moodItems[indexPath.row]), for: .normal)
        
        if indexPath.row == 0 {
            cell.myBtn.addTarget(self, action: #selector(cheeky), for: .touchUpInside)
        } else if indexPath.row == 1 {
            cell.myBtn.addTarget(self, action: #selector(crazy), for: .touchUpInside)
        } else if indexPath.row == 2 {
            cell.myBtn.addTarget(self, action: #selector(shock), for: .touchUpInside)
        } else if indexPath.row == 3 {
            cell.myBtn.addTarget(self, action: #selector(smug), for: .touchUpInside)
        } else {
            cell.myBtn.addTarget(self, action: #selector(swearing), for: .touchUpInside)
        }
        
        
        return cell
    }
    
    //var moodItems = ["cheeky", "crazy", "shock", "smug", "swearing"]
    @objc func cheeky() {
        print("cheeky")
        self.delegate?.didUpdateMoodEmoji(emojiString: "cheeky")
        self.dismiss(animated: true)
    }
    @objc func crazy() {
        print("crazy")
        self.delegate?.didUpdateMoodEmoji(emojiString: "crazy")
        self.dismiss(animated: true)
    }
    @objc func shock() {
        print("shock")
        self.delegate?.didUpdateMoodEmoji(emojiString: "shock")
        self.dismiss(animated: true)
    }
    @objc func smug() {
        print("smug")
        self.delegate?.didUpdateMoodEmoji(emojiString: "smug")
        self.dismiss(animated: true)
    }
    @objc func swearing() {
        print("swearing")
        self.delegate?.didUpdateMoodEmoji(emojiString: "swearing")
        self.dismiss(animated: true)
    }

    
    
}
