//
//  ContentView.swift
//  socket app
//
//  Created by Ben Scanlan on 7/5/23.
//

//import SwiftUI
//
//struct ContentView: View {
//    var body: some View {
//        VStack {
//            Image(systemName: "globe")
//                .imageScale(.large)
//                .foregroundColor(.accentColor)
//            Text("Hello, world!")
//        }
//        .padding()
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
        
        
        //socket.emit("chatMessage", with: [message])
        
        messageTextField.text = ""
    }

    func receiveMessage(_ message: String) {
        messagesTextView.text += message + "\n"
    }
}


import UIKit
import CoreML
import NaturalLanguage

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Text to analyze
        let text = "Hello, World!"
        
        // Tokenizing the text
        let tokenizer = NLTokenizer(unit: .word)
        tokenizer.string = text
        let tokens = tokenizer.tokens(for: text.startIndex..<text.endIndex)
        
        // Analyzing the tokens
        let tagger = NLTagger(tagSchemes: [.lexicalClass])
        tagger.string = text
        
        for token in tokens {
            let tokenRange = token.range
            let tokenString = String(text[tokenRange])
            
            tagger.setLanguage(.english, range: tokenRange)
            let tag = tagger.tag(at: tokenRange.lowerBound, unit: .word, scheme: .lexicalClass)
            
            print("\(tokenString): \(tag?.rawValue ?? "")")
        }
        
        // Loading the CoreML model
        guard let sentimentModel = try? NLModel(mlModel: MySentimentModel().model) else {
            fatalError("Failed to load CoreML model")
        }
        
        // Analyzing sentiment using the CoreML model
        let sentiment = sentimentModel.predictedLabel(for: text)
        
        print("Sentiment: \(sentiment ?? "")")
    }
}
