//
//  tictacTestTests.swift
//  tictacTestTests
//
//  Created by Richard Urunuela on 29/09/2020.
//

import XCTest
import GameKit
@testable import tictacTest

class tictacTestTests: XCTestCase {

    

    func testA() throws {
        let p1 = Player.redPlayer
        print(p1.debugDescription)
        let p2 = p1.opponent
        print(p2.debugDescription)
        
    }
    func testB() throws {
        let board = Board()
        board.setChip(chip: .red, x: 0, y: 0)
        board.setChip(chip: .red, x: 2, y: 0)
        print(board.debugDescription)
        board.setChip(chip: .red, x: 1, y:0)
        print(board.debugDescription)
        board.setChip(chip: .black, x: 0, y: 2)
        print(board.debugDescription)
        print(board.canMove(x: 0, y: 2))
        print(board.canMove(x: 2, y: 2))
        print(board.asWinner()?.debugDescription)
        print(board.isFull())
    }
   
    
    func testS(){
        let expectation = XCTestExpectation(description: "Download apple.com home page")

        
        let strategist = GKMinmaxStrategist()

        
        strategist.maxLookAheadDepth = 2
        
       
        
        let board = Board()
     
        board.cells =  [[.none,.none,.none],
                        [.black,.red,.none],
                        [.none,.red,.black]]
  
        strategist.gameModel = board
        board.currentPlayer = Player.blackPlayer
        print(board.debugDescription)
        /*let aiMove = strategist.bestMove(for: board.currentPlayer) as!Move?
        
        print("---> \(board.currentPlayer.chip)")
        print("---> \(aiMove.debugDescription)")
       /*
        board.currentPlayer = Player.redPlayer
        let aiMove2 = strategist.bestMove(for: board.currentPlayer) as!Move?
        print("---> \(board.currentPlayer.chip)")
        print("---> \(aiMove2.debugDescription)")
        */
        */
        DispatchQueue.global(qos: .default).async {
            let strategistTime = CFAbsoluteTimeGetCurrent()
            let aiMove2 = strategist.bestMove(for: board.currentPlayer) as!Move?
            let delta = CFAbsoluteTimeGetCurrent() - strategistTime
            
            let  aiTimeCeiling: TimeInterval = 2.0
            
          
            let delay = min(aiTimeCeiling - delta, aiTimeCeiling)
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+delay+2) {
                print("---> \(board.currentPlayer.chip)")
                print("---> \(aiMove2.debugDescription)")
                expectation.fulfill()
            }
        
        }
        wait(for: [expectation], timeout: 10.0)

    }
    
}
