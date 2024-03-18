//
//  ContentView.swift
//  upc_barcode_scanner
//
//  Created by Ben Scanlan on 3/17/24.
//

//import SwiftUI
//
//struct ContentView: View {
//    var body: some View {
//        VStack {
//            Image(systemName: "globe")
//                .imageScale(.large)
//                .foregroundStyle(.tint)
//            Text("Hello, world!")
//        }
//        .padding()
//    }
//}
//
//#Preview {
//    ContentView()
//}


//import UIKit
//
//class MainViewController: UIViewController, DataScannerDelegate {
//    var dataScannerVC: DataScannerViewController!
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        // Initialize DataScannerViewController
//        dataScannerVC = DataScannerViewController()
//        dataScannerVC.delegate = self
//
//        // Add DataScannerViewController as child view controller
//        addChild(dataScannerVC)
//        view.addSubview(dataScannerVC.view)
//        dataScannerVC.view.frame = view.bounds
//        dataScannerVC.didMove(toParent: self)
//    }
//
//    // Implement delegate method to handle detected barcode
//    func didDetectBarcode(code: String) {
//        print("Detected barcode: \(code)")
//        // Handle UPC barcode
//        // You can perform appropriate action based on the detected barcode
//        // For example, you can display it in a label or perform a specific action
//    }
//}


import SwiftUI

@main
struct BarcodeScannerApp: App {
    var body: some Scene {
        WindowGroup {
            BarcodeScannerUIKitView()
        }
    }
}

struct BarcodeScannerUIKitView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIViewController {
        let mainViewController = MainViewController()
        return UINavigationController(rootViewController: mainViewController)
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        // Update the view controller if needed
    }
}
