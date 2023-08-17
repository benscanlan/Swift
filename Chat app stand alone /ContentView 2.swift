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
//import UIKit
//import SocketIO
//
//class ViewController: UIViewController {
//
//    @IBOutlet weak var messagesTextView: UITextView!
//    @IBOutlet weak var messageTextField: UITextField!
//
//    let socketManager = SocketManager(socketURL: URL(string: "http://localhost:3000")!)
//    var socket: SocketIOClient!
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        socket = socketManager.defaultSocket
//
//        // Receive new messages
//        socket.on("chatMessage") { [weak self] (data, _) in
//            guard let message = data.first as? String else { return }
//            self?.receiveMessage(message)
//        }
//
//        // Connect to the server
//        socket.connect()
//    }
//
//    @IBAction func sendMessage(_ sender: UIButton) {
//        guard let message = messageTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines), !message.isEmpty else {
//            return
//        }
//
//        // Send the message to the server
//        socket.emit("chatMessage", with: [message])
//        messageTextField.text = ""
//    }
//
//    func receiveMessage(_ message: String) {
//        messagesTextView.text += message + "\n"
//    }
//}
//import SwiftUI
//
//struct ContentView: View {
//    @State private var messageText: String = ""
//    @State private var messages: [String] = []
//
//    var body: some View {
//        VStack {
//            ScrollView {
//                VStack(alignment: .leading, spacing: 10) {
//                    ForEach(messages, id: \.self) { message in
//                        Text(message)
//                    }
//                }
//                .padding()
//            }
//
//            HStack {
//                TextField("Enter your message", text: $messageText)
//                    .textFieldStyle(RoundedBorderTextFieldStyle())
//                    .padding(.horizontal)
//
//                Button(action: sendMessage) {
//                    Text("Send")
//                        .padding(.horizontal)
//                }
//            }
//            .padding()
//        }
//    }
//
//    func sendMessage() {
//        guard !messageText.isEmpty else {
//            return
//        }
//
//        // Send the message to the server
//        // Add the logic here to send the message to the backend or socket server
//
//        // Add the message to the local list
//        messages.append(messageText)
//
//        // Clear the text field
//        messageText = ""
//    }
//}
//
//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}




//import SwiftUI
//
//struct ContentView: View {
//    @State private var messageText: String = ""
//    @State private var messages: [String] = []
//
//    var body: some View {
//        VStack {
//            ScrollView {
//                VStack(alignment: .leading, spacing: 10) {
//                    ForEach(messages, id: \.self) { message in
//                        Text(message)
//                    }
//                }
//                .padding()
//            }
//
//            HStack {
//                TextField("Enter your message", text: $messageText)
//                    .textFieldStyle(RoundedBorderTextFieldStyle())
//                    .padding(.horizontal)
//
//                Button(action: sendMessage) {
//                    Text("Send")
//                        .padding(.horizontal)
//                }
//            }
//            .padding()
//        }
//    }
//
//    func sendMessage() {
//        guard !messageText.isEmpty else {
//            return
//        }
//
//        // Send the message to the server
//        // Add the logic here to send the message to the backend or socket server
//
//        // Add the message to the local list
//        messages.append(messageText)
//
//        // Generate automated response
//        let automatedResponse = generateAutomatedResponse(for: messageText)
//        messages.append(automatedResponse)
//
//        // Clear the text field
//        messageText = ""
//    }
//
////    func generateAutomatedResponse(for message: String) -> String {
////        // Add your automated response logic here
////        // You can use if-else statements, switch statements, or any other condition-based logic
////
////        // Example automated response logic:
////        if message.lowercased().contains("") {
////            return "Hi! How can I assist you?"
////        } else if message.lowercased().contains("") {
////            return "Goodbye! Take care!"
////        } else {
////            return "Thank you for your message!"
////        }
////    }
//
//    func generateAutomatedResponse(for message: String) -> String {
//        let chatbotResponses = [
//            "Hi! How can I assist you?",
//            "Good morning! Have a great day!",
//            "Goodbye! Take care!",
//            "Thank you for your message!",
//            "Hi there! How may I help you?",
//            "Hey! What can I do for you?",
//            "Hello! How can I be of service?",
//            "Good to see you! How can I assist?",
//            "Greetings! How may I assist you today?",
//            "Hi! How can I help you today?",
//            "Good day! How may I assist you?",
//            "Hello there! What can I do for you?",
//            "Hi! How can I support you?",
//            "Welcome! How can I be of help?",
//            "Hey! How may I assist you today?",
//            "Goodbye! Take care and stay safe!",
//            "Hi! Feel free to ask any questions.",
//            "Hello! How can I assist you today?",
//            "Hi there! What brings you here?",
//            "Greetings! How may I be of assistance?",
//            "Hi! How can I support you today?",
//            "Goodbye! Take care and have a great day!",
//            "Hi! How may I assist you today?",
//            "Hello! How can I help you today?",
//            "Hi there! How may I be of service?",
//            "Good to see you! How can I assist today?",
//            "Greetings! How may I help you today?",
//            "Hi! How can I be of assistance today?",
//            "Hey there! What can I do for you?",
//            "Hi! How can I support you today?",
//            "Goodbye! Take care and stay well!",
//            "Hi! Feel free to ask me anything.",
//            "Hello! How can I assist you today?",
//            "Hi there! How can I help you?",
//            "Greetings! How may I assist you today?",
//            "Hi! How can I support you today?",
//            "Welcome! How can I be of service?",
//            "Hey! How can I assist you today?",
//            "Goodbye! Take care and have a wonderful day!",
//            "Hi! How may I assist you today?",
//            "Hello! How can I help you today?",
//            "Hi there! What brings you here today?",
//            "Greetings! How may I be of assistance?",
//            "Hi! How can I support you today?",
//            "Goodbye! Take care and stay safe out there!",
//            "Hi! Feel free to ask any questions you have.",
//            "Hello! How can I assist you today?",
//            "Hi there! How can I help you?",
//            "Hey! What brings you here today?",
//            "Welcome! How can I be of help?",
//            "Hi! How can I support you today?",
//            "Goodbye! Take care and have a fantastic day!",
//            "Hi! How may I assist you today?",
//            "Hello! How can I help you today?",
//            "Hi there! How may I be of service?",
//            "Greetings! How may I assist you today?",
//            "Hi! How can I be of assistance today?",
//            "Hey there! What can I do for you?",
//            "Hi! How can I support you today?",
//            "Goodbye! Take care and stay well!",
//            "Hi! Feel free to ask me anything.",
//            "Hello! How can I assist you today?",
//            "Hi there! How can I help you?",
//            "Greetings! How may I assist you today?",
//            "Hi! How can I support you today?",
//            "Welcome! How can I be of service?",
//            "Hey! How can I assist you today?", ]
//
//        let lowercasedMessage = message.lowercased()
//
//        if lowercasedMessage.contains("hello") || lowercasedMessage.contains("hi") {
//            return chatbotResponses[Int.random(in: 1..<66)]
//            //Int.random(in: 1..<99)
//            //return chatbotResponses.shuffle()
//        } else if lowercasedMessage.contains("good morning") {
//            return "Good morning! Have a great day!"
//        } else if lowercasedMessage.contains("goodbye") || lowercasedMessage.contains("bye") {
//            return "Goodbye! Take care!"
//        } else {
//            return "Thank you for your message!"
//        }
//    }
//
//
//}
//
//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}


import SwiftUI
import CoreML

struct ContentView: View {
    @State private var userInput = ""
    @State private var botResponse = ""
    
    let model = HelloWorldChatbot()
    
    var body: some View {
        VStack {
            Text("Chatbot")
                .font(.largeTitle)
                .padding()
            
            Text(botResponse)
                .padding()
            
            TextField("Your message", text: $userInput, onCommit: sendUserMessage)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
        }
    }
    
    func sendUserMessage() {
        botResponse = model.generateResponse(userInput)
        userInput = ""
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

class HelloWorldChatbot {
    let response = sendUserMessage()
    
    func generateResponse(_ userInput: String) -> String {
        return response
    }
}
