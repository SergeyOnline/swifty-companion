//
//  ViewController.swift
//  swifty-companion
//
//  Created by Сергей on 01.07.2021.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
	
	
	private let idPersonCell = "PersonCell"
	var tableView: UITableView!
	var searhBar: UISearchBar!
	var operation: Operation?
	private var token: Token!
	var currentUser: CurrentUser!
	
	var persons: [User] = []
	
	override func loadView() {
		super.loadView()
		
		tokenPost { token in
			self.token = token
		}
		DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
			print("Token load")
		}
		
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.navigationItem.title = "42 Intra"
		view.backgroundColor = .systemGray6
		
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
		searhBar.searchBarStyle = .minimal
		
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
		self.operation?.cancel()
		operation = BlockOperation.init(block: {
			getUsers(user: text, params: self.token) { users in
				if !text.isEmpty {
					for user in users {
						arr.append(user)
					}
				}
				DispatchQueue.main.async {
					self.persons = arr
					self.tableView.reloadData()
				}
			}
		})
		operation?.start()
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
		self.tableView.deselectRow(at: indexPath, animated: true)
		let indicator = UIActivityIndicatorView(style: .large)
		indicator.color = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
		indicator.translatesAutoresizingMaskIntoConstraints = false
		self.view.addSubview(indicator)
		indicator.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
		indicator.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
		
		indicator.startAnimating()
		getUserInfo(userId: persons[indexPath.row].id, params: self.token) { user in
			DispatchQueue.main.async {
				self.currentUser = user
				let detailVC = DetailViewController(user: self.currentUser)
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


}

