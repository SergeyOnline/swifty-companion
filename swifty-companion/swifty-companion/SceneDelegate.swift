//
//  SceneDelegate.swift
//  swifty-companion
//
//  Created by Сергей on 01.07.2021.
//

import UIKit
import CoreData

var CurrentToken: Token? = nil
var GlobalColor: UIColor = .black

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

	var window: UIWindow?

	func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
		
		tokenPost { token in
			CurrentToken = token
		}
		
		let context = persistentContainer.viewContext
		var settingsArray: [Settings] = []
		let request: NSFetchRequest<Settings> = Settings.fetchRequest()
		do {
			settingsArray = try context.fetch(request)
			if settingsArray.count == 0 {
				let settings = Settings(context: context)
				settings.projects = true
				settings.skills = true
				saveContext()
			}
		} catch {
			let error = error as NSError
			fatalError("Unresolved error \(error), \(error.userInfo)")
		}
		
		guard let windowScene = (scene as? UIWindowScene) else { return }
		window = UIWindow(windowScene: windowScene)
		let viewController: ViewController = {
			let vc = ViewController()
			vc.container = self.persistentContainer
			return vc
		}()
		let navigationVC = UINavigationController(rootViewController: viewController)
		navigationVC.navigationBar.barTintColor = .systemGray5
		window?.rootViewController = navigationVC
		window?.makeKeyAndVisible()
	}

	func sceneDidDisconnect(_ scene: UIScene) {
		// Called as the scene is being released by the system.
		// This occurs shortly after the scene enters the background, or when its session is discarded.
		// Release any resources associated with this scene that can be re-created the next time the scene connects.
		// The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
	}

	func sceneDidBecomeActive(_ scene: UIScene) {
		// Called when the scene has moved from an inactive state to an active state.
		// Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
	}

	func sceneWillResignActive(_ scene: UIScene) {
		// Called when the scene will move from an active state to an inactive state.
		// This may occur due to temporary interruptions (ex. an incoming phone call).
	}

	func sceneWillEnterForeground(_ scene: UIScene) {
		// Called as the scene transitions from the background to the foreground.
		// Use this method to undo the changes made on entering the background.
	}

	func sceneDidEnterBackground(_ scene: UIScene) {
		// Called as the scene transitions from the foreground to the background.
		// Use this method to save data, release shared resources, and store enough scene-specific state information
		// to restore the scene back to its current state.
	}


	
	// MARK: - Core Data stack
	
	lazy var persistentContainer: NSPersistentContainer = {
		let container = NSPersistentContainer(name: "swifty-companion")
		container.loadPersistentStores { description, error in
			if let error = error {
				fatalError("Unable to load persistent stores: \(error)")
			}
		}
		return container
	}()
	
	// MARK: - Core Data Saving support

	func saveContext () {
		let context = persistentContainer.viewContext
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

