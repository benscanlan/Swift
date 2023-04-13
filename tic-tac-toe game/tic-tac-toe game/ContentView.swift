import SwiftUI

struct ContentView: View {
    @State private var currentPlayer = "X"
    @State private var gameBoard = Array(repeating: "", count: 9)
    @State private var gameEnded = false
    @State private var winner = ""
    
    var body: some View {
        VStack(spacing: 0) {
            Text("Tic Tac Toe")
                .font(.largeTitle)
                .padding()
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 5) {
                ForEach(0..<9) { index in
                    Button(action: {
                        self.playMove(at: index)
                    }, label: {
                        Text(gameBoard[index])
                            .font(.system(size: 60))
                            .foregroundColor(.black)
                            .frame(width: 80, height: 80)
                            .background(Color.white)
                            .border(Color.black, width: 2)
                    })
                }
            }
            .padding()
            if gameEnded {
                if winner == "" {
                    Text("It's a draw!")
                        .font(.title)
                        .padding()
                } else {
                    Text("\(winner) wins!")
                        .font(.title)
                        .padding()
                }
                Button(action: {
                    self.resetGame()
                }, label: {
                    Text("Play Again")
                        .font(.title2)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                })
            }
        }
    }
    
    func playMove(at index: Int) {
        if gameBoard[index] == "" && !gameEnded {
            gameBoard[index] = currentPlayer
            if checkWin(for: currentPlayer, in: gameBoard) {
                gameEnded = true
                winner = currentPlayer
            } else if !gameBoard.contains("") {
                gameEnded = true
            } else {
                currentPlayer = currentPlayer == "X" ? "O" : "X"
            }
        }
    }
    
    func checkWin(for player: String, in gameBoard: [String]) -> Bool {
        let winningPatterns: Set<Set<Int>> = [
            [0, 1, 2], [3, 4, 5], [6, 7, 8],
            [0, 3, 6], [1, 4, 7], [2, 5, 8],
            [0, 4, 8], [2, 4, 6]
        ]
        
        for pattern in winningPatterns {
            let moves = pattern.map { gameBoard[$0] }
            if moves == [player, player, player] {
                return true
            }
        }
        
        return false
    }
    
    func resetGame() {
        currentPlayer = "X"
        gameBoard = Array(repeating: "", count: 9)
        gameEnded = false
        winner = ""
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

