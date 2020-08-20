//
//  EditModelViewController.swift
//  RenderTracker
//
//  Created by Pedro Henrique Costa on 20/08/20.
//  Copyright © 2020 Pedro Henrique Costa. All rights reserved.
//

import UIKit

class EditModelViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        let picker = UIImagePickerController()
		picker.allowsEditing = true
		picker.delegate = self
		present(picker, animated: true)
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
		}
		
		dismiss(animated: true)
	}
	
	func getDocumentsDirectory() -> URL {
		let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
		return paths[0]
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
