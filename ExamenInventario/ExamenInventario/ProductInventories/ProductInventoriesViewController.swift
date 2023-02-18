import UIKit

class ProductInventoriesViewController: UIViewController {
    
    @IBOutlet weak var productTable: UITableView!
    @IBOutlet weak var navBar: UINavigationBar!
    

    var productArray = [DetailProduct]()
    let cellIdentifier = "ProductCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navBar.topItem?.title = "Inventario"
        productTable.register(UINib(nibName: cellIdentifier, bundle: Bundle(for: ProductInventoriesViewController.self)), forCellReuseIdentifier: cellIdentifier)
        productTable.separatorStyle = .none
        _ = SQLiteDatabase.sharedInstance
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        loadData()
        productTable.reloadData()
    }

    private func loadData() {
        productArray = SQLiteCommands.presentRowsProducts() ?? []
    }

}

extension ProductInventoriesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.productArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ProductCell else { return UITableViewCell() }
        cell.selectionStyle = .none
        
        let product = productArray[indexPath.row]
        cell.setData(product)
        return cell
    }
}
