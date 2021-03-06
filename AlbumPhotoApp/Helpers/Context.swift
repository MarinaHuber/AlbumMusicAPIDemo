//
//  Context.swift
//  AlbumPhotoApp
//
//  Created by Marina Huber on 8/15/18.
//  Copyright © 2018 Marina Huber. All rights reserved.
//


import Foundation
import CoreData


class Context {

	private static let shared = Context()

	static let managedObjectContext = Context.shared.persistentContainer.viewContext
	static let managedObjectContextBg = Context.shared.persistentContainer.newBackgroundContext()

	static func saveContext() {
		Context.shared.saveContext()
	}


	private lazy var persistentContainer: NSPersistentContainer = {

		guard let url = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first else {
			fatalError("Context, persistentContainer: unable to get application support url")
		}

		let fileName = "AlbumInfo"

		if !FileManager.default.fileExists(atPath: url.appendingPathComponent(fileName).appendingPathExtension("sqlite").path ) {

			do {
				try FileManager.default.createDirectory(atPath: url.path, withIntermediateDirectories: true, attributes: nil)
			} catch {
				print(error)
			}
		}

		let container = NSPersistentContainer(name: fileName)

		container.loadPersistentStores(completionHandler: { (storeDescription, error) in
			if let error = error as NSError? {
				assert(false, "Unresolved error \(error), \(error.userInfo)")
			}
		})

		print("User data path")
		print(container.persistentStoreCoordinator.url(for: container.persistentStoreCoordinator.persistentStores.first!).path)

		return container
	}()

	// MARK: - Core Data Saving support

	private func saveContext () {
		let context = persistentContainer.viewContext
		if context.hasChanges {
			do {
				try context.save()
			} catch {

				let nserror = error as NSError
				assert(false, "Unresolved error \(nserror), \(nserror.userInfo)")
			}
		}
	}


	//MARK: - perform methods
	static func performBackgroundTask(_ block: @escaping (NSManagedObjectContext) -> Void) {
		// .performAndWait blocks the main thread and perform does it parallel
		Context.managedObjectContextBg.perform {
			block(Context.managedObjectContextBg)
		}
	}

	static func performViewTask(_ block: @escaping (NSManagedObjectContext) -> Void) {
		Context.managedObjectContext.perform {
			block(Context.managedObjectContext)
		}

	}

	/*
	Alamofire.downloadData() { data in
	Context.performBackgorundTask() { moc in
	parse json from data
	//import into coredata
	moc.save()
	DispatchQueue.main.async { //update UI }
	}
	*/

}

