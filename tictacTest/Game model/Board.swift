//
//  Board.swift
//  tictacTest
//
//  Created by Richard Urunuela on 29/09/2020.
//

import Foundation

import SwiftUI
import Combine
//@objc(Board)
class Board:NSObject,ObservableObject{
    var currentPlayer : Player

    @Published  var cells:[[Chip]] = [[.none,.none,.none],
                          [.none,.none,.none],
                          [.none,.none,.none]]
    
    override init(){
        self.currentPlayer = Player.redPlayer
        super.init()
    }
    func canMove(x:Int,y:Int) -> Bool {
        return  cells[y][x] == .none
    }
    override var debugDescription: String {
        var res = ""
        for y in 0...2 {
            for x in 0...2 {
               res = res + "|\(cells[y][x])"
                
            }
            res = res +  "\n"
        }
        return res
    }
    func setChip(chip:Chip,x:Int,y:Int)  {
        cells[y][x] = chip
    }
    func reset(){
        cells = [[.none,.none,.none],
                              [.none,.none,.none],
                              [.none,.none,.none]]
        self.currentPlayer = Player.redPlayer
    }
    func isTie()->Bool{
        if let winner = asWinner() { return false}
        var res = true
        for y in 0...2 {
            for x in 0...2 {
                if cells[y][x] == .none {return false}
            }
        }
        return res
        
    }
    
    func asWinner()->Player? {
        var winner:Chip?
        for line in 0...2 {
        if cells[0][line] ==  cells[1][line] &&
           cells[0][line] ==  cells[2][line] &&
            cells[0][line] !=  .none {
            winner = cells[0][line]
        }
        }
        for col in 0...2 {
        if cells[col][0] ==  cells[col][1] &&
           cells[col][0] ==  cells[col][2] &&
            cells[col][0] !=  .none {
            winner = cells[col][0]
        }
        }
        if cells[0][0] ==  cells[1][1] &&
           cells[0][0] ==  cells[2][2] &&
            cells[0][0] !=  .none {
            winner = cells[0][0]
        }
        if cells[0][2] ==  cells[1][1] &&
           cells[0][2] ==  cells[2][0] &&
            cells[0][2] !=  .none {
            winner = cells[0][2]
        }
        if let _chip = winner  {
            return Player.getPlayer(_chip)
        }
        return nil
    }
    func isFull() -> Bool {
        
        for y in 0...2 {
            for x in 0...2 {
                if cells[y][x] == .none {return false}
            }
        }
        return true
    }
}


