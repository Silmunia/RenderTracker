//
//  NewEntry.swift
//  RenderTracker
//
//  Created by Pedro Henrique Costa on 17/08/20.
//  Copyright © 2020 Pedro Henrique Costa. All rights reserved.
//

import UIKit

class NewEntryViewController: UIViewController {

	@IBOutlet weak var searchBar: UISearchBar!
	
	@IBOutlet weak var imageDisplay: UIImageView!
	
	var previousSearch: String?
	
	override func viewDidLoad() {
        super.viewDidLoad()
		
//		let fileURL = getDocumentsDirectory().appendingPathComponent("reference-x.png")
//		do {
//			let imageData = try Data(contentsOf: fileURL)
//			testSaveImage.image = UIImage(data: imageData)
//		} catch {
//			print(error)
//		}
		
//		if UserDefaults.standard.object(forKey: "test-image") != nil {
//			testSaveImage.load(url: UserDefaults.standard.url(forKey: "test-image")!)
//		}
    }
	
	override func pressesEnded(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
		guard let key = presses.first?.key else { return }

		switch key.keyCode {
		case .keyboardReturnOrEnter:
			if let validSearch = searchBar.text {
				let formattedSearch = formatSearchTerms(from: validSearch)
					if formattedSearch.count > 0 {
						if previousSearch != formattedSearch {
							makeSearch(this: formattedSearch)
							previousSearch = formattedSearch
						} else if PictureResults.shared.hits!.count > 0 {
							loadPicture(from: Int.random(in: 0..<PictureResults.shared.hits!.count), at: imageDisplay)
						}
					}
			}
		default:
			super.pressesEnded(presses, with: event)
		}
	}
	
	@IBAction func newEntryDone(_ sender: Any) {
//		let date = Date()
//		let dateFormatter = DateFormatter()
//		dateFormatter.dateFormat = "dd/MM/yyyy"
//
//		let _ = Entry(title: tempEntryName.text!, date: dateFormatter.string(from: date))
		
		if let image = imageDisplay.image {
			if let data = image.pngData() {
				let filename = getDocumentsDirectory().appendingPathComponent("reference-x.png")
				try? data.write(to: filename)
				
//				var stringedURL = ""
//				do {
//					stringedURL = try String(contentsOf: filename)
//					print("file: \(filename)")
//					print("string: \(stringedURL)")
//				} catch {
//					print(error)
//				}
				
				//let newEntry = Entry(title: "Entry A", date: "10/08/2020", imgReference: filename, imgModel: nil)
				var storedEntries = UserDefaults.standard.object(forKey: "archive-entries") as? [[String: String]] ?? [[String: String]]()
				let newEntry = ["title": "Entry \(storedEntries.count + 1)", "date": "19/08/2020", "referenceImg": filename.absoluteString, "modelImg": ""]
				storedEntries.append(newEntry)
				UserDefaults.standard.set(storedEntries, forKey: "archive-entries")
				
//				print(filename)
//				do {
//					let imageData = try Data(contentsOf: filename)
//					testSaveImage.image = UIImage(data: imageData)
//				} catch {
//					print(error)
//				}
				//UserDefaults.standard.set(filename, forKey: "test-image")
			}
		}
	}
	
	func getDocumentsDirectory() -> URL {
		let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
		return paths[0]
	}
	
	@IBAction func refreshSearch(_ sender: Any) {
		if previousSearch != nil {
			loadPicture(from: Int.random(in: 0..<PictureResults.shared.hits!.count), at: imageDisplay)
		}
	}
	
	func formatSearchTerms(from str: String) -> String {
		var formattedTerms = ""
		
		for (num, char) in str.enumerated() {
			
			if char == " " {
				if num != 0 && num != str.count-1 {
					formattedTerms.append("+")
				}
			} else {
				formattedTerms.append(char.lowercased())
			}
		}
		
		return formattedTerms
	}
	
	func makeSearch(this str: String) {
		
		let imageAPI = PictureAPI()
		imageAPI.pictureSearch(this: str)
		loadPicture(from: Int.random(in: 0..<PictureResults.shared.hits!.count), at: imageDisplay)
	}
	
	func loadPicture(from num: Int, at img: UIImageView) {
		
		if let validHits = PictureResults.shared.hits {
			let imgURL = URL(string: validHits[num].largeImageURL)
			if let validURL = imgURL {
				do {
					let imageData = try Data(contentsOf: validURL)
					img.image = UIImage(data: imageData)
				} catch {
					print(error)
				}
				//img.load(url: validURL)

			}
		}
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
//
//extension UIImageView {
//
//    func load(url: URL) {
//
//        DispatchQueue.global().async { [weak self] in
//            if let data = try? Data(contentsOf: url) {
//                if let image = UIImage(data: data) {
//                    DispatchQueue.main.async {
//                        self?.image = image
//                    }
//                }
//            }
//        }
//    }
//}
