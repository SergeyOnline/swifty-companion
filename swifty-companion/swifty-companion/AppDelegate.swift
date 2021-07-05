//
//  AppDelegate.swift
//  swifty-companion
//
//  Created by Сергей on 01.07.2021.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
	
	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

//		let context = persistentContainer.viewContext
//		let settings = Settings(context: context)
//		var settingsArray: [Settings] = []
//		let request: NSFetchRequest<Settings> = Settings.fetchRequest()
//		
//		do {
//			settingsArray = try context.fetch(request)
//			if settingsArray.count != 0 {
//				settings.projects = true
//				settings.skills = true
//			}
//		} catch {
//			let error = error as NSError
//			fatalError("Unresolved error \(error), \(error.userInfo)")
//		}
//		
//		do {
//			settingsArray = try context.fetch(request)
//			for elem in settingsArray {
//				print("Skills: \(elem.skills), Projects: \(elem.projects)")
//			}
//			print("COUNT: \(settingsArray.count)")
//		} catch {
//			let error = error as NSError
//			fatalError("Unresolved error \(error), \(error.userInfo)")
//		}
		
		
		return true
	}

	// MARK: UISceneSession Lifecycle

	func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
		// Called when a new scene session is being created.
		// Use this method to select a configuration to create the new scene with.
		return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
	}

	func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
		// Called when the user discards a scene session.
		// If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
		// Use this method to release any resources that were specific to the discarded scenes, as they will not return.
	}
	
//	// MARK: - Core Data stack
//	
//	lazy var persistentContainer: NSPersistentContainer = {
//		let container = NSPersistentContainer(name: "swifty-companion")
//		container.loadPersistentStores { description, error in
//			if let error = error {
//				fatalError("Unable to load persistent stores: \(error)")
//			}
//		}
//		return container
//	}()
//	
//	// MARK: - Core Data Saving support
//
//	func saveContext () {
//		let context = persistentContainer.viewContext
//		if context.hasChanges {
//			do {
//				try context.save()
//			} catch {
//				let nserror = error as NSError
//				fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
//			}
//		}
//	}
}

