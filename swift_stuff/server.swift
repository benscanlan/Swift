import Foundation
import SwiftSocket

class Server {
    let serverPort: Int32 = 12345
    var server: TCPServer?
    var clientSockets = [Int32: TCPClient]()

    func start() {
        server = TCPServer(address: "localhost", port: serverPort)
        guard let server = server else { return }
        
        switch server.listen() {
        case .success:
            print("Server started on port \(serverPort)")
            runLoop()
        case .failure(let error):
            print("Error starting server: \(error)")
        }
    }

    func runLoop() {
        while true {
            if let client = server?.accept() {
                handleClient(client)
            }
        }
    }

    func handleClient(_ client: TCPClient) {
        let clientId = client.socketfd

        print("New client connected: \(clientId)")
        clientSockets[clientId] = client

        while true {
            if let data = client.read(1024) {
                let message = String(bytes: data, encoding: .utf8) ?? ""
                print("Received message from \(clientId): \(message)")
                broadcastMessage(message, from: clientId)
            } else {
                disconnectClient(clientId)
                break
            }
        }
    }

    func broadcastMessage(_ message: String, from clientId: Int32) {
        for (id, client) in clientSockets {
            if id != clientId {
                client.send(string: message)
            }
        }
    }

    func disconnectClient(_ clientId: Int32) {
        clientSockets.removeValue(forKey: clientId)
        print("Client \(clientId) disconnected.")
    }
}

let server = Server()
server.start()

