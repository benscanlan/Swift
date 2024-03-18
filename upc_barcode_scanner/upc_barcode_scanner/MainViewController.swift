import UIKit

class MainViewController: UIViewController, DataScannerDelegate {
    var dataScannerVC: DataScannerViewController!

    override func viewDidLoad() {
        super.viewDidLoad()
        startScanning()
    }

    func startScanning() {
        dataScannerVC = DataScannerViewController()
        dataScannerVC.delegate = self
        addChild(dataScannerVC)
        view.addSubview(dataScannerVC.view)
        dataScannerVC.view.frame = view.bounds
        dataScannerVC.didMove(toParent: self)
    }

    func didDetectQRCode(payload: String) {
        print("Detected QR Code with payload: \(payload)")
        // Perform any action needed with the payload
    }
}

