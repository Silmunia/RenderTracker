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
		let currentEntry = UserDefaults.standard.integer(forKey: "chosen-entry")
		let storedEntries = UserDefaults.standard.object(forKey: "archive-entries") as? [[String: String]] ?? [[String: String]]()
		entryTitle.title = storedEntries[currentEntry]["title"]
		if segmentedControl.selectedSegmentIndex == 0 {
			if let unwrapURL = storedEntries[currentEntry]["referenceImg"] {
				if let validURL = URL(string: unwrapURL) {
					do {
						let imageData = try Data(contentsOf: validURL)
						imageDisplay.image = UIImage(data: imageData)
						imageDisplay.isHidden = false
					} catch {
						print(error)
					}
				}
			}
		} else {
			if let unwrapURL = storedEntries[currentEntry]["modelImg"] {
				if let validURL = URL(string: unwrapURL) {
					do {
						let imageData = try Data(contentsOf: validURL)
						imageDisplay.image = UIImage(data: imageData)
						imageDisplay.isHidden = false
					} catch {
						print(error)
						imageDisplay.isHidden = true
					}
				} else {
					imageDisplay.isHidden = true
				}
			} else {
				imageDisplay.isHidden = true
			}
		}
	}
	
	override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
	
	@IBAction func segmentedChange(_ sender: Any) {
		let currentEntry = UserDefaults.standard.integer(forKey: "chosen-entry")
		let storedEntries = UserDefaults.standard.object(forKey: "archive-entries") as? [[String: String]] ?? [[String: String]]()
		if segmentedControl.selectedSegmentIndex == 0 {
			if let unwrapURL = storedEntries[currentEntry]["referenceImg"] {
				if let validURL = URL(string: unwrapURL) {
					do {
						let imageData = try Data(contentsOf: validURL)
						imageDisplay.image = UIImage(data: imageData)
						imageDisplay.isHidden = false
					} catch {
						print(error)
					}
				}
			}
		} else {
			if let unwrapURL = storedEntries[currentEntry]["modelImg"] {
				if let validURL = URL(string: unwrapURL) {
					do {
						let imageData = try Data(contentsOf: validURL)
						imageDisplay.image = UIImage(data: imageData)
						imageDisplay.isHidden = false
					} catch {
						print(error)
						imageDisplay.isHidden = true
					}
				} else {
					imageDisplay.isHidden = true
				}
			} else {
				imageDisplay.isHidden = true
			}
		}
	}
}
