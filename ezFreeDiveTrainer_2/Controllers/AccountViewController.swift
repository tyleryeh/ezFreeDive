//
//  AccountViewController.swift
//  ezFreeDiveTrainer_2
//
//  Created by Che Chang Yeh on 2020/12/22.
//

import UIKit
import MessageUI
import AuthenticationServices
import KeychainAccess
import TrustKit
import SCLAlertView
import SafariServices

class AccountViewController: UIViewController {
    
    @IBOutlet weak var accountImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var myTableView: UITableView!

    
    var cellText = ["Version", "Report", "Privacy Policy"]
    var version = ""
    //要兜出上面那組masterKey.....
    var masterKey: String {
        var result = ""
        result += String(10 * 7 + 7)
        result += "rt"
        result += "hg".reversed()
        var sss = ""
        for _ in 0..<4 {
            sss += "7"
        }
        result += sss
        result += "ervt77re2776fer6U_ijhuh_jnhu"
        return result
    }
    
    private let signInButton = ASAuthorizationAppleIDButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "091EternalConstance"))
        self.title = "Account"
        myTableView.dataSource = self
        myTableView.delegate = self
        myTableView.backgroundColor = UIColor.clear
        
        accountImageView.backgroundColor = UIColor.clear

        SubFunctions.shared.imageSet(image: accountImageView, name: "cat-face", c1: "#37ecba", c2: "#72afd3", lineWidth: 5.0)
        
        let dictionary = Bundle.main.infoDictionary!
        version = dictionary["CFBundleShortVersionString"] as! String
        
        view.addSubview(signInButton)
        signInButton.addTarget(self, action: #selector(appleLogInTap), for: .touchUpInside)
        
        self.accountImageView.isUserInteractionEnabled = true
        self.accountImageView.addGestureRecognizer(photoGesture())
        
    }
    
    func photoGesture() -> UIGestureRecognizer {
        let gesTure = UITapGestureRecognizer(target: self, action: #selector(selecPhoto))
        // 點幾下才觸發
        gesTure.numberOfTapsRequired = 1
        // 幾根指頭觸發
        gesTure.numberOfTouchesRequired = 1
        return gesTure
    }
    
    @objc func selecPhoto() {
        let picker = UIImagePickerController()
        picker.sourceType = .savedPhotosAlbum
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //Load userInformation
        if let name = loadFromKeychain(service: UserInformation.UserInfo.rawValue, masterKey: masterKey) {
            nameLabel.text = name
        } else {
            nameLabel.text = ""
        }
        
        decryptFile()
        
//        if UserDefaults.standard.bool(forKey: "didSelectedPhoto") == true {
//            decryptFile()
//        }
    }
    
    override func viewDidLayoutSubviews() {
        super .viewDidLayoutSubviews()
        signInButton.frame = CGRect(x: 0, y: 0, width: 250, height: 42)
        signInButton.center = CGPoint(x: myTableView.frame.midX, y: myTableView.frame.maxY + 16)
        signInButton.cornerRadius = 10
        signInButton.backgroundColor = UIColor.clear
        
    }
    
    @objc func appleLogInTap() {
        
        if checkUserLogInData() == false {
            requestLogIn()
        } else {
            showDidLogInAlertView()
        }
        
    }
    
}

//MARK: Apple Login
extension AccountViewController: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("Fail")
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        
        if let credential = authorization.credential as? ASAuthorizationAppleIDCredential {
            guard let userToken = credential.identityToken,
                  let userName = credential.fullName else {
                assertionFailure("Fail to convert token and fullName.")
                return
            }
            guard let familyName = userName.familyName,
                  let givenName = userName.givenName else {
                assertionFailure("Fail to convert.")
                return
            }
            let name = familyName + " " + givenName
            nameLabel.text = name
            saveToKeychain(token: userToken, userName: name, service: UserInformation.UserInfo.rawValue, masterKey: masterKey)
            
            UserDefaults.standard.set(true, forKey: "didLogIn")
        }
        else {
            UserDefaults.standard.set(false, forKey: "didLogIn")
            print("Save error.")
        }
        
    }
}

extension AccountViewController: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return view.window!
    }
}

//MARK: Email
extension AccountViewController: UINavigationControllerDelegate, MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}

//MARK: TableView
extension AccountViewController: UITableViewDelegate, SFSafariViewControllerDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 1 {
            sendEmail()
        } else if indexPath.row == 2 {
            let url = URL(string: "https://www.privacypolicies.com/live/af471e09-630b-4a63-ba63-6a3dd56ccb8d")!
            let safariVC = SFSafariViewController(url: url)
            safariVC.preferredBarTintColor = .black
            safariVC.preferredControlTintColor = .white
            safariVC.dismissButtonStyle = .close
            safariVC.delegate = self
            self.present(safariVC, animated: true, completion: nil)
            
        } else if indexPath.row == 3 {

        } else {
            
        }
    }
}

extension AccountViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellText.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.backgroundColor = UIColor.clear
        cell.textLabel?.font = UIFont(name: "Chalkboard SE Regular", size: 22)
        cell.textLabel?.text = self.cellText[indexPath.row]
        if indexPath.row == 0 {
            cell.detailTextLabel?.font = UIFont(name: "Chalkboard SE Regular", size: 22)
            cell.detailTextLabel?.text = "\(version)"
            cell.accessoryType = .none
            return cell
        } else {
            cell.accessoryType = .disclosureIndicator
            cell.detailTextLabel?.text = ""
            return cell
        }
    }
    
    
}

//MARK: ImagePicker
extension AccountViewController: UIImagePickerControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.originalImage] as! UIImage
        encryptFile(image: image)
        UserDefaults.standard.setValue(true, forKey: "didSelectedPhoto")
        self.accountImageView.image = image
        self.dismiss(animated: true, completion: nil)
    }
}

//MARK: Functions
extension AccountViewController {
    //寄信
    func sendEmail() {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["tylersoooong79@hotmail.com.tw"])
            mail.setMessageBody("<p>You're so awesome!</p>", isHTML: true)
            mail.setEditing(true, animated: true)
            mail.setSubject("🌟 ezFreeDiveTrainer")
            present(mail, animated: true)
        } else {
            // show failure alert
        }
    }
    
    //存登入後資料到Keychain
    func saveToKeychain(token: Data, userName: String?, service: String, masterKey: String) {
        let tokenStr = String(decoding: token, as: UTF8.self)
        guard let encryptedToken = tokenStr.encryptedToBase64(key: masterKey) else {
            assertionFailure("Fail to encrypt token.")
            return
        }
        print("token: \(token) ==> \(encryptedToken)")
        
        //寫入keychain
        let keychain = Keychain(service: service)
        keychain["encryptedToken"] = encryptedToken
        //預設是String
        keychain["userName"] = userName
        //Data格式
//        keychain[data: "secretKey"] = Data([0x00, 0x01, 0x02])
    }
    
    //讀Keychain資料
    func loadFromKeychain(service: String, masterKey: String) -> String? {
        let keychain = Keychain(service: service)
        guard let name = keychain["userName"] else {
            print("login is not valid")
            return "Please Log in with Apple ID."
        }
        return name
  
    }
    
    //加密使用者圖片
    func encryptFile(image: UIImage) {
        //從bundle把圖撈進來
        guard let data = image.jpegData(compressionQuality: 0.5) else {
            assertionFailure("Fail to load image data from file.")
            return
        }
        let targetURL = FileManager.default.temporaryDirectory.appendingPathComponent("output.x")
        
        //完成加密
        try? data.encrypt(to: targetURL, key: masterKey)
        
    }
    
    //解密使用者圖片
    func decryptFile() {
        let sourceURL = FileManager.default.temporaryDirectory.appendingPathComponent("output.x")
        do {
            let data = try Data.decrypt(from: sourceURL, key: masterKey)
            accountImageView.image = UIImage(data: data)
        } catch {
           print("User no select data error: \(error)")
        }
    }
    
    //檢查使用者有沒有登入
    func checkUserLogInData() -> Bool {
        return loadFromKeychain(service: UserInformation.UserInfo.rawValue, masterKey: masterKey) == nil ? false: true
    }
    
    //請求登入
    func requestLogIn() {
        let provider = ASAuthorizationAppleIDProvider()
        let request = provider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.presentationContextProvider = self
        controller.performRequests()
    }
    
    //顯示已登入警告視窗
    func showDidLogInAlertView() {
        let appearance = SCLAlertView.SCLAppearance(
            kCircleIconHeight: 30,
            kTitleFont: UIFont(name: "Chalkboard SE Regular", size: 22)!,
            kTextFont: UIFont(name: "Chalkboard SE Regular", size: 12)!,
            kButtonFont: UIFont(name: "Chalkboard SE Regular", size: 14)!,
            contentViewCornerRadius: 20
        )
        
        let alertView = SCLAlertView(appearance: appearance)
        alertView.view.backgroundColor = UIColor.clear
        alertView.showSuccess("You have logged in.", subTitle: "🌟", closeButtonTitle: "Ok", circleIconImage: #imageLiteral(resourceName: "cat-face"))
    }
}

enum UserInformation: String {
    case UserInfo
}

