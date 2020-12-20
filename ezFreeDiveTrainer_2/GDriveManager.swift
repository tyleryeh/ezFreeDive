//
//  GDriveManager.swift
//  HelloMyGDriveManager
//
//  Created by Che Chang Yeh on 2020/11/16.
//

import Foundation
import GoogleAPIClientForREST
import GTMSessionFetcher

class GDriveManager{
    
    //googleDrive功能的核心都靠這個物件
    private let drive = GTLRDriveService()
    
    //singleton --> 跨VC使用～
    //用起手式
//    static let shared = GDriveManager()
//    private init(){
//
//    }
    static let shared = GDriveManager()
    private init(){
        
    }
    
    //將authorizer傳入FileListTableViewController裡
    //用GTMFetcherAuthorization"Protocol"
    func setAuthorizer(authorizer:  GTMFetcherAuthorizationProtocol){
        drive.authorizer = authorizer
    }
    
    //可選型別GTLRServiceCompletionHandler? 不用加@escaping
    func uploadFile(url: URL, name: String, mimeType: String, description: String, completion: GTLRServiceCompletionHandler?){
        
        //1. prepare GTLDrive_File.
        //google要求先塞資訊給GTLRDrive_File()
        let file = GTLRDrive_File()
        file.name = name
        file.descriptionProperty = description
        file.mimeType = mimeType
        //file.originalFilename = ... //原始檔名
        
        //2. Prepare parameters and query.
        let parameters = GTLRUploadParameters(fileURL: url, mimeType: mimeType)
        let query = GTLRDriveQuery_FilesCreate.query(withObject: file, uploadParameters: parameters)
        //3. Execute query.
        //丟底層
        //Ticket: 取消，上傳下載進度
        //        let ticket = drive.executeQuery(query) { (<#GTLRServiceTicket#>, <#Any?#>, <#Error?#>) in
        //            <#code#>
        //        }
        //不在乎結果可以把completionHandler設成nil
        drive.executeQuery(query, completionHandler: completion)
    }
    
    //透過completion將結果拋出去給view處理
    func downloadFileList(completion: GTLRServiceCompletionHandler?) {
        
        //希望google drive回傳資料時不要做分頁
        //就是可以一直滑滑滑倒底不用在load
        drive.shouldFetchNextPages = true
        
        let query = GTLRDriveQuery_FilesList.query()
        //query可以做條件搜尋，搜尋條
        //query.q = "..."
        drive.executeQuery(query, completionHandler: completion)
    }
    
    func deleteFile(by identifier: String, completion: GTLRServiceCompletionHandler?) {
        
        let query = GTLRDriveQuery_FilesDelete.query(withFileId: identifier)
        drive.executeQuery(query, completionHandler: completion)
    }
    
    func downloadFile(by identifier: String, completion: GTMSessionFetcherCompletionHandler?) {
        //google要憑證才可以下載喔
        let urlString = String(format: "https://www.googleapis.com/drive/v2/files/\(identifier)?alt=media")
        
        let fetcher = drive.fetcherService.fetcher(withURLString: urlString)
        
        fetcher.beginFetch(completionHandler: completion)
        
    }
    
}
