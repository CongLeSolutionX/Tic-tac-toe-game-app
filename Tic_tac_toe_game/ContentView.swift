//
//  ContentView.swift
//  Tic_tac_toe_game
//
//  Created by Cong Le on 1/29/24.
//

import SwiftUI

struct ContentView: View {
    // Represents the state of the board (empty, X, or O)
    @State private var board: [[String]] = Array(repeating: Array(repeating: "", count: 3), count: 3)
    // Indicates whether it's player X's turn (if false, it's player O's turn)
    @State private var isPlayerXTurn: Bool = true
    // Tracks whether the game is over
    @State private var gameOver: Bool = false
    // Stores the winning player's mark
    @State private var winningPlayer: String = ""
    
    var body: some View {
        VStack(spacing: 10) {
            Text("Tic Tac Toe")
                .font(.largeTitle)
            ForEach(0..<3) { row in
                HStack(spacing: 10) {
                    ForEach(0..<3) { column in
                        Button(action: {
                            // Process a tap only if the spot is empty and the game is not over
                            if self.board[row][column] == "" && !self.gameOver {
                                self.board[row][column] = self.isPlayerXTurn ? "X" : "O"
                                self.isPlayerXTurn.toggle()
                                self.checkForVictory()
                            }
                        }) {
                            Text(self.board[row][column])
                                .font(.system(size: 60))
                                .frame(width: 90, height: 90, alignment: .center)
                                .foregroundColor(.black)
                                .background(Color.white)
                                .cornerRadius(15)
                        }
                    }
                }
            }
            if gameOver {
                Text("Player \(winningPlayer) Wins!")
                    .font(.headline)
                    .padding()
                Button("Play Again", action: resetGame)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(15)
            }
        }
        .padding()
        .background(Color.gray)
    }
    
    // Checks for a victory and updates the game state
    private func checkForVictory() {
        // Check rows, columns, and diagonals for a win
        let lines = [
            // Rows
            [(0, 0), (0, 1), (0, 2)],
            [(1, 0), (1, 1), (1, 2)],
            [(2, 0), (2, 1), (2, 2)],
            // Columns
            [(0, 0), (1, 0), (2, 0)],
            [(0, 1), (1, 1), (2, 1)],
            [(0, 2), (1, 2), (2, 2)],
            // Diagonals
            [(0, 0), (1, 1), (2, 2)],
            [(0, 2), (1, 1), (2, 0)]
        ]
        
        for line in lines {
            let marks = line.map { self.board[$0.0][$0.1] }
            if marks.allSatisfy({ $0 == "X" }) {
                gameOver = true
                winningPlayer = "X"
                return
            } else if marks.allSatisfy({ $0 == "O" }) {
                gameOver = true
                winningPlayer = "O"
                return
            }
        }
        
        // Check for a tie
        if !board.flatMap({ $0 }).contains("") {
            gameOver = true
            winningPlayer = "Nobody"
        }
    }
    
    // Resets the game to the initial state
    private func resetGame() {
        board = Array(repeating: Array(repeating: "", count: 3), count: 3)
        isPlayerXTurn = true
        gameOver = false
        winningPlayer = ""
    }
}

#Preview {
    ContentView()
}
