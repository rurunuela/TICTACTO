//
//  Player.swift
//  tictacTest
//
//  Created by Richard Urunuela on 29/09/2020.
//

import Foundation
import GameKit
enum Chip: Int {
    case none = 0
    case red = 2
    case black = 4
}

//@objc(Player)
class Player:NSObject{
    let  chip :Chip
    
    init (_ chip:Chip) {
        self.chip = chip
        super.init()
    }
    
    static var redPlayer:Player{
        get {
            return self.playerForChip(.red)
        }
    }
    static var blackPlayer:Player{
        get {
            return self.playerForChip(.black)
        }
    }
    static func getPlayer(_ chip :Chip) ->Player?{
        if chip == .red {return redPlayer}
        if chip == .black {return blackPlayer}
        return nil

    }
    class func playerForChip(_ chip: Chip) -> Player {
        if chip == .red {return Players[0]}
        return  Players[1]
    }
    static var Players:[Player] = [Player(.red),Player(.black)]
    
    override var debugDescription: String {
        switch self.chip {
        case .red:
            return "R"
            
        case .black:
            return "B"
            
        default:
            return " "
        }
    }
    
    var opponent: Player {
        switch self.chip {
        case .red:
            return Player.blackPlayer
            
        case .black:
            return Player.redPlayer
            
        default:
            return Player.redPlayer
        }
    }
    
}
