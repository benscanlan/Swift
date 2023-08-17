//
//  ContentView.swift
//  Message App
//
//  Created by Karen Copenhaver on 7/5/23.
//

//import SwiftUI
//
//struct ContentView: View {
//    var body: some View {
//        Text("Hello, world!")
//            .padding()
//    }
//}
//
//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
import UIKit
import SocketIO

class ViewController: UIViewController {

    @IBOutlet weak var messagesTextView: UITextView!
    @IBOutlet weak var messageTextField: UITextField!

    let socketManager = SocketManager(socketURL: URL(string: "http://localhost:3000")!)
    var socket: SocketIOClient!

    override func viewDidLoad() {
        super.viewDidLoad()

        socket = socketManager.defaultSocket

        // Receive new messages
        socket.on("chatMessage") { [weak self] (data, _) in
            guard let message = data.first as? String else { return }
            self?.receiveMessage(message)
        }

        // Connect to the server
        socket.connect()
    }

    @IBAction func sendMessage(_ sender: UIButton) {
        guard let message = messageTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines), !message.isEmpty else {
            return
        }

        // Send the message to the server
        socket.emit("chatMessage", with: [message])
        messageTextField.text = ""
    }

    func receiveMessage(_ message: String) {
        messagesTextView.text += message + "\n"
    }
}
