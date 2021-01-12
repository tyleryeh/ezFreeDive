//
//  EquipViewController.swift
//  ezFreeDiveTrainer_2
//
//  Created by Che Chang Yeh on 2021/1/11.
//

import UIKit
import Lottie
import SCLAlertView

protocol EquipViewControllerDelegate: class {
    func didFinishUpdateEquip(update data: EquipData)
}

class EquipViewController: UIViewController {
    
    @IBOutlet weak var circleMaxDepthTextField: UITextField!
    @IBOutlet weak var myCircleViewTemp: CircleUIView!
    
    @IBOutlet weak var circleVisibilityTextField: UITextField!
    @IBOutlet weak var myCircleViewVisibility: CircleUIView!
    @IBOutlet weak var thermometerLottieView: LottieView!
    @IBOutlet weak var clockLottieView: LottieView!
    
    @IBOutlet var myshadowView: UIView!
    @IBOutlet var myInnerView: UIView!
    
    @IBOutlet var myshadowSecView: UIView!
    @IBOutlet var myInnerSecView: UIView!
    
    @IBOutlet weak var mySuitTextField: UITextField!
    @IBOutlet weak var myMaskTextField: UITextField!
    @IBOutlet weak var myFinsTextField: UITextField!
    @IBOutlet weak var myWeightTextField: UITextField!
    @IBOutlet weak var myTempTextField: UITextField!
    @IBOutlet weak var myDiveTimeTextField: UITextField!
    
    var timer = Timer()
    
    var textfieldTagNumber = 0
    let thermometerAnimationView = AnimationView()
    let clockAnimationView = AnimationView()
    
    weak var delegate: EquipViewControllerDelegate?
    var transDataForEquip: EquipData?
    
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
//        guard let data = transDataForEquip else {
//            return
//        }
//        myCircleViewTemp.addAnimation(interval: 0.5)
//        myCircleViewVisibility.addAnimation(interval: 0.5)
//        self.thermometerAnimationView.play()
//        self.clockAnimationView.play()
        
        if transDataForEquip != nil{
            myCircleViewTemp.addAnimation(interval: 0.5)
            myCircleViewVisibility.addAnimation(interval: 0.5)
            self.thermometerAnimationView.play()
            self.clockAnimationView.play()
        } else {
            
        }
        
//        if data.circleMaxDepthText != nil && data.circleMaxDepthText != ""{
//            myCircleViewTemp.addAnimation(interval: 0.5)
//        } else if data.circleVisibilityText != nil && data.circleVisibilityText != ""{
//            myCircleViewVisibility.addAnimation(interval: 0.5)
//        } else if data.myTempText != nil && data.myTempText != "" {
//            self.thermometerAnimationView.play()
//        } else if data.myDiveTimeText != nil && data.myDiveTimeText != ""{
//            self.clockAnimationView.play()
//        } else {
//            //....do sth?
//        }
//        myCircleViewTemp.addAnimation(interval: 0.5)
//        myCircleViewVisibility.addAnimation(interval: 0.5)
//        self.thermometerAnimationView.play()
//        self.clockAnimationView.play()

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //AnimationViewSetting
        thermometerAnimationView.frame = thermometerLottieView.bounds
        thermometerAnimationView.animation = Animation.named("thermometer")
        thermometerAnimationView.contentMode = .scaleToFill
        thermometerAnimationView.loopMode = .playOnce
        thermometerAnimationView.animationSpeed = 1
        thermometerLottieView.addSubview(thermometerAnimationView)
        thermometerLottieView.backgroundColor = UIColor.clear
        
        clockAnimationView.frame = clockLottieView.bounds
        clockAnimationView.animation = Animation.named("clockLottie")
        clockAnimationView.contentMode = .scaleToFill
        clockAnimationView.loopMode = .playOnce
        clockAnimationView.animationSpeed = 1
        clockLottieView.addSubview(clockAnimationView)
        clockLottieView.backgroundColor = UIColor.clear

        //myshadowView setting
        myshadowView.layer.shadowColor = UIColor.darkGray.cgColor
        myshadowView.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        myshadowView.layer.shadowOpacity = 0.5
        myshadowView.layer.shadowRadius = 2
        myshadowView.layer.cornerRadius = 30
        
        myshadowView.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "077ColdEvening"))
        myInnerView.backgroundColor = UIColor.clear
        
        myshadowSecView.layer.shadowColor = UIColor.darkGray.cgColor
        myshadowSecView.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        myshadowSecView.layer.shadowOpacity = 0.5
        myshadowSecView.layer.shadowRadius = 2
        myshadowSecView.layer.cornerRadius = 30
        
        myshadowSecView.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "077ColdEvening"))
        myInnerSecView.backgroundColor = UIColor.clear
        

        self.view.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "091EternalConstance"))
        
        myCircleViewTemp.backgroundColor = UIColor.clear
        myCircleViewTemp.createCircleShape(color1: "#d4fc79", color2: "#96e6a1", lineWidth: 8.0)
        
        myCircleViewVisibility.backgroundColor = UIColor.clear
        myCircleViewVisibility.createCircleShape(color1: "#fbc2eb", color2: "#a6c1ee", lineWidth: 8.0)
       
        circleMaxDepthTextField.backgroundColor = UIColor.clear
        circleMaxDepthTextField.placeholder = "Tap me"
        circleMaxDepthTextField.textColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
        circleMaxDepthTextField.font = UIFont(name: "Chalkboard SE Regular", size: 26)
        circleMaxDepthTextField.borderStyle = .none
        circleMaxDepthTextField.delegate = self
        circleMaxDepthTextField.tag = 0
        addDoneButtonOnKeyboard(textfiled: circleMaxDepthTextField)
        
        circleVisibilityTextField.backgroundColor = UIColor.clear
        circleVisibilityTextField.placeholder = "Tap me"
        circleVisibilityTextField.textColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
        circleVisibilityTextField.font = UIFont(name: "Chalkboard SE Regular", size: 26)
        circleVisibilityTextField.borderStyle = .none
        circleVisibilityTextField.delegate = self
        circleVisibilityTextField.tag = 1
        addDoneButtonOnKeyboard(textfiled: circleVisibilityTextField)
        
        
        mySuitTextField.backgroundColor = UIColor.clear
        mySuitTextField.textColor = #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)
        mySuitTextField.placeholder = "bestdive...ect"
        mySuitTextField.font = UIFont(name: "Chalkboard SE Regular", size: 14)
        mySuitTextField.delegate = self
        mySuitTextField.tag = 2
        
        myMaskTextField.backgroundColor = UIColor.clear
        myMaskTextField.textColor = #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)
        myMaskTextField.placeholder = "problue...etc"
        myMaskTextField.font = UIFont(name: "Chalkboard SE Regular", size: 14)
        myMaskTextField.delegate = self
        myMaskTextField.tag = 3
        
        myFinsTextField.backgroundColor = UIColor.clear
        myFinsTextField.textColor = #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)
        myFinsTextField.placeholder = "V3...etc"
        myFinsTextField.font = UIFont(name: "Chalkboard SE Regular", size: 14)
        myFinsTextField.delegate = self
        myFinsTextField.tag = 4
        
        myWeightTextField.backgroundColor = UIColor.clear
        myWeightTextField.textColor = #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)
        myWeightTextField.placeholder = "Kg"
        myWeightTextField.font = UIFont(name: "Chalkboard SE Regular", size: 14)
        myWeightTextField.delegate = self
        myWeightTextField.tag = 5
        addDoneButtonOnKeyboard(textfiled: myWeightTextField)
        
        myTempTextField.backgroundColor = UIColor.clear
        myTempTextField.textColor = #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)
        myTempTextField.placeholder = "°C"
        myTempTextField.font = UIFont(name: "Chalkboard SE Regular", size: 14)
        myTempTextField.delegate = self
        myTempTextField.tag = 6
        addDoneButtonOnKeyboard(textfiled: myTempTextField)
        
        myDiveTimeTextField.backgroundColor = UIColor.clear
        myDiveTimeTextField.textColor = #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)
        myDiveTimeTextField.placeholder = "minute"
        myDiveTimeTextField.font = UIFont(name: "Chalkboard SE Regular", size: 14)
        myDiveTimeTextField.delegate = self
        myDiveTimeTextField.tag = 7
        addDoneButtonOnKeyboard(textfiled: myDiveTimeTextField)
        
        reloadData(data: transDataForEquip)

    }
    
    func reloadData(data: EquipData?) {
        guard let data = data else { return }
        mySuitTextField.text = data.mySuitText
        myMaskTextField.text = data.myMaskText
        myFinsTextField.text = data.myFinsText
        myWeightTextField.text = data.myWeightText
        myTempTextField.text = data.myTempText
        myDiveTimeTextField.text = data.myDiveTimeText
        circleMaxDepthTextField.text = data.circleMaxDepthText
        circleVisibilityTextField.text = data.circleVisibilityText
    }
    
    func addDoneButtonOnKeyboard(textfiled: UITextField) {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        doneToolbar.barStyle = UIBarStyle.default
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem  = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(runCircleAnimation))
        
        var items = [UIBarButtonItem]()
        items.append(flexSpace)
        items.append(done)
        
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        textfiled.inputAccessoryView = doneToolbar
    }
    
    @objc func runCircleAnimation() {
        print("\(textfieldTagNumber)")
        switch textfieldTagNumber {
        case 0:
            self.circleMaxDepthTextField.resignFirstResponder()
            myCircleViewTemp.addAnimation(interval: 0.5)
        case 1:
            self.circleVisibilityTextField.resignFirstResponder()
            myCircleViewVisibility.addAnimation(interval: 0.5)
        case 5:
            self.myWeightTextField.resignFirstResponder()
        case 6:
            self.myTempTextField.resignFirstResponder()
            self.thermometerAnimationView.play()
        case 7:
            self.myDiveTimeTextField.resignFirstResponder()
            self.clockAnimationView.play()
        default:
            break
        }
    }

    @IBAction func cancelPressedBtn(_ sender: Any) {
        mySuitTextField.text = ""
        myMaskTextField.text = ""
        myFinsTextField.text = ""
        myWeightTextField.text = ""
        myTempTextField.text = ""
        myDiveTimeTextField.text = ""
        circleMaxDepthTextField.text = ""
        circleVisibilityTextField.text = ""
    }
    
    @IBAction func savePressedBtn(_ sender: Any) {
        guard let myS = mySuitTextField.text,
              let myM = myMaskTextField.text,
              let myF = myFinsTextField.text,
              let myW = myWeightTextField.text,
              let myT = myTempTextField.text,
              let myD = myDiveTimeTextField.text,
              let mycMax = circleMaxDepthTextField.text,
              let mycVis = circleVisibilityTextField.text else {return }
        
        if mySuitTextField.text == "" || myMaskTextField.text == "" ||
            myFinsTextField.text == "" || myWeightTextField.text == "" ||
            myTempTextField.text == "" || myDiveTimeTextField.text == "" ||
            circleMaxDepthTextField.text == "" || circleVisibilityTextField.text == "" {
            let appearance = SCLAlertView.SCLAppearance(
                kCircleIconHeight: 30,
                kTitleFont: UIFont(name: "Chalkboard SE Regular", size: 22)!,
                kTextFont: UIFont(name: "Chalkboard SE Regular", size: 12)!,
                kButtonFont: UIFont(name: "Chalkboard SE Regular", size: 14)!,
                contentViewCornerRadius: 20
            )
            
            let alertView = SCLAlertView(appearance: appearance)
            alertView.view.backgroundColor = UIColor.clear
            alertView.addButton("Leave") {
//                let data = EquipData()
//                self.delegate?.didFinishUpdateEquip(update: data)
                self.navigationController?.popViewController(animated: true)
            }
            alertView.showNotice("You missed something~", subTitle: "🌟",closeButtonTitle: "Ok", circleIconImage: #imageLiteral(resourceName: "wave"))
            
        } else {
            let data = EquipData()
            data.mySuitText = myS
            data.myMaskText = myM
            data.myFinsText = myF
            data.myWeightText = myW
            data.myTempText = myT
            data.myDiveTimeText = myD
            data.circleMaxDepthText = mycMax
            data.circleVisibilityText = mycVis
            self.delegate?.didFinishUpdateEquip(update: data)
            navigationController?.popViewController(animated: true)
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
extension EquipViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.tag == 1 {
            print("textField.tag == 1")
        }
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        textfieldTagNumber = textField.tag
        
        switch textfieldTagNumber {
        case 0:
            circleMaxDepthTextField.text = ""
        case 1:
            circleVisibilityTextField.text = ""
        case 5:
            myWeightTextField.text = ""
        case 6:
            myTempTextField.text = ""
        case 7:
            myDiveTimeTextField.text = ""
        default:
            break
        }
        
        return true
    }
    
    
}
