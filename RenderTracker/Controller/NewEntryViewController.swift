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
    }
	
	override func pressesEnded(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
		guard let key = presses.first?.key else { return }

		switch key.keyCode {
		case .keyboardReturnOrEnter:
			if let validSearch = searchBar.text {
				let formattedSearch = formatSearchTerms(from: validSearch)
					if formattedSearch.count > 0 {
						self.imageDisplay.isHidden = false
						if previousSearch != formattedSearch && formattedSearch.rangeOfCharacter(from: NSCharacterSet.letters) != nil {
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
		
		let alert = UIAlertController(title: "Enter the New Entry's title", message: "Give an unique title to your new entry", preferredStyle: .alert)
		var storedEntries = UserDefaults.standard.object(forKey: "archive-entries") as? [[String: String]] ?? [[String: String]]()
		
		alert.addTextField { (textField) in
			textField.text = "Entry \(storedEntries.count + 1)"
		}
		
		alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
			self.dismiss(animated: true, completion: nil)
		}))
		
		alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { _ in
			let date = Date()
			let dateFormatter = DateFormatter()
			dateFormatter.dateFormat = "dd/MM/yyyy"
			
			if let image = self.imageDisplay.image {
				if let data = image.pngData() {
					let appendName = UUID().uuidString
					let filename = self.getDocumentsDirectory().appendingPathComponent("\(appendName).png")
					try? data.write(to: filename)
					
					if let entryTitle = alert.textFields![0].text {
						if entryTitle.rangeOfCharacter(from: NSCharacterSet.letters) == nil {
							let newEntry = ["title": "Entry \(storedEntries.count + 1)", "date": dateFormatter.string(from: date), "referenceImg": filename.absoluteString, "modelImg": ""]
							storedEntries.append(newEntry)
							UserDefaults.standard.set(storedEntries, forKey: "archive-entries")
						} else {
							let newEntry = ["title": entryTitle, "date": dateFormatter.string(from: date), "referenceImg": filename.absoluteString, "modelImg": ""]
							storedEntries.append(newEntry)
							UserDefaults.standard.set(storedEntries, forKey: "archive-entries")
						}
					}
				}
			}
			
			self.imageDisplay.isHidden = true
		}))
		self.present(alert, animated: true)
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
			if let validURL = URL(string: validHits[num].largeImageURL) {
				do {
					let imageData = try Data(contentsOf: validURL)
					img.image = UIImage(data: imageData)
				} catch {
					print(error)
				}
			}
		}
	}
	
    /*

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
