import UIKit

class ProductRegistrationViewController: UIViewController {

    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var productNameTxf: UITextField!
    @IBOutlet weak var productKeyTxf: UITextField!
    @IBOutlet weak var purchasePercentageTxf: UITextField!
    @IBOutlet weak var productRegistrationBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navBar.topItem?.title = "Registro de Productos"
        createTable()
    }
    
    private func createTable() {
        let database = SQLiteDatabase.sharedInstance
        database.createTable()
    }
    
    
    private func createNewProduct(_ productValues:DetailProduct) {
        let productAddedToTable = SQLiteCommands.insertRowProduct(productValues)
        
        if productAddedToTable == true {
            let alert = UIAlertController(title: "Registro Exitoso", message: "Sea registrado el producto con exito", preferredStyle: .alert)
            let actionGoToSettings = UIAlertAction(title: "Aceptar", style: .default) { _ in
                self.dismiss(animated: true, completion: nil)
            }
            alert.addAction(actionGoToSettings)
            present(alert, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Error de Registro", message: "No se ha podido registrar el producto", preferredStyle: .alert)
            let actionGoToSettings = UIAlertAction(title: "Aceptar", style: .default) { _ in
                self.dismiss(animated: true, completion: nil)
            }
            alert.addAction(actionGoToSettings)
            present(alert, animated: true, completion: nil)
        }
    }
    
    
    @IBAction func productRegistrationAtion(_ sender: Any) {
        var id = 0
        let percentage = Double(purchasePercentageTxf.text ?? "") ?? 0.0
        if let string = productKeyTxf.text, let myInt = Int(string) {
             id = myInt
        }
        let name = productNameTxf.text ?? ""

        let productValues = DetailProduct(productName: name, productKey: id, priceProduct: 0.0, amountProduct: 0, purchasePercentage: percentage, priceSale: 0.0)
                
        createNewProduct(productValues)
        
        productNameTxf.text = ""
        productKeyTxf.text = ""
        purchasePercentageTxf.text = ""
    }
}
