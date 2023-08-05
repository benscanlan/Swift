//
//  ContentView.swift
//  ASndorz assisitemnejbjge
//
//  Created by Ben Scanlan on 8/1/23.
//

import SwiftUI

struct Message: Identifiable {
    let id: UUID = UUID()
    let text: String
    let isMe: Bool
}

struct ContentView: View {
    @State private var messages: [Message] = [
        Message(text: "Hello!", isMe: false),
        Message(text: "Hi there!", isMe: true),
        Message(text: "How are you?", isMe: false),
    ]
    @State private var newMessage = ""

    var body: some View {
        VStack {
            List(messages) { message in
                MessageRow(message: message)
            }
            
            HStack {
                TextField("Type a message...", text: $newMessage)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Button(action: sendMessage) {
                    Text("Send")
                }
            }
            .padding()
        }
        .navigationBarTitle("Messaging App")
    }

    private func sendMessage() {
        if !newMessage.isEmpty {
            messages.append(Message(text: newMessage, isMe: true))
            newMessage = ""
        }
    }
}

struct MessageRow: View {
    let message: Message

    var body: some View {
        HStack {
            if message.isMe {
                Spacer()
            }

            Text(message.text)
                .padding(8)
                .background(message.isMe ? Color.blue : Color.gray)
                .foregroundColor(.white)
                .cornerRadius(10)

            if !message.isMe {
                Spacer()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
