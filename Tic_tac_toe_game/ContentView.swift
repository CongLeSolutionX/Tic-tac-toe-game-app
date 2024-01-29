//
//  ContentView.swift
//  Tic_tac_toe_game
//
//  Created by Cong Le on 1/29/24.
//

import SwiftUI
// ViewModel
class TicTacToeViewModel: ObservableObject {
    @Published var board: [[String]] = Array(repeating: Array(repeating: "", count: 3), count: 3)
    @Published var isPlayerXTurn: Bool = true
    @Published var gameOver: Bool = false
    @Published var winningPlayer: String = ""
    
    func processMove(at row: Int, and column: Int) {
        if board[row][column] == "" && !gameOver {
            board[row][column] = isPlayerXTurn ? "X" : "O"
            isPlayerXTurn.toggle()
            checkForVictory()
        }
    }
    
    func checkForVictory() {
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
        
        if !board.flatMap({ $0 }).contains("") {
            gameOver = true
            winningPlayer = "Nobody"
        }
    }
    
    func resetGame() {
        board = Array(repeating: Array(repeating: "", count: 3), count: 3)
        isPlayerXTurn = true
        gameOver = false
        winningPlayer = ""
    }
}

// Custom Grid Button View
struct GridButtonView: View {
    var title: String
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 60))
                .frame(width: 90, height: 90, alignment: .center)
                .foregroundColor(.black)
                .background(Color.white)
                .cornerRadius(15)
        }
    }
}

// Main View
struct ContentView: View {
    @ObservedObject var viewModel = TicTacToeViewModel()
    
    var body: some View {
        VStack(spacing: 10) {
            Text("Tic Tac Toe")
                .font(.largeTitle)
            ForEach(0..<3, id: \.self) { row in
                HStack(spacing: 10) {
                    ForEach(0..<3, id: \.self) { column in
                        GridButtonView(title: viewModel.board[row][column]) {
                            viewModel.processMove(at: row, and: column)
                        }
                    }
                }
            }
            if viewModel.gameOver {
                Text("Player \(viewModel.winningPlayer) Wins!")
                    .font(.headline)
                    .padding()
                Button("Play Again", action: viewModel.resetGame)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(15)
            }
        }
        .padding()
        .background(Color.gray)
    }
}

// MARK: - Preview
#Preview {
    ContentView()
}
