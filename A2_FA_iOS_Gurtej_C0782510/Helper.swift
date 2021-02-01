//
//  Helper.swift
//  A2_FA_iOS_Gurtej_C0782510
//
//  Created by Mac on 01/02/21.
//

import UIKit
import CoreData

class Helper: NSObject {
    static let context =
        (UIApplication.shared.delegate as! AppDelegate)
        .persistentContainer.viewContext
    
    static func getProducts() -> [Products]?{
        var product = [Products]()
        do {
            product =  try context.fetch(Products.fetchRequest())
        } catch  {
            return nil
        }
        return product.count == 0 ? nil : product
    }
    static func getProviders()-> [Providers]?{
        do {
            return try context.fetch(Providers.fetchRequest())
        } catch  {
            return nil
        }
    }
    static func getProductsWithPredicate(predicate : NSPredicate) -> [Products]?{
        var product = [Products]()
        let req : NSFetchRequest<Products> = Products.fetchRequest()
        req.predicate = predicate
        do {
            product =  try context.fetch(req)
        } catch  {
            return nil
        }
        return product.count == 0 ? nil : product
    }
    static func saveDataToCoreData(){
        do {
            try context.save()
        } catch  {
            
        }
    }
}
