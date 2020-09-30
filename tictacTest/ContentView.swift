//https://github.com/valvoline/SwiftUI-TicTacToe/blob/master/TicTacToe/ContentView.swift
import SwiftUI
import Combine
import GameplayKit
enum SquareStatus {
    case empty
    case visitor
    case home
}

struct Symbol :View {
    var name:String
    var body: some View {
        Image(systemName: name).resizable().padding(10).frame(width: 80, height:80, alignment: .center).foregroundColor(name != "plus.square" ? .white:Color.gray.opacity(60)).background(Rectangle().fill(Color.gray.opacity(60)).frame(width: 80, height: 80)).cornerRadius(10)
        
    }
}

struct SquareView: View {
    @ObservedObject var dataSource:Board
    var x:Int
    var y:Int
    var action: () -> Void
    var body: some View {
        Button(action: {
            self.action()
        }) {
            Symbol(name: dataSource.cells[y][x] == .red ? "multiply" : dataSource.cells[y][x] == .black ? "circle" : "plus.square" )/*
            Text(dataSource.cells[y][x] == .red ? "R" :dataSource.cells[y][x] == .black ? "B" : " " )
                .font(.largeTitle)
                .foregroundColor(Color.black.opacity(50))
                .frame(minWidth: 80, minHeight: 80)
                .background(Color.gray)
                .cornerRadius(10)
                .padding(EdgeInsets(top:1, leading: 1, bottom: 1, trailing: 1))*/
        }
    }
}

struct ContentView : View {
    //private var checker = ModelBoard()
    @State private var showingAlert = false
    @State private var message = ""
    private var checker = Board()
    let strategist = GKMinmaxStrategist()

    

    @State private var isGameOver = false
    func checkWinner(){
        if checker.isWin(for: Player.redPlayer) {
            self.message = " You win "
            showingAlert = true
            
        }
        if  checker.isWin(for: Player.blackPlayer) {
            self.message = " You loose "
            showingAlert = true
            
        }
        //tie
        if  checker.isTie() {
            self.message = "It was a draw"
            showingAlert = true
            
        }
    }
    
    func buttonAction(_ x: Int,_ y: Int) {
         guard  checker.canMove(x: x, y: y) else {
            return
        }
        //Check if win
        
        
        checker.cells[y][x] = checker.currentPlayer.chip
        checkWinner()
        checker.currentPlayer = checker.currentPlayer.opponent
        if (checker.currentPlayer.chip == .black) {
            DispatchQueue.global(qos: .default).async {
                //Computer
                strategist.maxLookAheadDepth = 7
                //strategist.randomSource = GKARC4RandomSource()
                strategist.gameModel = checker

                DispatchQueue.global(qos: .default).async {
                    let strategistTime = CFAbsoluteTimeGetCurrent()
                    let aiMove2 = strategist.bestMove(for: checker.currentPlayer) as!Move?
                    let delta = CFAbsoluteTimeGetCurrent() - strategistTime
                    
                    let  aiTimeCeiling: TimeInterval = 2.0
                    
                  
                    let delay = min(aiTimeCeiling - delta, aiTimeCeiling)
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+delay) {
                        if let  aiMove2 = aiMove2 {
                        checker.cells[aiMove2.y][aiMove2.x] = checker.currentPlayer.chip
                            
                        }
                        checkWinner()
                        checker.currentPlayer = checker.currentPlayer.opponent
                    }
                
                }
                
                
                
            
            }
            
            
            
        }
        
    }
    
    var body: some View {
        VStack {
            HStack {
                SquareView(dataSource: checker,x: 0,y: 0) { self.buttonAction(0,0) }
                SquareView(dataSource: checker,x: 1,y: 0) { self.buttonAction(1,0) }
                SquareView(dataSource: checker,x: 2,y: 0) { self.buttonAction(2,0) }
            }
            HStack {
                SquareView(dataSource: checker,x: 0,y: 1 ) { self.buttonAction(0,1) }
                SquareView(dataSource: checker,x: 1,y: 1 ) { self.buttonAction(1,1) }
                SquareView( dataSource: checker,x: 2,y: 1) { self.buttonAction(2,1) }
            }
            HStack {
                SquareView(dataSource: checker,x: 0,y: 2 ) { self.buttonAction(0,2) }
                SquareView(dataSource: checker,x: 1,y: 2 ) { self.buttonAction(1,2) }
                SquareView(dataSource: checker,x: 2,y: 2 ) { self.buttonAction(2,2) }
            }
            }
        
        
        Button(action: {
            checker.reset()
        }) { Image(systemName: "arrow.clockwise.circle").resizable().padding(10).frame(width: 60, height:60, alignment: .center).foregroundColor(.white).background(Circle()
                                                                                                                                                            .fill(Color.red)
                                                                                                                                                            .frame(width: 200, height: 200))
                                                                                                                                                            .clipped().cornerRadius(10)
        }.padding(10).alert(isPresented: $showingAlert) {
            Alert(title: Text(message), message: Text("continue ?"), dismissButton: .destructive(Text("Ok")){
                checker.reset()
            })
        }

        
            
        }

    
}

