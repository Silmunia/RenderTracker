//
//  ViewController.swift
//  RenderTracker
//
//  Created by Pedro Henrique Costa on 13/08/20.
//  Copyright © 2020 Pedro Henrique Costa. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
	
	@IBOutlet weak var testImageDisplay: UIImageView!
	
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
		
		let testAPI = PictureAPI()
		testAPI.pictureSearch()
		//PictureResults.shared.testPrintData()
		loadPicture(from: Int.random(in: 0..<PictureResults.shared.hits!.count), at: testImageDisplay)
    }
	
	func loadPicture(from num: Int, at img: UIImageView) {
		
		if let validHits = PictureResults.shared.hits {
			let imgURL = URL(string: validHits[num].largeImageURL)
			if let validURL = imgURL {
				img.load(url: validURL)

			}
		}
	}
}

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
