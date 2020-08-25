//
//  ViewEntryViewController.swift
//  RenderTracker
//
//  Created by Pedro Henrique Costa on 20/08/20.
//  Copyright © 2020 Pedro Henrique Costa. All rights reserved.
//

import UIKit

class ViewEntryViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {

	@IBOutlet weak var entryTitle: UINavigationItem!
	
	@IBOutlet weak var imageDisplay: UIImageView!
	
	@IBOutlet weak var segmentedControl: UISegmentedControl!
		
	@IBOutlet weak var modelMessage: UIView!
	
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
						modelMessage.isHidden = true
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
						modelMessage.isHidden = true
					} catch {
						print(error)
						imageDisplay.isHidden = true
						modelMessage.isHidden = false
					}
				} else {
					imageDisplay.isHidden = true
					modelMessage.isHidden = false
				}
			} else {
				imageDisplay.isHidden = true
				modelMessage.isHidden = false
			}
		}
	}
	
	override func viewDidLoad() {
        super.viewDidLoad()
		modelMessage.isHidden = true
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
						modelMessage.isHidden = true
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
						modelMessage.isHidden = true
					} catch {
						print(error)
						imageDisplay.isHidden = true
						modelMessage.isHidden = false

					}
				} else {
					imageDisplay.isHidden = true
					modelMessage.isHidden = false
				}
			} else {
				imageDisplay.isHidden = true
				modelMessage.isHidden = false
			}
		}
	}
	
	@IBAction func editEntry(_ sender: Any) {
		
		if segmentedControl.selectedSegmentIndex == 0 {
			if let changingReference = storyboard?.instantiateViewController(identifier: "editReference") {
				present(changingReference, animated: true)
			}
		} else {
			let picker = UIImagePickerController()
			picker.allowsEditing = true
			picker.delegate = self
			present(picker, animated: true)
		}
	}
	
	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
		guard let image = info[.editedImage] as? UIImage else {
			return
		}
		
		let imageName = UUID().uuidString
		let imagePath = getDocumentsDirectory().appendingPathComponent("\(imageName).png")
		if let data = image.pngData() {
			try? data.write(to: imagePath)
			
			let currentEntry = UserDefaults.standard.integer(forKey: "chosen-entry")
			var storedEntries = UserDefaults.standard.object(forKey: "archive-entries") as? [[String: String]] ?? [[String: String]]()
			storedEntries[currentEntry]["modelImg"] = imagePath.absoluteString
			UserDefaults.standard.set(storedEntries, forKey: "archive-entries")
			
			if let unwrapURL = storedEntries[currentEntry]["modelImg"] {
				if let validURL = URL(string: unwrapURL) {
					do {
						let imageData = try Data(contentsOf: validURL)
						imageDisplay.image = UIImage(data: imageData)
						imageDisplay.isHidden = false
						modelMessage.isHidden = true
					} catch {
						print(error)
						imageDisplay.isHidden = true
						modelMessage.isHidden = false
					}
				} else {
					imageDisplay.isHidden = true
					modelMessage.isHidden = false
				}
			} else {
				imageDisplay.isHidden = true
				modelMessage.isHidden = false
			}
		}
		
		dismiss(animated: true)
	}
	
	func getDocumentsDirectory() -> URL {
		let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
		return paths[0]
	}
}
