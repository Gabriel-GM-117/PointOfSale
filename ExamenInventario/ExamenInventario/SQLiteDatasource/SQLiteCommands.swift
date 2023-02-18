import Foundation
import SQLite

class SQLiteCommands {
    
    static var tableProducts = Table("products")
    static var tableSales = Table("sales")
    
    static let id = Expression<Int>("id")
    static let name = Expression<String>("name")
    static let count = Expression<Int>("cout")
    static let purchasePercentage = Expression<Double>("purchasePercentage")
    static let pricePurchase = Expression<Double>("pricepurchase")
    static let priceSale = Expression<Double>("pricesale")
    static let dateSale = Expression<String>("datesale")
    static let totalSale = Expression<Double>("totalsale")
    static let productId = Expression<Int>("producId")
    
    
    static func createTable() {
        guard let database = SQLiteDatabase.sharedInstance.database else {
            print("Datastore connection error")
            return
        }
        
        do {
            try database.run(tableProducts.create(ifNotExists: true) { table in
                table.column(id, primaryKey: true)
                table.column(name)
                table.column(count)
                table.column(purchasePercentage)
                table.column(pricePurchase)
                table.column(priceSale)
            })
        } catch {
            print("Table already exists: \(error)")
        }
    }
    
    static func createTableSale() {
        guard let database = SQLiteDatabase.sharedInstance.database else {
            print("Datastore connection error")
            return
        }
        
        do {
            try database.run(tableSales.create(ifNotExists: true) { table in
                table.column(id, primaryKey: true)
                table.column(name)
                table.column(count)
                table.column(priceSale)
                table.column(totalSale)
                table.column(dateSale)
                table.column(productId)
            })
        } catch {
            print("Table already exists: \(error)")
        }
    }
    

    static func insertRowProduct(_ productValues:DetailProduct) -> Bool? {
        guard let database = SQLiteDatabase.sharedInstance.database else {
            print("Datastore connection error")
            return nil
        }
        
        do {
            try database.run(tableProducts.insert(id <- productValues.productKey ,name <- productValues.productName, count <- 0, priceSale <- 0.0, pricePurchase <- 0.0, purchasePercentage <- productValues.purchasePercentage))
            return true
        } catch let Result.error(message, code, statement) where code == SQLITE_CONSTRAINT {
            print("Insert row failed: \(message), in \(String(describing: statement))")
            return false
        } catch let error {
            print("Insertion failed: \(error)")
            return false
        }
    }
    
    static func insertRowSale(_ productValues:SaleProduct) -> Bool? {
        guard let database = SQLiteDatabase.sharedInstance.database else {
            print("Datastore connection error")
            return nil
        }
        
        do {
            
            try database.run(tableSales.insert(productId <- productValues.productKey ,name <- productValues.productName, count <- productValues.amoun, priceSale <- productValues.priceSale, totalSale <- productValues.totalSale, dateSale <- productValues.dateSale))
            return true
        } catch let Result.error(message, code, statement) where code == SQLITE_CONSTRAINT {
            print("Insert row failed: \(message), in \(String(describing: statement))")
            return false
        } catch let error {
            print("Insertion failed: \(error)")
            return false
        }
    }
    
    static func updateRowProduct(_ productValues: DetailProduct) -> Bool? {
        guard let database = SQLiteDatabase.sharedInstance.database else {
            print("Datastore connection error")
            return nil
        }
        
        let product = tableProducts.filter(id == productValues.productKey).limit(1)
        
        let valuePercentage = productValues.purchasePercentage / 100
        let valuePriceSale = (valuePercentage * productValues.priceProduct) + productValues.priceProduct

        do {

            if try database.run(product.update(name <- productValues.productName, count <- productValues.amountProduct, pricePurchase <- productValues.priceProduct, priceSale <- valuePriceSale)) > 0 {
                return true
            } else {
                print("Could not update")
                return false
            }
        } catch let Result.error(message, code, statement) where code == SQLITE_CONSTRAINT {
            print("Update row faild: \(message), in \(String(describing: statement))")
            return false
        } catch let error {
            print("Updation failed: \(error)")
            return false
        }
    }
   
    static func presentRowsProducts() -> [DetailProduct]? {
        guard let database = SQLiteDatabase.sharedInstance.database else {
            print("Datastore connection error")
            return nil
        }
        
        var productArray = [DetailProduct]()
        
        tableProducts = tableProducts.order(id.desc)
        
        do {
            for product in try database.prepare(tableProducts) {
                
                let idValue = product[id]
                let nameValue = product[name]
                let countValue = product[count]
                let pricePurchaseValue = product[pricePurchase]
                let percentageValue = product[purchasePercentage]
                let priceSaleValue = product[priceSale]
        
                let productObject = DetailProduct(productName: nameValue, productKey: idValue, priceProduct: pricePurchaseValue, amountProduct: countValue, purchasePercentage: percentageValue, priceSale: priceSaleValue)
                
                productArray.append(productObject)
                
            }
        } catch {
            print("Present row error: \(error)")
        }
        return productArray
    }
    
    static func presentRowsSale() -> [SaleProduct]? {
        guard let database = SQLiteDatabase.sharedInstance.database else {
            print("Datastore connection error")
            return nil
        }
        
        var productArray = [SaleProduct]()
        
        tableSales = tableSales.order(id.asc)
        do {
            for sale in try database.prepare(tableSales) {
                
                let idValue = sale[productId]
                let nameValue = sale[name]
                let countValue = sale[count]
                let priceSaleValue = sale[priceSale]
                let dateSale = sale[dateSale]
                let totalSale = sale[totalSale]

                let productObject = SaleProduct(productName: nameValue, productKey: idValue, priceSale: priceSaleValue, amoun: countValue, totalSale: totalSale, dateSale: dateSale)
                
                productArray.append(productObject)
            }
        } catch {
            print("Present row error: \(error)")
        }
        return productArray
    }
    
    static func deleteRowProduct(productId: Int) {
        guard let database = SQLiteDatabase.sharedInstance.database else {
            print("Datastore connection error")
            return
        }
        
        do {
            let product = tableProducts.filter(id == productId).limit(1)
            try database.run(product.delete())
        } catch {
            print("Delete row error: \(error)")
        }
    }
}
