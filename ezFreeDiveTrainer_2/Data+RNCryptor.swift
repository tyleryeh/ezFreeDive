//
//  Data+RNCryptor.swift
//  HelloMySecurity
//
//  Created by Che Chang Yeh on 2020/12/21.
//

import Foundation
import RNCryptor

extension Data {
    
    //近來是base64要先轉成binary的資料
    //Convert base64/encryptoed data to decrypted data.
    func decryptBase64(key: String) throws -> Data? {
        //轉換回原本的data
        guard  let encryptrfDate = Data(base64Encoded: self) else {
            print("Fail to convert from base64 data.")
            return nil
        }
        //有handler通常交給外面的人去處理
        return try RNCryptor.decrypt(data: encryptrfDate, withPassword: key)
    }
    //加密
    func encrypt(to: URL, key: String) throws {
        let encryptedData = RNCryptor.encrypt(data: self, withPassword: key)
        try encryptedData.write(to: to)
        
    }
    //解密
    static func decrypt(from: URL, key: String) throws -> Data {
        //資料從硬碟來
        let encryptedData = try Data(contentsOf: from)
        return try RNCryptor.decrypt(data: encryptedData, withPassword: key)
    }
    
}
