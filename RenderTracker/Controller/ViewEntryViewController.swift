//
//  ViewEntryViewController.swift
//  RenderTracker
//
//  Created by Pedro Henrique Costa on 20/08/20.
//  Copyright © 2020 Pedro Henrique Costa. All rights reserved.
//

import UIKit

class ViewEntryViewController: UIViewController {

	@IBOutlet weak var entryTitle: UINavigationItem!
	
	@IBOutlet weak var imageDisplay: UIImageView!
	
	@IBOutlet weak var segmentedControl: UISegmentedControl!
	
	@IBOutlet weak var editButton: UIBarButtonItem!
	
	override func viewWillAppear(_ animated: Bool) {
		let storedEntries = UserDefaults.standard.object(forKey: "archive-entries") as? [[String: String]] ?? [[String: String]]()
		let currentEntry = UserDefaults.standard.integer(forKey: "chosen-entry")
		entryTitle.title = storedEntries[currentEntry]["title"]
		
		if let unwrapURL = storedEntries[currentEntry]["referenceImg"] {
			if let validURL = URL(string: unwrapURL) {
				do {
					let imageData = try Data(contentsOf: validURL)
					imageDisplay.image = UIImage(data: imageData)
				} catch {
					print(error)
				}
			}
		}
	}
	
	override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
	
	@IBAction func segmentedChange(_ sender: Any) {
		if segmentedControl.selectedSegmentIndex == 0 {
			imageDisplay.isHidden = false
		} else {
			imageDisplay.isHidden = true
		}
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
			}
		}
	}

}
