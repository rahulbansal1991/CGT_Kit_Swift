//
//  NetworkManager.swift
//  APIManager
//
//  Created by SHEETAL on 30/04/16.
//  Copyright © 2016 SHEETAL. All rights reserved.
//

import UIKit
let REQUEST_TIMEOUT_INTERVAL : Int32 = 30
let REQUEST_RETRY_AFTER_TIMEOUT : Int32 = 2
let IMAGE_COMPRESSION_QUALITY : CGFloat = 1


class NetworkManager: NSObject
{
    typealias RequestSuccess = (request: AFHTTPRequestOperation,data:AnyObject,status: Bool) -> (Void)
    typealias RequestFail = (error: NSError) -> (Void)
    
    var networkQueue : [AFHTTPRequestOperation]=[]
    
    func cancelAllRunningNetworkOperations()
    {
        //var arr : NSMutableArray = self.getNetworkQueue()
        for var operation : AFHTTPRequestOperation in networkQueue
        {
            defer {
            }
            do
            {
                try operation.cancel()
                networkQueue.removeAll()
            }
            catch let exception
            {
                NSLog("Error while cancelling the operation")
            }
        }
    }
    
    func executePostWithImage(url:String, parameters:NSDictionary,headers:NSDictionary,andImage : UIImage,andImageTag : String,constructingBodyWithBlock:((formData: AFMultipartFormData) -> Void),withSuccessHandler:RequestSuccess,withFailureHandler:RequestFail)
    {
        if(!self.isDataConnectionAvailable())
        {
            print("Network Connection is not available.")
            withFailureHandler(error: NSError.init(domain: "Network Connection is not available.", code: 0, userInfo: [:]))
            return
        }
        
        let manager = AFHTTPRequestOperationManager()
        manager.requestSerializer = AFJSONRequestSerializer()
        manager.responseSerializer = AFHTTPResponseSerializer()
        manager.requestSerializer.setValue("application/json", forHTTPHeaderField:"Content-Type")
        manager.responseSerializer.acceptableContentTypes = NSSet(objects:"application/json", "text/html", "text/plain", "text/json", "text/javascript", "audio/wav") as Set<NSObject>
        
        // check if custom headers are present and add them
        
        headers.enumerateKeysAndObjectsWithOptions(NSEnumerationOptions.Reverse, usingBlock: { (key, value, stop) -> Void in
            manager.requestSerializer.setValue(value as? String , forHTTPHeaderField: key as! String )
        })
        
        let imageData : NSData = UIImageJPEGRepresentation(andImage, IMAGE_COMPRESSION_QUALITY)!
        print(imageData.length)
        
        let operation : AFHTTPRequestOperation = manager.POST(url, parameters: parameters as [NSObject : AnyObject], constructingBodyWithBlock:
            { (formData: AFMultipartFormData!) -> Void in
                formData.appendPartWithFileData(imageData, name: andImageTag, fileName: "photo\(andImageTag).jpg", mimeType: "image/jpeg")
            },
            success:
            {
                (operation: AFHTTPRequestOperation!, responseObject: AnyObject!) in
                
                NSLog("Success: %@ ***** %@", operation.responseString!, responseObject as! String);
                self.networkQueue.removeAtIndex(self.networkQueue.indexOf(operation)!)
                withSuccessHandler(request: operation, data: responseObject, status: true)
            },
            failure:
            {
                (operation: AFHTTPRequestOperation!,error: NSError!) in
                self.networkQueue.removeAtIndex(self.networkQueue.indexOf(operation)!)
            }, autoRetry: REQUEST_RETRY_AFTER_TIMEOUT, retryInterval: REQUEST_TIMEOUT_INTERVAL)
        operation.start()
        networkQueue.append(operation)
    }
    
    func executePostWithAudio(url:String, parameters:NSDictionary,headers:NSDictionary,andAudioFileUrl :NSURL,andAudioTag : String,constructingBodyWithBlock:((formData: AFMultipartFormData) -> Void),withSuccessHandler:RequestSuccess,withFailureHandler:RequestFail)
    {
        if(!self.isDataConnectionAvailable())
        {
            print("Network Connection is not available.")
            withFailureHandler(error: NSError.init(domain: "Network Connection is not available.", code: 0, userInfo: [:]))
            return
        }
        
        let manager = AFHTTPRequestOperationManager()
        manager.requestSerializer = AFJSONRequestSerializer()
        manager.responseSerializer = AFHTTPResponseSerializer()
        manager.requestSerializer.setValue("application/json", forHTTPHeaderField:"Content-Type")
        manager.responseSerializer.acceptableContentTypes = NSSet(objects:"application/json", "text/html", "text/plain", "text/json", "text/javascript", "audio/wav") as Set<NSObject>
        
        // check if custom headers are present and add them
        
        headers.enumerateKeysAndObjectsWithOptions(NSEnumerationOptions.Reverse, usingBlock: { (key, value, stop) -> Void in
            manager.requestSerializer.setValue(value as? String , forHTTPHeaderField: key as! String )
        })
        
        let audioData : NSData = NSData(contentsOfURL: andAudioFileUrl)!
        print(audioData.length)

        
        let operation : AFHTTPRequestOperation = manager.POST(url, parameters: parameters as [NSObject : AnyObject], constructingBodyWithBlock:
            { (formData: AFMultipartFormData!) -> Void in
                formData.appendPartWithFileData(audioData, name: andAudioTag, fileName: "Audio\(andAudioTag).mp3", mimeType: "Audio/mp3")
            },
            success:
            {
                (operation: AFHTTPRequestOperation!, responseObject: AnyObject!) in
                
                NSLog("Success: %@ ***** %@", operation.responseString!, responseObject as! String);
                self.networkQueue.removeAtIndex(self.networkQueue.indexOf(operation)!)
                withSuccessHandler(request: operation, data: responseObject, status: true)
            },
            failure:
            {
                (operation: AFHTTPRequestOperation!,error: NSError!) in
                self.networkQueue.removeAtIndex(self.networkQueue.indexOf(operation)!)
            }, autoRetry: REQUEST_RETRY_AFTER_TIMEOUT, retryInterval: REQUEST_TIMEOUT_INTERVAL)
        operation.start()
        networkQueue.append(operation)
    }
    
    func executePostWithVideo(url:String, parameters:NSDictionary,headers:NSDictionary,andVideoFileUrl :NSURL,andVideoTag : String,constructingBodyWithBlock:((formData: AFMultipartFormData) -> Void),withSuccessHandler:RequestSuccess,withFailureHandler:RequestFail)
    {
        if(!self.isDataConnectionAvailable())
        {
            print("Network Connection is not available.")
            withFailureHandler(error: NSError.init(domain: "Network Connection is not available.", code: 0, userInfo: [:]))
            return
        }
        
        let manager = AFHTTPRequestOperationManager()
        manager.requestSerializer = AFJSONRequestSerializer()
        manager.responseSerializer = AFHTTPResponseSerializer()
        manager.requestSerializer.setValue("application/json", forHTTPHeaderField:"Content-Type")
        manager.responseSerializer.acceptableContentTypes = NSSet(objects:"application/json", "text/html", "text/plain", "text/json", "text/javascript", "audio/wav") as Set<NSObject>
        
        // check if custom headers are present and add them
        
        headers.enumerateKeysAndObjectsWithOptions(NSEnumerationOptions.Reverse, usingBlock: { (key, value, stop) -> Void in
            manager.requestSerializer.setValue(value as? String , forHTTPHeaderField: key as! String )
        })
        
        let videoData : NSData = NSData(contentsOfURL: andVideoFileUrl)!
        print(videoData.length)
        
        let operation : AFHTTPRequestOperation = manager.POST(url, parameters: parameters as [NSObject : AnyObject], constructingBodyWithBlock:
            { (formData: AFMultipartFormData!) -> Void in
                formData.appendPartWithFileData(videoData, name: andVideoTag, fileName: "Video \(andVideoTag).mp4", mimeType: "Video/mp4")
            },
            success:
            {
                (operation: AFHTTPRequestOperation!, responseObject: AnyObject!) in
                
                NSLog("Success: %@ ***** %@", operation.responseString!, responseObject as! String);
                self.networkQueue.removeAtIndex(self.networkQueue.indexOf(operation)!)
                withSuccessHandler(request: operation, data: responseObject, status: true)
            },
            failure:
            {
                (operation: AFHTTPRequestOperation!,error: NSError!) in
                self.networkQueue.removeAtIndex(self.networkQueue.indexOf(operation)!)
            }, autoRetry: REQUEST_RETRY_AFTER_TIMEOUT, retryInterval: REQUEST_TIMEOUT_INTERVAL)
        operation.start()
        networkQueue.append(operation)
    }

    func executePostWithUrl(url:String, parameters:NSDictionary,headers:NSDictionary,withSuccessHandler:RequestSuccess,withFailureHandler:RequestFail)
    {
        if(!self.isDataConnectionAvailable())
        {
            print("Network Connection is not available.")
            withFailureHandler(error: NSError.init(domain: "Network Connection is not available.", code: 0, userInfo: [:]))
            return
        }
        
        let manager = AFHTTPRequestOperationManager()
        manager.requestSerializer = AFJSONRequestSerializer()
        manager.responseSerializer = AFHTTPResponseSerializer()
        manager.requestSerializer.setValue("application/json", forHTTPHeaderField:"Content-Type")
        manager.responseSerializer.acceptableContentTypes = NSSet(objects:"application/json", "text/html", "text/plain", "text/json", "text/javascript", "audio/wav") as Set<NSObject>
        
        // check if custom headers are present and add them
        headers.enumerateKeysAndObjectsWithOptions(NSEnumerationOptions.Reverse, usingBlock: { (key, value, stop) -> Void in
            manager.requestSerializer.setValue(value as? String , forHTTPHeaderField: key as! String )
        })
        
        let operation : AFHTTPRequestOperation = manager.POST(url, parameters: parameters as [NSObject : AnyObject], success: {
            (operation: AFHTTPRequestOperation!, responseObject: AnyObject!) in
            
            NSLog("Success: %@ ***** %@", operation.responseString!, responseObject as! String);
            self.networkQueue.removeAtIndex(self.networkQueue.indexOf(operation)!)
            withSuccessHandler(request: operation, data: responseObject, status: true)
            }, failure: {
                
                (operation: AFHTTPRequestOperation!,error: NSError!) in
                self.networkQueue.removeAtIndex(self.networkQueue.indexOf(operation)!)
            }, autoRetry: REQUEST_RETRY_AFTER_TIMEOUT, retryInterval: REQUEST_TIMEOUT_INTERVAL)
        operation.start()
        networkQueue.append(operation)
    }
    
    func executePutWithUrl(url:String, parameters:NSDictionary,headers:NSDictionary,withSuccessHandler:RequestSuccess,withFailureHandler:RequestFail)
    {
        if(!self.isDataConnectionAvailable())
        {
            print("Network Connection is not available.")
            withFailureHandler(error: NSError.init(domain: "Network Connection is not available.", code: 0, userInfo: [:]))
            return
        }
        
        let manager = AFHTTPRequestOperationManager()
        manager.requestSerializer = AFJSONRequestSerializer()
        manager.responseSerializer = AFHTTPResponseSerializer()
        manager.requestSerializer.setValue("application/json", forHTTPHeaderField:"Content-Type")
        manager.responseSerializer.acceptableContentTypes = NSSet(objects:"application/json", "text/html", "text/plain", "text/json", "text/javascript", "audio/wav") as Set<NSObject>

        // check if custom headers are present and add them
        headers.enumerateKeysAndObjectsWithOptions(NSEnumerationOptions.Reverse, usingBlock: { (key, value, stop) -> Void in
            manager.requestSerializer.setValue(value as? String , forHTTPHeaderField: key as! String )
        })
                let operation : AFHTTPRequestOperation = manager.PUT(url, parameters: parameters as [NSObject : AnyObject], success: {
            (operation: AFHTTPRequestOperation!, responseObject: AnyObject!) in
            
            NSLog("Success: %@ ***** %@", operation.responseString!, responseObject as! String);
            self.networkQueue.removeAtIndex(self.networkQueue.indexOf(operation)!) as! Bool
            let apiSuccess=responseObject.objectForKey("success")?.isEqual(true)
            withSuccessHandler(request: operation, data: responseObject, status: apiSuccess!)
            }, failure:
            {
                (operation: AFHTTPRequestOperation!,error: NSError!) in
                self.networkQueue.removeAtIndex(self.networkQueue.indexOf(operation)!)
            }, autoRetry: REQUEST_RETRY_AFTER_TIMEOUT, retryInterval: REQUEST_TIMEOUT_INTERVAL)
        operation.start()
        networkQueue.append(operation)
    }
    
    func executeGetWithUrl(url:String, parameters:NSDictionary,headers:NSDictionary,withSuccessHandler:RequestSuccess,withFailureHandler:RequestFail)
    {
        if(!self.isDataConnectionAvailable())
        {
            print("Network Connection is not available.")
            withFailureHandler(error: NSError.init(domain: "Network Connection is not available.", code: 0, userInfo: [:]))
            return
        }
        
        let manager = AFHTTPRequestOperationManager()
        manager.requestSerializer = AFJSONRequestSerializer()
        manager.responseSerializer = AFHTTPResponseSerializer()
        manager.requestSerializer.setValue("application/json", forHTTPHeaderField:"Content-Type")
        manager.responseSerializer.acceptableContentTypes = NSSet(objects:"application/json", "text/html", "text/plain", "text/json", "text/javascript", "audio/wav") as Set<NSObject>

        // check if custom headers are present and add them
        headers.enumerateKeysAndObjectsWithOptions(NSEnumerationOptions.Reverse, usingBlock: { (key, value, stop) -> Void in
            manager.requestSerializer.setValue(value as? String , forHTTPHeaderField: key as! String )
        })
        
        
        let operation : AFHTTPRequestOperation = manager.GET(url, parameters: parameters as [NSObject : AnyObject],
            success: {
            (operation: AFHTTPRequestOperation!, responseObject: AnyObject!) in
            
            NSLog("Success: %@ ***** %@", operation.responseString!, responseObject as! String);
            self.networkQueue.removeAtIndex(self.networkQueue.indexOf(operation)!) as! Bool
            let apiSuccess=responseObject.objectForKey("success")?.isEqual(true)
            withSuccessHandler(request: operation, data: responseObject, status: apiSuccess!)
            }, failure:
            {
                (operation: AFHTTPRequestOperation!,error: NSError!) in
                self.networkQueue.removeAtIndex(self.networkQueue.indexOf(operation)!)
            }, autoRetry: REQUEST_RETRY_AFTER_TIMEOUT, retryInterval: REQUEST_TIMEOUT_INTERVAL)
        operation.start()
        networkQueue.append(operation)
    }
    
    // To check Network connectivity
    func isDataConnectionAvailable() -> Bool
    {
        return AFNetworkReachabilityManager.sharedManager().networkReachabilityStatus.rawValue > 0 ? true:false
    }
}
