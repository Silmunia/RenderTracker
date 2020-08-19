//
//  ListEntryViewControllerTableViewController.swift
//  RenderTracker
//
//  Created by Pedro Henrique Costa on 17/08/20.
//  Copyright © 2020 Pedro Henrique Costa. All rights reserved.
//

import UIKit

//struct Entry: Codable {
//	var title: String
//	var date: String
//	var imgReference: URL
//	var imgModel: URL?
//}

class ListEntryTableViewController: UITableViewController {

	var entries: [[String: String]] = []
	
	override func viewWillAppear(_ animated: Bool) {
		entries = UserDefaults.standard.array(forKey: "archive-entries") as? [[String: String]] ?? [[String: String]]()
		tableView.reloadData()
	}
		
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return entries.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "entry", for: indexPath)

		cell.textLabel?.text = entries[indexPath.row]["title"]
		cell.detailTextLabel?.text = entries[indexPath.row]["date"]
		
        return cell
    }

	override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
		let deleteAction = UIContextualAction(style: .destructive, title: nil) { (_, _, completionHandler) in
			self.entries.remove(at: indexPath.row)
			tableView.deleteRows(at: [indexPath], with: .fade)
            completionHandler(true)
        }
		
		deleteAction.image = UIImage(systemName: "trash")
        deleteAction.backgroundColor = .systemRed
		let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
		return configuration
	}
	
	override func tableView(_ tableViewHere: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
		let renameAction = UIContextualAction(style: .normal, title: nil) { (_, _, completionHandler) in
            
			let alert = UIAlertController(title: "Enter the Entry's new title", message: "Give your Entry a new name", preferredStyle: .alert)
			var storedEntries = UserDefaults.standard.object(forKey: "archive-entries") as? [[String: String]] ?? [[String: String]]()
			
			alert.addTextField { (textField) in
				textField.text = "\(storedEntries[indexPath.row]["title"]!)"
			}
			
			alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
				self.dismiss(animated: true, completion: nil)
			}))
			
			alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { _ in
				if let entryTitle = alert.textFields![0].text {
					if entryTitle.rangeOfCharacter(from: NSCharacterSet.letters) == nil {
						storedEntries[indexPath.row]["title"] = "Entry \(storedEntries.count + 1)"
						UserDefaults.standard.set(storedEntries, forKey: "archive-entries")
					} else {
						storedEntries[indexPath.row]["title"] = entryTitle
						UserDefaults.standard.set(storedEntries, forKey: "archive-entries")
					}
				}
				// MARK: Fazer a atualização do nome aqui de algum jeito
			}))
			self.present(alert, animated: true)
			
            completionHandler(true)
        }
		
		renameAction.image = UIImage(systemName: "pencil.and.ellipsis.rectangle")
		renameAction.backgroundColor = .systemBlue
		let configuration = UISwipeActionsConfiguration(actions: [renameAction])
		return configuration
	}
}
