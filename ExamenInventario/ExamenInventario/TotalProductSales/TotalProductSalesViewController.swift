import UIKit

class TotalProductSalesViewController: UIViewController {
    
    @IBOutlet weak var productTable: UITableView!
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var totalSalesLbl: UILabel!
    
    var productArray = [SaleProduct]()
    let cellIdentifier = "ProductCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navBar.topItem?.title = "Total de Ventas"
        productTable.register(UINib(nibName: cellIdentifier, bundle: Bundle(for: TotalProductSalesViewController.self)), forCellReuseIdentifier: cellIdentifier)
        productTable.separatorStyle = .none
        _ = SQLiteDatabase.sharedInstance
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadData()
        sumTotal()
        productTable.reloadData()
    }
    
    private func loadData() {
        productArray = SQLiteCommands.presentRowsSale() ?? []
    }
    
    
    private func sumTotal() {
        var suma: Double = 0
        for value in productArray {
            suma += value.totalSale
        }
        self.totalSalesLbl.text = "Total Venta: $\(suma)"
    }
}


extension TotalProductSalesViewController: UITableViewDelegate, UITableViewDataSource {
    
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
