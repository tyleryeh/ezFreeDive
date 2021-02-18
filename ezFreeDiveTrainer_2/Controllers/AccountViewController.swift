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

class AccountViewController: UIViewController {
    
    @IBOutlet weak var accountImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var myTableView: UITableView!

    
    var cellText = ["Version", "Report", "Privacy Policy"]
    var version = ""
    //要都出上面那組masterKey.....
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
        
        let dictionary = Bundle.main.infoDictionary!
        version = dictionary["CFBundleShortVersionString"] as! String
        print("\(version)")
        
        view.addSubview(signInButton)
        signInButton.addTarget(self, action: #selector(appleLogInTap), for: .touchUpInside)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //Load userInformation
        if UserDefaults.standard.bool(forKey: "didLogIn") == true {
            nameLabel.text = loadFromKeychain(service: UserInformation.UserInfo.rawValue, masterKey: masterKey)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super .viewDidLayoutSubviews()
        signInButton.frame = CGRect(x: 0, y: 0, width: 250, height: 42)
        signInButton.center = CGPoint(x: myTableView.frame.midX, y: myTableView.frame.maxY + 16)
        signInButton.cornerRadius = 10
        signInButton.backgroundColor = UIColor.clear
        
    }
    
    @objc func appleLogInTap() {
        let provider = ASAuthorizationAppleIDProvider()
        let request = provider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.presentationContextProvider = self
        controller.performRequests()
        
    }
    
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
    
    func loadFromKeychain(service: String, masterKey: String) -> String? {
        let keychain = Keychain(service: service)
        guard let name = keychain["userName"] else {
            print("login is not valid")
            return "Please Log in with Apple ID."
        }
        return name
        
        //token
//        guard let encryptedToken = keychain["encryptedToken"],
//              let decryptedToken = try? encryptedToken.decryptedFromBase64(key: masterKey) else {
//            print("encryptedToken is not valid")
//            return
//        }
//        print("encryptedToken: \(encryptedToken)")
//        print("encryptedToken: \(encryptedToken) ==> \(decryptedToken)")
        
        //Clean Value Only
//        keychain["login"] = nil
        
        //Remove the whole key-value pair.
//        try? keychain.remove("login")
        
        //Remove all.
//        try? keychain.removeAll()
  
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

extension AccountViewController: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("Fail")
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
//        if let credential = authorization.credential as? ASAuthorizationAppleIDCredential {
//            let fullName = credential.fullName
//            let appleEmail = credential.email
//            nameLabel.text = String(describing: fullName)
//            emailLabel.text = String(describing: appleEmail)
//            print("\(String(describing: fullName))")
//            print("\(String(describing: appleEmail))")
//        }
        
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

extension AccountViewController: UINavigationControllerDelegate, MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}

extension AccountViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 1 {
            sendEmail()
        } else if indexPath.row == 2 {
            
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

enum UserInformation: String {
    case UserInfo
}

