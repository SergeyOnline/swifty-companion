//
//  DetailViewController.swift
//  swifty-companion
//
//  Created by Сергей on 02.07.2021.
//


import UIKit

class DetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
	
	private var user: CurrentUser!
	private var maxLevel: Double!
	var tableView: UITableView!
	let cellId = "InfoCell"
	var projects: [ProjectsUsers] = []
	var skills: [Skills] = []
	
	init(user: CurrentUser) {
		self.user = user
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func loadView() {
		super.loadView()
		
		for project in user.projects_users {
			if project.status == "finished" && (project.cursus_ids.contains(1) || project.cursus_ids.contains(21)) {
				projects.append(project)
			}
		}
		for circus in user.cursus_users {
			skills = circus.skills
//			if circus.grade == "Member" {
//				skills = circus.skills
//			}
		}
		let maxSkill = skills.max { s1, s2 in
			s1.level < s2.level
		}
		maxLevel = maxSkill!.level
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		self.navigationItem.title = user.login
		self.view.backgroundColor = .link
		
		tableView = UITableView(frame: self.view.frame, style: .grouped)
		tableView.delegate = self
		tableView.dataSource = self
		tableView.register(InfoCell.self, forCellReuseIdentifier: cellId)
		tableView.autoresizingMask = .init(arrayLiteral: .flexibleWidth, .flexibleHeight)
		
		self.view.addSubview(tableView)
		
    }
	
	//MARK: - UITableViewDataSource
	
	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		if section == 0 {
			let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.width))
			imageView.imageFromServerURL(urlString: self.user.image_url)
			imageView.contentMode = UIImageView.ContentMode.scaleAspectFit
			return imageView
		}
		return nil
	}
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return 3
	}
	
	func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		if section == 1 {
			return "skills"
		} else if section == 2 {
			return "projects"
		}
		return nil
	}
	
	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		if section == 0 {
			return self.view.frame.width
		}
		return 22
	}
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if section == 0 {
			return 6
		} else if section == 1 {
			return skills.count
		} else {
			return projects.count
		}
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		self.tableView.deselectRow(at: indexPath, animated: false)
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		var cell: UITableViewCell!
		if indexPath.section == 0 {
			cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellId)
		} else {
			cell = UITableViewCell(style: .value1, reuseIdentifier: cellId)
		}
		
		setCellForIndexPath(&cell, indexPath: indexPath)
		return cell
	}
	
	
	func setCellForIndexPath(_ cell: inout UITableViewCell, indexPath: IndexPath) {
		if indexPath.section == 0 {
			switch indexPath.row {
			case 0:
				cell.textLabel?.text = "Login"
				cell.detailTextLabel?.text = user.login
			case 1:
				cell.textLabel?.text = "First name"
				cell.detailTextLabel?.text = user.first_name
			case 2:
				cell.textLabel?.text = "last Name"
				cell.detailTextLabel?.text = user.last_name
			case 3:
				cell.textLabel?.text = "Email"
				cell.detailTextLabel?.text = user.email
			case 4:
				cell.textLabel?.text = "Correction points"
				cell.detailTextLabel?.text = String(user.correction_point)
			case 5:
				cell.textLabel?.text = "Wallet"
				cell.detailTextLabel?.text = String(user.wallet)
			default:
				break
			}
		} else if indexPath.section == 1 {
			cell.textLabel?.text = skills[indexPath.row].name
			let level = (Double(Int(skills[indexPath.row].level * 100))) / 100
			cell.detailTextLabel?.text = String(level)
			let percent = skills[indexPath.row].level / maxLevel 
			
//			let percent = skills[indexPath.row].level - Double(Int(skills[indexPath.row].level))
			
//			let progressView = UIProgressView()
//			progressView.progress = Float(percent)
//			progressView.progressViewStyle = .bar
//			cell.backgroundView = progressView
	
			
			let cellView = UIView()
			cellView.backgroundColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
			cellView.alpha = 0.2

			cellView.translatesAutoresizingMaskIntoConstraints = false
			cell.backgroundView = cellView
			cellView.leftAnchor.constraint(equalTo: cell.leftAnchor).isActive = true
			cellView.topAnchor.constraint(equalTo: cell.topAnchor).isActive = true
			cellView.bottomAnchor.constraint(equalTo: cell.bottomAnchor).isActive = true
			cellView.rightAnchor.constraint(equalTo: cell.leftAnchor, constant: cell.frame.maxX * CGFloat(percent)).isActive = true
			
		} else if indexPath.section == 2 {
			let names = projects.sorted { return $0.project.name < $1.project.name }
			cell.textLabel?.text = names[indexPath.row].project.name
			cell.detailTextLabel?.text = String(names[indexPath.row].final_mark!)
			if names[indexPath.row].final_mark! > 0 {
				cell.detailTextLabel?.textColor = .systemGreen
			} else {
				cell.detailTextLabel?.textColor = .systemRed
			}
		}
	}
}

extension UIImageView {
	public func imageFromServerURL(urlString: String) {
		URLSession.shared.dataTask(with: URL(string: urlString)!) { (data, response, error) in
			if error != nil {
				print(error ?? "Error")
				return
			}
			DispatchQueue.main.async {
				let image = UIImage(data: data!)
				self.image = image
			}
		}.resume()
	}
}

