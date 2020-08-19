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
		
		//print(entries)
	}
		
    override func viewDidLoad() {
        super.viewDidLoad()
		
//		let date = Date()
//		let dateFormatter = DateFormatter()
//		dateFormatter.dateFormat = "dd/MM/yyyy"
//
//		let entryA = Entry(title: "Entry A", date: dateFormatter.string(from: date))
//		let entryB = Entry(title: "Entry B", date: dateFormatter.string(from: date))
//		let entryC = Entry(title: "Entry C", date: dateFormatter.string(from: date))
//
//		entries = [entryA, entryB, entryC]
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
	
	override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
		let renameAction = UIContextualAction(style: .normal, title: nil) { (_, _, completionHandler) in
            // rename the item here
            completionHandler(true)
        }
		
		renameAction.image = UIImage(systemName: "pencil.and.ellipsis.rectangle")
		renameAction.backgroundColor = .systemBlue
		let configuration = UISwipeActionsConfiguration(actions: [renameAction])
		return configuration
	}
}
