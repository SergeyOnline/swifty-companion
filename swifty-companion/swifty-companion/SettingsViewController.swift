//
//  SettingsViewController.swift
//  swifty-companion
//
//  Created by Сергей on 04.07.2021.
//

import UIKit
import CoreData

class SettingsViewController: UIViewController {

	var skillsSwitch: UISwitch!
	var projectsSwitch: UISwitch!
	var container: NSPersistentContainer!
	var settings: Settings!
	
	
    override func viewDidLoad() {
        super.viewDidLoad()
		guard container != nil else {
			fatalError("This view needs a persistent container.")
		}
		let context = self.container.viewContext
		var settingsArray: [Settings] = []
		let request: NSFetchRequest<Settings> = Settings.fetchRequest()
		do {
			settingsArray = try context.fetch(request)
			settings = settingsArray[0]
		} catch {
			let error = error as NSError
			fatalError("Unresolved error \(error), \(error.userInfo)")
		}

		self.view.backgroundColor = .systemGray6
		
		let skillsLabel = UILabel()
		skillsLabel.text = "show skills"
		skillsLabel.translatesAutoresizingMaskIntoConstraints = false
		
		skillsSwitch = UISwitch()
		skillsSwitch.isOn = settings.skills
		skillsSwitch.onTintColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
		skillsSwitch.translatesAutoresizingMaskIntoConstraints = false
		
		
		let projectsLabel = UILabel()
		projectsLabel.text = "show projects"
		projectsLabel.translatesAutoresizingMaskIntoConstraints = false
		
		projectsSwitch = UISwitch()
		projectsSwitch.isOn = settings.projects
		projectsSwitch.onTintColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
		projectsSwitch.translatesAutoresizingMaskIntoConstraints = false

		self.view.addSubview(skillsLabel)
		self.view.addSubview(skillsSwitch)
		self.view.addSubview(projectsLabel)
		self.view.addSubview(projectsSwitch)

		skillsLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 20).isActive = true
		skillsLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20).isActive = true
		
		skillsSwitch.centerYAnchor.constraint(equalTo: skillsLabel.centerYAnchor).isActive = true
		skillsSwitch.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20).isActive = true
		
		projectsLabel.topAnchor.constraint(equalTo: skillsLabel.bottomAnchor, constant: 20).isActive = true
		projectsLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20).isActive = true
		
		projectsSwitch.centerYAnchor.constraint(equalTo: projectsLabel.centerYAnchor).isActive = true
		projectsSwitch.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20).isActive = true
    }
    
	override func viewDidDisappear(_ animated: Bool) {
		settings.skills = skillsSwitch.isOn
		settings.projects = projectsSwitch.isOn
		saveContext()
	}

	func saveContext() {
		let context = self.container.viewContext
		if context.hasChanges {
			do {
				try context.save()
			} catch {
				let nserror = error as NSError
				fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
			}
		}
	}
}
