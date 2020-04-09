//
//  APIManager.swift
//  StockList
//
//  Created by Pankaj Teckchandani on 08/04/20.
//  Copyright © 2020 Pankaj Teckchandani. All rights reserved.
//

import UIKit

class APIManager: NSObject {
    static let sharedInstance = APIManager();
    
    private let BASE_URL = "https://api.jsonbin.io/b/"
    private override init() {}
    
    func postRequestForPersonList(params : NSDictionary, onSuccess:@escaping(_ serverResponse: Data)->(), onFailure:@escaping (_ error: NSError) ->() ) -> ()
    {
        let strUrl = BASE_URL + Constants.WebServices.kGetListOfUsers
        DispatchQueue.global().async {
            self.httpGETCall(urlString: strUrl, params: params, success: { (response) in
                onSuccess(response)
            }, failure: { (error) in
                onFailure(error)
            })
        }
    }
    
    
    
    private func httpGETCall(urlString : String ,params : NSDictionary,  success:@escaping (_ serverResponse: Data) ->(), failure:@escaping (_ error: NSError) ->())
    {
        
        let url = URL(string: urlString)
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        request.httpShouldHandleCookies = true
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if ((error) == nil), let data = data{
                success(data)
            }
            else{
                let userInfo: [AnyHashable : Any] =
                    [
                        NSLocalizedDescriptionKey :  NSLocalizedString("Unauthorized", value: Constants.Alerts.kUnableToReachServer, comment: "") ,
                        NSLocalizedFailureReasonErrorKey : NSLocalizedString("Unauthorized", value: Constants.Alerts.kErrorKey, comment: "")
                ]
                let err = NSError(domain: "HttpResponseErrorDomain", code: 500, userInfo: userInfo as? [String : Any])
                
                failure(err);
            }
            
        }.resume()
        
    }
}
