import UIKit

class ProductSaleVC: UIViewController {
    
    @IBOutlet weak var productTable: UITableView!
    
    var productArray = [DetailProduct]()
    let detailCellIdentifier = "ProductCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        productTable.register(UINib(nibName: detailCellIdentifier, bundle: Bundle(for: ProductPurchaseVC.self)), forCellReuseIdentifier: detailCellIdentifier)
        productTable.separatorStyle = .none
        navigationItem.title = "Venta"
        _ = SQLiteDatabase.sharedInstance
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadData()
        productTable.reloadData()
    }
    
    private func loadData() {
        productArray = SQLiteCommands.presentRowsProducts() ?? []
    }

}


extension ProductSaleVC: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.productArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: detailCellIdentifier, for: indexPath) as? ProductCell else { return UITableViewCell() }
        cell.selectionStyle = .none
        
        let proudut = productArray[indexPath.row]
        cell.flowDetail = 2
        cell.setData(proudut, vc: self)
        return cell
    }
}
