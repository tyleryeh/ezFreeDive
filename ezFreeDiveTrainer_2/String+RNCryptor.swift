//
//  String+RNCryptor.swift
//  HelloMySecurity
//
//  Created by Che Chang Yeh on 2020/12/21.
//

import Foundation
import RNCryptor


extension String {
    
    //加密
    func encryptedToBase64(key: String) -> String? {
        //加解密的底層是Data但想轉成String
        guard let data = self.data(using: .utf8) else {
            assertionFailure("Fail to convert to data.")
            return nil
        }
        return RNCryptor.encrypt(data: data, withPassword: key).base64EncodedString()
    }
    
    //解密
    func decryptedFromBase64(key: String) throws -> String? {
        //base64 to String
        guard let data = Data(base64Encoded: self)  else {
            assertionFailure("Fail to convert to data.")
            return nil
        }
        let decrytedData = try RNCryptor.decrypt(data: data, withPassword: key)
        return String(data: decrytedData, encoding: .utf8)
    }
    
    
    
}
