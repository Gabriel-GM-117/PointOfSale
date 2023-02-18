import UIKit

class ViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        _ = SQLiteDatabase.sharedInstance
    }


}

