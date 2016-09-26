
import UIKit
import Alamofire

public enum HTTPMethod : String {
    case GET
    case POST
    case DELETE
}

class NetworkManager: NSObject {
    
    typealias CompletionHandler = (response: Response<AnyObject, NSError>) -> Void
    
    static let sharedInstance = NetworkManager()
    
    private override init() {} //This prevents others from using the default '()' initializer for this class.
    
    // Header
    func performRequestWithURL(URLString: URLStringConvertible, method: HTTPMethod, headers: [String : String]?, parameters: AnyObject?, completionHandler: CompletionHandler) {
        
        debugPrint("URL: \(URLString)")
        debugPrint("Parameters: \(parameters)")
        debugPrint("Headers: \(headers!)")
        
        var outputMethod = Method.GET
        
        if method == HTTPMethod.GET {
            outputMethod = Method.GET
        } else if method == HTTPMethod.POST {
            outputMethod = Method.POST
        } else if method == HTTPMethod.DELETE {
            outputMethod = Method.DELETE
        }
                
        Alamofire.request(outputMethod, URLString, parameters: (outputMethod == Method.GET ? nil : parameters as? [String : AnyObject]), encoding: .JSON, headers: headers!)
            .responseJSON { response in
                completionHandler(response: response)
        }
    }
    
    func uploadImageOnURL(URLString: URLStringConvertible, imageData: NSData, headers: [String : String]?, parameters: [String: AnyObject], completionHandler: CompletionHandler) {
        debugPrint("File size is : \(imageData.length/1024/1024)")
        debugPrint("URL: \(URLString)")
        debugPrint("Parameters: \(parameters)")
        debugPrint("Headers: \(headers!)")
        
        Alamofire.upload(
            .POST,
            URLString,
            headers: headers!,
            multipartFormData: { multipartFormData in
                multipartFormData.appendBodyPart(data: imageData, name: "profile_pic",
                    fileName: "image.jpg", mimeType: "image/jpeg")
            },
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .Success(let upload, _, _):
                    upload.progress { bytesWritten, totalBytesWritten, totalBytesExpectedToWrite in
                        dispatch_async(dispatch_get_main_queue()) {
                            let percent = (Float(totalBytesWritten) / Float(totalBytesExpectedToWrite))
                            print(percent)
                        }
                    }
                    upload.validate()
                    upload.responseJSON { response in
                        completionHandler(response: response)
                    }
                case .Failure(let encodingError):
                    print(encodingError)
                    let error = NSError(domain: "", code: 404, userInfo: [NSLocalizedDescriptionKey: "Image Uploading Failed. Please try again."])
                    let result = Result<AnyObject, NSError>.Failure(error)
                    let response = Response(request: nil, response: nil, data: nil, result: result)
                    completionHandler(response: response)
                    
                }
            }
        )
    }
}
