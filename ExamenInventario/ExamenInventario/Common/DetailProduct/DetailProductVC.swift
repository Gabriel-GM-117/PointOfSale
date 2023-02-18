import UIKit

class DetailProductVC: UIViewController {
    
    
    @IBOutlet weak var dateDetailLbl: UILabel!
    @IBOutlet weak var productNameLbl: UILabel!
    @IBOutlet weak var productKeyLbl: UILabel!
    @IBOutlet weak var priceProductLbl: UILabel!
    @IBOutlet weak var amountStp: UIStepper!
    @IBOutlet weak var amountLbl: UILabel!
    @IBOutlet weak var totalSaleLbl: UILabel!
    @IBOutlet weak var finishDetailBtn: UIButton!
    
    @IBOutlet weak var txtPricePurchase: UITextField!
    private var flow: Int?
    private var dataModel: DetailProduct?
    private let titleFlow1 = "Compras"
    private let titleFlow2 = "Venta"

    init(flow: Int, data: DetailProduct) {
        super.init(nibName: "DetailProductVC", bundle: nil)
        self.flow = flow
        self.dataModel = data
    }
    
    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
        createTable()
    }
    
    internal func dateTime() -> String {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let text = dateFormatter.string(from: date)
        return text
    }
    
    private func createTable() {
            let database = SQLiteDatabase.sharedInstance
            database.createTableSale()
        }
    
    private func configView() {
        dateDetailLbl.text = dateTime()
        if flow == 1 {
            navigationItem.title = titleFlow1
            finishDetailBtn.setTitle("Comprar", for: .normal)
            productNameLbl.text = dataModel?.productName
            productKeyLbl.text = "\(dataModel?.productKey ?? 0)"
            priceProductLbl.text = "\(dataModel?.priceProduct ?? 0.0)"
            totalSaleLbl.text = "\(dataModel?.priceProduct ?? 0.0)"
            txtPricePurchase.isHidden = false
            priceProductLbl.isHidden = true
            amountStp.minimumValue = 1
            amountStp.maximumValue =  100
        } else {
            navigationItem.title = titleFlow2
            finishDetailBtn.setTitle("Vender", for: .normal)
            productNameLbl.text = dataModel?.productName
            productKeyLbl.text = "\(dataModel?.productKey ?? 0)"
            priceProductLbl.text = "\(dataModel?.priceProduct ?? 0.0)"
            totalSaleLbl.text = "\(dataModel?.priceProduct ?? 0.0)"
            txtPricePurchase.isHidden = true
            priceProductLbl.isHidden = false
            configStepper()
        }
    }
    
    private func configStepper() {
        amountStp.minimumValue = 1
        amountStp.maximumValue =  Double(dataModel!.amountProduct)
    }
    
    private func additionTotal() {
        if flow == 1 {
            let sum = amountStp.value * (Double(txtPricePurchase!.text ?? "") ?? 0.0)
            totalSaleLbl.text = "\(sum)"
        }
        else {
            let sum = amountStp.value * (dataModel?.priceProduct ?? 0.0)
            totalSaleLbl.text = "\(sum)"
        }
    }


    @IBAction func amountStepperAction(_ sender: Any) {
        let value = Int(amountStp.value)
        amountLbl.text = "\(value)"
        additionTotal()
    }
    
    
    private func updateProduct(_ productValues: DetailProduct) {
            let productUpdatedInTable = SQLiteCommands.updateRowProduct(productValues)
            
            if productUpdatedInTable == true {
                if let cellClicked = navigationController {
                    cellClicked.popViewController(animated: true)
                }
            } else {
                //showError("Error", message: "")
            }
        }
    
    private func createProductSale(_ productValues: SaleProduct) {
            let productAddedToTable = SQLiteCommands.insertRowSale(productValues)
            
            if productAddedToTable == true {
                dismiss(animated: true, completion: nil)
            } else {
                //showError("Error", message: "")
            }
        }
    
    @IBAction func saveActionButton(_ sender: Any) {
        if flow == 1 {
            let price = (Double(txtPricePurchase!.text ?? "") ?? 0.0)
            let productValues = DetailProduct(productName: dataModel!.productName, productKey: dataModel!.productKey, priceProduct: price, amountProduct: (dataModel!.amountProduct + Int(amountStp.value)), purchasePercentage: dataModel!.purchasePercentage, priceSale: 0.0)
            
            updateProduct(productValues)
            
            self.dismiss(animated: true)
        }
        else {
     
            let totalValue = (Double(totalSaleLbl.text ?? "") ?? 0.0)
            let productValues = SaleProduct(productName: dataModel!.productName, productKey: dataModel!.productKey, priceSale: dataModel!.priceProduct, amoun: Int(amountStp.value), totalSale: totalValue, dateSale: dateTime())
                    
            createProductSale(productValues)
            let productUpdateValues = DetailProduct(productName: dataModel!.productName, productKey: dataModel!.productKey, priceProduct: dataModel!.priceProduct, amountProduct: dataModel!.amountProduct - Int(amountStp.value), purchasePercentage: dataModel!.purchasePercentage, priceSale: dataModel!.priceSale)
            
            updateProduct(productUpdateValues)
            
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
}
