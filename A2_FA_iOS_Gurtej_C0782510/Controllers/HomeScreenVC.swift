//
//  HomeScreenVC.swift
//  A2_FA_iOS_Gurtej_C0782510
//
//  Created by Mac on 01/02/21.
//

import UIKit
import CoreData
enum fetchType : String{
    case product = "product"
    case provider = "provider"
}
class HomeScreenVC: UIViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var homeTV: UITableView!
    @IBOutlet weak var searchBarHeight: NSLayoutConstraint!
    @IBOutlet weak var selectSeg: UISegmentedControl!
    var arrProducts = [Products]()
    var arrProviders = [Providers]()
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBarHeight.constant = 0
        fetchAddData()
    }
    func fetchFromCoreData(for type : fetchType){
        if type == .product{
            if let result = Helper.getProducts(){
                arrProducts  = result
            }
        }
        else{
            if let result = Helper.getProviders(){
                arrProviders  = result
            }
            
        }
        homeTV.reloadData()
    }
    override func viewWillAppear(_ animated: Bool) {
        handleSegChanged(selectSeg)
    }
    @IBAction func handleSegChanged(_ sender: UISegmentedControl) {
        fetchFromCoreData(for: sender.selectedSegmentIndex == 0 ? .product : .provider)
        
    }
    func fetchAddData(){
        if let result = Helper.getProducts(){
            arrProducts  = result
        }
        else{
            // Add Temp Data
            let provider = Providers(context: Helper.context)
            let provider2 = Providers(context: Helper.context)
            let provider3 = Providers(context: Helper.context)
            for i in 1...10{
                if i < 3{
                    let product = Products(context: Helper.context)
                    product.productID = "\(2000+i)"
                    product.productName = "Macbook \(product.productID!) Model"
                    product.productDesc = "Macbook \(product.productID!) Model, With ram \(product.productID!) GB"
                    product.productPrice = "$\(product.productID!)"
                    provider.providerName = "Apple"
                    product.providers = provider
                    
                }
                else if i > 3 && i < 7{
                    let product = Products(context: Helper.context)
                    product.productID = "\(2000+i)"
                    product.productName = "Surface \(product.productID!) Model"
                    product.productDesc = "Surface \(product.productID!) Model, With ram \(product.productID!) GB"
                    product.productPrice = "$\(product.productID!)"
                    provider2.providerName = "Micrsoft"
                    product.providers = provider2
                    
                }
                else{
                    let product = Products(context: Helper.context)
                    product.productID = "\(2000+i)"
                    product.productName = "Alienwere \(product.productID!) Model"
                    product.productDesc = "Alienwere \(product.productID!) Model, With ram \(product.productID!) GB"
                    product.productPrice = "$\(product.productID!)"
                    provider3.providerName = "Dell"
                    product.providers = provider3
                    
                }
            }
            Helper.saveDataToCoreData()
            fetchAddData()
        }
        homeTV.reloadData()
    }
    @IBAction func handleAdd(_ sender: Any) {
        if selectSeg.selectedSegmentIndex == 0 {
            let vc = storyboard?.instantiateViewController(identifier: Constants.ShowProductVC) as! ShowProductVC
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else{
            showInputDialog(title: "Add New Provider",
                            actionTitle: "Add",
                            cancelTitle: "Cancel",
                            inputPlaceholder: "Provider",
                            inputKeyboardType: .default, actionHandler:
                                { [self] (input:String?) in
                                    let req : NSFetchRequest<Providers> = Providers.fetchRequest()
                                    req.predicate = NSPredicate(format: "providerName = '\(input!)'")
                                    let storeProvider = try! Helper.context.fetch(req)
                                    if storeProvider.count == 0{
                                        let provider = Providers(context: Helper.context)
                                        provider.providerName = input
                                    }
                                    Helper.saveDataToCoreData()
                                    fetchFromCoreData(for: .provider)
                                    
                                })
            
        }
    }
    //MARK:-  Search Bar Handle
    @IBAction func handleSearch(_ sender: Any) {
        if searchBarHeight.constant == 0{
            searchBarHeight.constant = 56
        }
        else{
            searchBarHeight.constant = 0
        }
    }
    
}
extension HomeScreenVC : UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText != "" {
            
            arrProducts = arrProducts.filter({
                return ($0.productName!.lowercased().contains(searchText.lowercased())) || ($0.productDesc!.lowercased().contains(searchText.lowercased()))
            })
        }
        else{
            fetchAddData()
        }
        homeTV.reloadData()
    }
}
extension HomeScreenVC : UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectSeg.selectedSegmentIndex == 0 ? arrProducts.count : arrProviders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        if selectSeg.selectedSegmentIndex == 0{
            cell.textLabel?.text =
                arrProducts[indexPath.row].productName
            cell.detailTextLabel?.text = arrProducts[indexPath.row].providers?.providerName
        }
        else{
            cell.textLabel?.text = arrProviders[indexPath.row].providerName
            if let count = Helper.getProductsWithPredicate(predicate: NSPredicate(format: "providers.providerName = %@",arrProviders[indexPath.row].providerName!))?.count{
                cell.detailTextLabel?.text = "\(count)"
            }
            else{
                cell.detailTextLabel?.text = String(0)
            }
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if selectSeg.selectedSegmentIndex == 0 {
            let vc = storyboard?.instantiateViewController(identifier: Constants.ShowProductVC) as! ShowProductVC
            vc.product = arrProducts[indexPath.row]
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else{
            let vc = storyboard?.instantiateViewController(identifier: Constants.ProviderDetailVC) as! ProviderDetailVC
            vc.provider = arrProviders[indexPath.row]
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            if selectSeg.selectedSegmentIndex == 0{
                let objc = arrProducts[indexPath.row]
                Helper.context.delete(objc)
                Helper.saveDataToCoreData()
            }
            else{
                for product in arrProducts{
                    if product.providers?.providerName == arrProviders[indexPath.row].providerName{
                        Helper.context.delete(product)
                    }
                }
                Helper.context.delete(arrProviders[indexPath.row])
                Helper.saveDataToCoreData()
                
            }
            fetchFromCoreData(for: selectSeg.selectedSegmentIndex == 0 ? .product : .provider)
        }
    }
}
