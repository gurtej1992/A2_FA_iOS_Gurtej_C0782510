//
//  ProviderDetailVC.swift
//  A2_FA_iOS_Gurtej_C0782510
//
//  Created by Mac on 01/02/21.
//

import UIKit

class ProviderDetailVC: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        return cell
        
    }
}
