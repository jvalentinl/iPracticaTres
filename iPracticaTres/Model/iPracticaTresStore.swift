//
//  iPracticaTresStore.swift
//  iPracticaTres
//
//  Created by ALEXIS-PC on 11/12/18.
//  Copyright © 2018 upc.edu.pe. All rights reserved.
//

import Foundation
import CoreData
import UIKit
class iPracticaTresStore {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let delegate = UIApplication.shared.delegate as! AppDelegate
    let favoriteEntityName = "Favorite"
    
    func save() {
        delegate.saveContext()
    }
    
    func addFavorite(for source: Source) {
        let entityDescription = NSEntityDescription.entity(forEntityName: favoriteEntityName, in: context)
        
        let favorite = NSManagedObject(entity: entityDescription!, insertInto: context)
        
        favorite.setValue(source.id, forKey: "sourceId")
        favorite.setValue(source.name, forKey: "sourceName")
        save()        
    }
    
    func findFavoriteBy(predicate: NSPredicate, for source: Source) -> NSManagedObject? {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: favoriteEntityName)
        request.returnsObjectsAsFaults = false
        
        let predicate = predicate
        request.predicate = predicate
        do {
            let result = try context.fetch(request)
            return result.first as? NSManagedObject
        } catch let error {
            print("Request Error: \(error.localizedDescription)")
        }
        return nil
    }
    
    func findFavoriteById(for source: Source) -> NSManagedObject? {
        let predicate = NSPredicate(format: "sourceId = %@", source.id)
        return findFavoriteBy(predicate: predicate, for: source)
    }
    
    func findFavoriteByName(for source: Source) -> NSManagedObject? {
        let predicate = NSPredicate(format: "sourceName = %@", source.name)
        return findFavoriteBy(predicate: predicate, for: source)
    }
    
    func findAllFavorites() -> [NSManagedObject]? {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: favoriteEntityName)
        do {
            let result = try context.fetch(request)
            return result as? [NSManagedObject]
        } catch let error {
            print("Query error: \(error.localizedDescription)")
        }
        return nil
    }
    
    func deleteFavorite(for source: Source) {
        if let objectId = findFavoriteById(for: source)?.objectID {
            let request = NSBatchDeleteRequest(objectIDs: [objectId])
            
            do {
                try context.execute(request)
                save()
            }catch let error {
                print("Delete Error: \(error.localizedDescription)")
            }
        }
    }
    
    func isFavorite(source: Source) -> Bool {
        return findFavoriteById(for: source) != nil
    }
    
    func setFavorite(isFavorite: Bool, for source: Source) {
        if self.isFavorite(source: source) == isFavorite {
            return
        }
        if isFavorite {
            addFavorite(for: source)
        }else {
            deleteFavorite(for: source)
        }
    }
    
    func favorite(source: Source) {
        setFavorite(isFavorite: false, for: source)
    }
    
    func unFavorite(source: Source) {
        setFavorite(isFavorite: false, for: source)
    }
    
    func favoriteSourceIdAsString() -> String {
        let favorites = findAllFavorites()
        if let favorites = favorites {
            return favorites.map({$0.value(forKey: "sourceId") as! String}).filter({ !$0.isEmpty}).joined(separator: ",")
        }
        return ""
    }
}
