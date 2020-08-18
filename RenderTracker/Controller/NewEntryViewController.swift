//
//  NewEntry.swift
//  RenderTracker
//
//  Created by Pedro Henrique Costa on 17/08/20.
//  Copyright © 2020 Pedro Henrique Costa. All rights reserved.
//

import UIKit

class NewEntryViewController: UIViewController {

	@IBOutlet weak var tempEntryName: UISearchBar!
	
	@IBOutlet weak var imageDisplay: UIImageView!
	
	override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
	
	override func pressesEnded(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
		guard let key = presses.first?.key else { return }

		switch key.keyCode {
			case .keyboardReturnOrEnter:
				if let validSearch = tempEntryName.text {
					let testAPI = PictureAPI()
					testAPI.pictureSearch(this: validSearch)
					loadPicture(from: Int.random(in: 0..<PictureResults.shared.hits!.count), at: imageDisplay)
				}
			default:
				super.pressesEnded(presses, with: event)
		}
	}
	
	func loadPicture(from num: Int, at img: UIImageView) {
		
		if let validHits = PictureResults.shared.hits {
			let imgURL = URL(string: validHits[num].largeImageURL)
			if let validURL = imgURL {
				img.load(url: validURL)

			}
		}
	}
	
	@IBAction func newEntryDone(_ sender: Any) {
//		let date = Date()
//		let dateFormatter = DateFormatter()
//		dateFormatter.dateFormat = "dd/MM/yyyy"
//
//		let _ = Entry(title: tempEntryName.text!, date: dateFormatter.string(from: date))
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
