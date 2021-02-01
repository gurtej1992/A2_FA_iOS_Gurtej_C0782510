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
    static func getProvidersWithPredicate(predicate : NSPredicate) -> [Providers]?{
        var providers = [Providers]()
        let req : NSFetchRequest<Providers> = Providers.fetchRequest()
        req.predicate = predicate
        do {
            providers =  try context.fetch(req)
        } catch  {
            return nil
        }
        return providers.count == 0 ? nil : providers
    }
    static func saveDataToCoreData(){
        do {
            try context.save()
        } catch  {
            
        }
    }
}
// Took refrence from internet.
extension UIViewController {
    func showInputDialog(title:String? = nil,
                         subtitle:String? = nil,
                         actionTitle:String? = "Add",
                         cancelTitle:String? = "Cancel",
                         inputPlaceholder:String? = nil,
                         inputKeyboardType:UIKeyboardType = UIKeyboardType.default,
                         cancelHandler: ((UIAlertAction) -> Swift.Void)? = nil,
                         actionHandler: ((_ text: String?) -> Void)? = nil) {
        
        let alert = UIAlertController(title: title, message: subtitle, preferredStyle: .alert)
        alert.addTextField { (textField:UITextField) in
            textField.placeholder = inputPlaceholder
            textField.keyboardType = inputKeyboardType
        }
        alert.addAction(UIAlertAction(title: actionTitle, style: .default, handler: { (action:UIAlertAction) in
            guard let textField =  alert.textFields?.first else {
                actionHandler?(nil)
                return
            }
            actionHandler?(textField.text)
        }))
        alert.addAction(UIAlertAction(title: cancelTitle, style: .cancel, handler: cancelHandler))
        
        self.present(alert, animated: true, completion: nil)
    }
}
