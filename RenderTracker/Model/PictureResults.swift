//
//  PictureData.swift
//  RenderTracker
//
//  Created by Pedro Henrique Costa on 14/08/20.
//  Copyright © 2020 Pedro Henrique Costa. All rights reserved.
//

import Foundation

struct PictureData: Codable {
    
    var id: Int
    var largeImageURL: String
}

class PictureResults: Codable {
    
    static var shared = PictureResults()
    
    var total: Int?
    var totalHits: Int?
    var hits: [PictureData]?
	
	// MARK: Test Print Data
	
	func testPrintData() {
		
		if let validHits = hits {
			let rand = validHits[Int.random(in: 0..<validHits.count)]
			print("""
				Total Hits: \(String(describing: total))
				Image ID: \(rand.id)
				Image URL: \(rand.largeImageURL)
			""")
		}
	}
}

/* MARK: API JSON Reference
    {
"total": 4692,
"totalHits": 500,
"hits": [
    {
        "id": 195893,
        "pageURL": "https://pixabay.com/en/blossom-bloom-flower-195893/",
        "type": "photo",
        "tags": "blossom, bloom, flower",
        "previewURL": "https://cdn.pixabay.com/photo/2013/10/15/09/12/flower-195893_150.jpg"
        "previewWidth": 150,
        "previewHeight": 84,
        "webformatURL": "https://pixabay.com/get/35bbf209e13e39d2_640.jpg",
        "webformatWidth": 640,
        "webformatHeight": 360,
        "largeImageURL": "https://pixabay.com/get/ed6a99fd0a76647_1280.jpg",
        "fullHDURL": "https://pixabay.com/get/ed6a9369fd0a76647_1920.jpg",
        "imageURL": "https://pixabay.com/get/ed6a9364a9fd0a76647.jpg",
        "imageWidth": 4000,
        "imageHeight": 2250,
        "imageSize": 4731420,
        "views": 7671,
        "downloads": 6439,
        "favorites": 1,
        "likes": 5,
        "comments": 2,
        "user_id": 48777,
        "user": "Josch13",
        "userImageURL": "https://cdn.pixabay.com/user/2013/11/05/02-10-23-764_250x250.jpg",
    },
    {
        "id": 73424,
        ...
    },
    ...
]
}
*/
