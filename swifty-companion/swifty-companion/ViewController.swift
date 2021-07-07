//
//  ViewController.swift
//  swifty-companion
//
//  Created by Сергей on 01.07.2021.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
	
	var container: NSPersistentContainer!
	private let idPersonCell = "PersonCell"
	var tableView: UITableView!
	var searhBar: UISearchBar!
//	var operation: Operation?
	var currentUser: CurrentUser!
	var loadIndicator: UIActivityIndicatorView!
	
	var persons: [User] = []
	
	override func loadView() {
		super.loadView()
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		guard container != nil else {
			fatalError("This view needs a persistent container.")
		}
		
		self.navigationItem.title = "42 Intra"
		view.backgroundColor = .systemGray6
		let rightBarButton = UIBarButtonItem(title: "settings", style: .plain, target: self, action: #selector(rightBarButtonAction))
		self.navigationItem.rightBarButtonItem = rightBarButton
		
		searhBar = UISearchBar()
		searhBar.autoresizingMask = .flexibleWidth
		searhBar.placeholder = "search"
		searhBar.delegate = self
		if self.traitCollection.userInterfaceStyle == .dark {
			self.navigationController?.navigationBar.tintColor = .white
			searhBar.tintColor = .white
		} else {
			self.navigationController?.navigationBar.tintColor = .black
			searhBar.tintColor = .black
		}
		
		loadIndicator = UIActivityIndicatorView(style: .medium)
		loadIndicator.color = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
		loadIndicator.autoresizingMask = .init(arrayLiteral: [.flexibleLeftMargin, .flexibleRightMargin, .flexibleTopMargin, .flexibleBottomMargin])
		searhBar.searchBarStyle = .minimal
		searhBar.addSubview(loadIndicator)
		loadIndicator.startAnimating()
		loadIndicator.isHidden = true
		
		tableView = UITableView(frame: self.view.frame, style: .insetGrouped)
		tableView.delegate = self
		tableView.dataSource = self
		tableView.register(PersonCell.self, forCellReuseIdentifier: idPersonCell)
		
		tableView.autoresizingMask = .init(arrayLiteral: .flexibleWidth, .flexibleHeight)
		tableView.backgroundColor = .systemGray6
	
		self.view.addSubview(tableView)
		
	}
	
	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		if section == 0 {
			return searhBar
		}
		return nil
	}
	
	func findPersonInBackgroundFromArray(searchText: String) {
		var text = searchText
		text.removeAll { ch in
			return ch == " "
		}
		var arr: [User] = []
		self.loadIndicator.isHidden = true
//		self.operation?.cancel()
		loadIndicator.isHidden = false
//		operation = BlockOperation.init(block: {
			getUsers(user: text, token: CurrentToken, filtered: false) { users in
				if !text.isEmpty {
					if !users.isEmpty {
						for user in users {
							arr.append(user)
						}
					} else {
						getUsers(user: text, token: CurrentToken, filtered: true) { persons in
							for person in persons {
								arr.append(person)
							}
							DispatchQueue.main.async {
								self.persons = arr
								self.tableView.reloadData()
								self.loadIndicator.isHidden = true
							}
						}
					}
				}
				DispatchQueue.main.async {
					self.persons = arr
					self.tableView.reloadData()
					self.loadIndicator.isHidden = true
				}
			}
//		})
//		operation?.start()
	}
	
	//MARK: - UISearchBarDelegate
	func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
		searchBar.setShowsCancelButton(true, animated: true)
	}
	
	func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
		searchBar.resignFirstResponder()
		searchBar.setShowsCancelButton(false, animated: true)
	}
	
	func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
		findPersonInBackgroundFromArray(searchText: searchText)
	}
	

	//MARK: - UITableViewDataSource
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return persons.count
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		loadIndicator.isHidden = true
		self.tableView.deselectRow(at: indexPath, animated: true)
		let indicator = UIActivityIndicatorView(style: .large)
		indicator.color = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
		indicator.translatesAutoresizingMaskIntoConstraints = false
		self.view.addSubview(indicator)
		indicator.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
		indicator.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
		
		indicator.startAnimating()
		getUserInfo(userId: persons[indexPath.row].id, token: CurrentToken) { user in
			DispatchQueue.main.async {
				self.currentUser = user
				let detailVC: DetailViewController = {
					let vc = DetailViewController(user: self.currentUser)
					vc.container = self.container
					return vc
				}()
				self.navigationController?.pushViewController(detailVC, animated: true)
				indicator.stopAnimating()
				indicator.removeFromSuperview()
			}
		}
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		let	cell = tableView.dequeueReusableCell(withIdentifier: idPersonCell) as! PersonCell
		
		cell.textLabel?.text = persons[indexPath.row].login
		cell.backgroundColor = .systemGray6
		return cell
	}
	
	//MARK: - Actions
	@objc func rightBarButtonAction(sender: UIBarButtonItem) {
		let settingsVC: SettingsViewController = {
			let vc = SettingsViewController()
			vc.container = self.container
			return vc
		}()
		self.present(settingsVC, animated: true) {}
	}
	
}

