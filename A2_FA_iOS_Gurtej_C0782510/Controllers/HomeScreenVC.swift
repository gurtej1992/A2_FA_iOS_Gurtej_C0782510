//
//  HomeScreenVC.swift
//  A2_FA_iOS_Gurtej_C0782510
//
//  Created by Mac on 01/02/21.
//

import UIKit
enum fetchType : String{
    case product = "product"
    case provider = "provider"
}
class HomeScreenVC: UIViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var homeTV: UITableView!
    @IBOutlet weak var searchBarHeight: NSLayoutConstraint!
    var arrProducts = [Products]()
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBarHeight.constant = 0
        fetchAddData()
    }
//    func fetchFromCoreData(for type : fetchType){
//        if type == .product{
//
//        }
//        else{
//
//        }
//    }
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
        return arrProducts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text =
            arrProducts[indexPath.row].productName
        cell.detailTextLabel?.text = arrProducts[indexPath.row].providers?.providerName
        return cell
    }
    
    
}
