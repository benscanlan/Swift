//
//  DataScannerViewController.swift
//  upc_barcode_scanner
//
//  Created by Ben Scanlan on 3/17/24.
//

//import Foundation
//@MainActor @objc
//class DataScannerViewController

import UIKit
import AVFoundation

protocol DataScannerDelegate: AnyObject {
    func didDetectBarcode(code: String)
}

class DataScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    weak var delegate: DataScannerDelegate?
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Setup camera capture session
        captureSession = AVCaptureSession()

        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        let videoInput: AVCaptureDeviceInput

        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }

        if (captureSession.canAddInput(videoInput)) {
            captureSession.addInput(videoInput)
        } else {
            // Handle failure to add input
            return
        }

        let metadataOutput = AVCaptureMetadataOutput()

        if (captureSession.canAddOutput(metadataOutput)) {
            captureSession.addOutput(metadataOutput)

            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.upce, .code39, .code93, .code128, .code39Mod43, .ean8, .ean13]
        } else {
            // Handle failure to add output
            return
        }

        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)

        captureSession.startRunning()
    }

    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        captureSession.stopRunning()

        for metadata in metadataObjects {
            guard let readableObject = metadata as? AVMetadataMachineReadableCodeObject else { continue }
            guard let stringValue = readableObject.stringValue else { continue }

            // Handle different types of detected codes
            delegate?.didDetectBarcode(code: stringValue)
            break // Break after detecting the first code
        }
    }
}

