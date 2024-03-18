import SwiftUI
import AVFoundation

@main
struct BarcodeScannerApp: App {
    var body: some Scene {
        WindowGroup {
            BarcodeScannerView()
        }
    }
}

struct BarcodeScannerView: View {
    @StateObject var controller = BarcodeScannerController()

    var body: some View {
        VStack {
            if let scannedCode = controller.scannedCode {
                Text("Scanned Code: \(scannedCode)")
                    .padding()
            } else {
                Text("Scan a Barcode")
                    .padding()
            }
            Button("Scan") {
                controller.startScanning()
            }
            .padding()
        }
        .onAppear {
            controller.checkCameraPermission()
        }
    }
}

class BarcodeScannerController: NSObject, ObservableObject, AVCaptureMetadataOutputObjectsDelegate {
    @Published var scannedCode: String?
    private var captureSession: AVCaptureSession?

    override init() {
        super.init()
    }

    func checkCameraPermission() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            startScanning()
        case .notDetermined:
            requestCameraPermission()
        default:
            print("Camera access denied")
        }
    }

    private func requestCameraPermission() {
        AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
            if granted {
                self?.startScanning()
            } else {
                print("Camera access denied")
            }
        }
    }

    func startScanning() {
        guard let device = AVCaptureDevice.default(for: .video) else {
            print("Failed to get the camera device")
            return
        }

        do {
            let input = try AVCaptureDeviceInput(device: device)
            let captureSession = AVCaptureSession()
            captureSession.addInput(input)

            let metadataOutput = AVCaptureMetadataOutput()
            captureSession.addOutput(metadataOutput)
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.code128]

            self.captureSession = captureSession
            captureSession.startRunning()
        } catch {
            print("Error initializing video input: \(error.localizedDescription)")
        }
    }

    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        guard let metadataObject = metadataObjects.first as? AVMetadataMachineReadableCodeObject else {
            return
        }

        if let code = metadataObject.stringValue {
            scannedCode = code
        }
    }
}

