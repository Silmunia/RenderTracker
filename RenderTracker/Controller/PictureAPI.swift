//
//  PictureAPI.swift
//  RenderTracker
//
//  Created by Pedro Henrique Costa on 14/08/20.
//  Copyright © 2020 Pedro Henrique Costa. All rights reserved.
//

import Foundation

class PictureAPI {
    
    let keyAPI = "17842354-31438ae4b555f6918df993e4a"
    
    // MARK: API Request
    
	func pictureSearch(this str: String) {
		
        let url = URL(string: "https://pixabay.com/api/?key=\(keyAPI)&q=\(str)&image_type=photo")
        let semaphore = DispatchSemaphore(value: 0)
        
        if let validURL = url {
            let task = URLSession.shared.dataTask(with: validURL) { data, response, error in
                
                if error != nil {
                    print("Client error!")
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                    print("Server error!")
                    return
                }
                
                let decoder = JSONDecoder()
                do {
                    PictureResults.shared = try decoder.decode(PictureResults.self, from: data!)
                    semaphore.signal()
                } catch {
                    print(error)
                }
            }
            
            task.resume()
            
            semaphore.wait()
        }
    }
}
