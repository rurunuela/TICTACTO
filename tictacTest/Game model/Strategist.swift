//
//  Strategist.swift
//  tictacTest
//
//  Created by Richard Urunuela on 29/09/2020.
//

import Foundation

import GameplayKit

class Move:NSObject,GKGameModelUpdate{
    var value: Int = 0
    var x = 0
    var y = 0
    
    init (x:Int, y: Int ) {
        self.x = x
        self.y = y
    }
    class func moveInCell(x:Int, y: Int )->Move {
        return Move(x: x, y: y)
    }
       
    override var debugDescription: String {
        get{
            return ("\(y):\(x)")
        }
    }
    
    
      
}
extension Player: GKGameModelPlayer {
    
    var playerId: Int {
        return self.chip.rawValue
    }
    
}

extension Board: GKGameModel {
    
    
    var players: [GKGameModelPlayer]? {
        return Player.Players
    }
   var activePlayer: GKGameModelPlayer? {
        return self.currentPlayer
    }
    func copy(with zone: NSZone? = nil) -> Any {
        
        let copy = Board()
        copy.setGameModel(self)
        return copy
    }
    func setGameModel(_ gameModel: GKGameModel) {
        let model = gameModel as! Board
        self.updateChipsFromBoard(model)
        self.currentPlayer = model.currentPlayer
    }
    
    func updateChipsFromBoard(_ otherBoard: Board) {
        
        self.cells = otherBoard.cells
    }
    
    func gameModelUpdates(for player: GKGameModelPlayer) -> [GKGameModelUpdate]? {
        var moves: [Move] = [Move]()
        
        for y in 0...2 {
            for x in 0...2 {
                if self.canMove(x: x, y: y) {
                    moves.append(Move.moveInCell(x: x, y: y))
                }
            }
        }
        //print("Moves :  \(moves)")
        //print(" -------------------- ")

        return moves
    }
    func unapplyGameModelUpdate(_ gameModelUpdate: GKGameModelUpdate) {
        let update = gameModelUpdate as! Move
        
        self.setChip(chip: .none, x: update.x, y: update.y)
        self.currentPlayer = self.currentPlayer.opponent
        
    }
    func apply(_ gameModelUpdate: GKGameModelUpdate) {
        let update = gameModelUpdate as! Move
        
        self.setChip(chip: self.currentPlayer.chip, x: update.x, y: update.y)
        /*if isWin(for: Player.blackPlayer) { update.value = 20 }
        if isWin(for: Player.redPlayer) { update.value =  -10}*/
        
        //print(":: \(update.x):\(update.x) \(update.value)")
        self.currentPlayer = self.currentPlayer.opponent
        
    }
    
    func isWin(for player: GKGameModelPlayer) -> Bool {
       
        let thePlayer = player as! Player
        return (self.asWinner()?.chip == thePlayer.chip)
        
    }
    func isLoss(for player: GKGameModelPlayer) -> Bool {
        // This is a two-player game, so a win for the opponent is a loss for the player.
        let thePlayer = player as! Player
        return isWin(for: thePlayer.opponent)
    }

    func score(for player: GKGameModelPlayer) -> Int {
        var res = 0
        let thePlayer = player as! Player
        if isWin(for: thePlayer) { res =  1}
        if isWin(for: thePlayer.opponent) { res =  -Int.max}
        //print(" \(thePlayer.debugDescription) \(self.debugDescription) \(res)")
        return res
    }
    
}


