import UIKit

class ProductCell: UITableViewCell {

    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var productNameLbl: UILabel!
    @IBOutlet weak var productKeyLbl: UILabel!
    @IBOutlet weak var titlePriceProudctLbl: UILabel!
    @IBOutlet weak var priceProductLbl: UILabel!
    @IBOutlet weak var viewBtn: UIView!
    @IBOutlet weak var detailProductBtn: UIButton!
    
    var flowDetail: Int?
    private var viewController: UIViewController?
    private var dataModelFlowOne: DetailProduct?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.cellView.clipsToBounds = false
        self.cellView.layer.cornerRadius = 8.0
        self.cellView.layer.shadowRadius = 2
        self.cellView.layer.shadowOffset = CGSize(width: 0, height: 3)
        self.cellView.layer.shadowOpacity = 0.2
        self.cellView.layer.shadowColor = UIColor(hexString: "#050609").cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setData(_ product: DetailProduct, vc: UIViewController) {
        self.viewController = vc
        self.dataModelFlowOne = product
        self.productNameLbl.text = product.productName
        self.productKeyLbl.text = "\(product.productKey)"
        self.priceProductLbl.text = self.flowDetail == 1 ? "\(product.priceProduct)" : "\(product.priceSale)"
        let buttonTitle = self.flowDetail == 1 ? "Compras" : "Ventas"
        self.detailProductBtn.setTitle(buttonTitle, for: .normal)
    }
    
    func setData(_ product: DetailProduct) {
        self.productNameLbl.text = product.productName
        self.productKeyLbl.text = "\(product.productKey)"
        self.titlePriceProudctLbl.text = "Existencias:"
        self.priceProductLbl.text = String(product.amountProduct)
        self.viewBtn.isHidden = true
    }
    
    func setData(_ product: SaleProduct) {
        self.productNameLbl.text = product.productName
        self.productKeyLbl.text = "\(product.productKey)"
        self.titlePriceProudctLbl.text = "Total de ventas:"
        self.priceProductLbl.text = String(product.totalSale)
        self.viewBtn.isHidden = true
    }
    
    @IBAction func buttonCellAction(_ sender: Any) {
        if flowDetail == 1 {
            guard let view = self.viewController else { return }
            let vc = DetailProductVC(flow: flowDetail!, data: dataModelFlowOne!)
            view.navigationController?.pushViewController(vc, animated: true)
        } else {
            guard let view = self.viewController else { return }
            let vc = DetailProductVC(flow: flowDetail!, data: dataModelFlowOne!)
            view.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
