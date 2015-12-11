//
//  MineSweeperModel.swift
//  MineSweeper
//
//  Created by Noah Grumman on 26/02/15.
//  Copyright (c) 2015 Noah Grumman. All rights reserved.
//

import Foundation

private let mineSweeperModelInstance = MineSweeperModel()

class MineSweeperModel {
    
    
    
    enum Marker {
        case Flagged
        case Unexplored
        case Explored
    }
    
    enum Content : Int {
        case Empty = -1
        case Bomb = 9
        case C0 = 0
        case C1 = 1
        case C2 = 2
        case C3 = 3
        case C4 = 4
        case C5 = 5
        case C6 = 6
        case C7 = 7
        case C8 = 8
    }
    
    private var boardSize: Int = 10
    private var content: [Content] = [.C0, .C1, .C2, .C3, .C4, .C5, .C6, .C7, .C8]
    private var numBombs: Int = 0
    private var numFlagged: Int = 0
    private var numExplored: Int = 0
    var steps: Int = 0
    
    func getSize() -> Int {
        return boardSize
    }
    
    class var sharedModel : MineSweeperModel {
        return mineSweeperModelInstance
    }
    
    private var board: [[(Marker,Content)]]
    
    init() {
        board = [[(Marker,Content)]]()
        for row in 0..<boardSize {
            board.append([(Marker,Content)](count: boardSize, repeatedValue: (.Unexplored, .Empty)))
        }
        
        reset()
    }
    
    var winner: Bool {
        if(numBombs == numFlagged){
            return true
        }
        return false;
    }
    
    var loser: Bool = false
    
    func reset(){
        numBombs = 0
        numFlagged = 0
        numExplored = 0
        steps = 0
        for row in 0..<boardSize {
            for col in 0..<boardSize {
                if(Float(arc4random_uniform(100)) < 10){
                    board[row][col] = (.Unexplored, .Bomb)
                    numBombs++
                }
                else {
                    board[row][col] = (.Unexplored, .Empty)
                }
            }
        }
        for row in 0..<boardSize {
            for col in 0..<boardSize {
                let (marker,content) = board[row][col]
                if (content == .Empty){
                    board[row][col] = (.Unexplored,neighborBombs(row, col: col))
                }
            }
        }
        print(numBombs, terminator: "")
        loser = false
    }
    
    
    func neighborBombs (row: Int, col: Int) -> Content{
        var count = 0
        if (inRange(row+1, col: col) && isBomb(row+1, col: col)){
            count++
        }
        if (inRange(row+1, col: col+1) && isBomb(row+1, col: col+1)){
            count++
        }
        if (inRange(row+1, col: col-1) && isBomb(row+1, col: col-1)){
            count++
        }
        if (inRange(row, col: col+1) && isBomb(row, col: col+1)){
            count++
        }
        if (inRange(row, col: col-1) && isBomb(row, col: col-1)){
            count++
        }
        if (inRange(row-1, col: col) && isBomb(row-1, col: col)){
            count++
        }
        if (inRange(row-1, col: col+1) && isBomb(row-1, col: col+1)){
            count++
        }
        if (inRange(row-1, col: col-1) && isBomb(row-1, col: col-1)){
            count++
        }
        return content[count]
    }
    
    func inRange(row: Int, col: Int) -> Bool {
        if (row >= 0 && row < boardSize && col >= 0 && col < boardSize){
            return true
        }
        else {
            return false
        }
    }
    
    func isBomb(row: Int, col: Int) -> Bool{
        let (marker,content) = board[row][col]
        if (content == .Bomb){
            return true
        }
        else {
            return false
        }
    }
    
    func getCell(row: Int, col: Int) -> (Marker,Content) {
        return board[row][col]
    }
    
    func isExplored(row: Int, col: Int) -> Bool{
        let (marker,_) = board[row][col]
        if marker == .Unexplored {
            return false
        }
        else {
            return true
        }
    }
    
    func setExplored(row: Int, col: Int){
        let (_,content) = board[row][col]
        if content == .Bomb {
            board[row][col] = (.Explored,.Bomb)
            loser = true
        }
        else {
            reveal(row, col: col)
            //print("True")
            if isC0(row, col: col){
                
                blockReveal(row,col: col)
            }
        }
        steps++
    }
    
    
    func setFlagged(row: Int, col: Int){
        let (marker,content) = board[row][col]
        if(marker == .Flagged) {
            board[row][col] = (.Unexplored,content)
            numFlagged--
        }
        else {
            if content != .Bomb {
                loser = true
            }
            board[row][col] = (.Flagged,content)
            numFlagged++
            numExplored++
        }
        steps++
    }
    
    func isC0(row: Int, col: Int) -> Bool{
        let (marker,content) = board[row][col]
        if content == .C0 {
            return true
        }
        else {
            return false
        }
    }
    
    func reveal(row: Int, col: Int) {
        let (_,content) = board[row][col]
        board[row][col] = (.Explored,content)
        numExplored++
    }
    
    func blockReveal(row: Int, col: Int){
        
        if inRange(row+1,col: col) {
            if !isExplored(row+1,col: col) && isC0(row+1,col: col){
                reveal(row+1,col: col)
                blockReveal(row+1,col: col)
            }
            else if !isBomb(row+1,col: col){
                reveal(row+1,col: col)
            }
        }
        
        if inRange(row-1,col: col){
            if !isExplored(row-1,col: col) && isC0(row-1,col: col){
                reveal(row-1,col: col)
                blockReveal(row-1,col: col)
            }
            else if !isBomb(row-1,col: col){
                reveal(row-1,col: col)
            }
        }
        
        if inRange(row,col: col+1){
            if !isExplored(row,col: col+1) && isC0(row,col: col+1){
                reveal(row,col: col+1)
                blockReveal(row,col: col+1)
            }
            else if !isBomb(row,col: col+1){
                reveal(row,col: col+1)
            }
        }
        
        if inRange(row,col: col-1){
            if !isExplored(row,col: col-1) && isC0(row,col: col-1){
                reveal(row,col: col-1)
                blockReveal(row,col: col-1)
            }
            else if !isBomb(row,col: col-1){
                reveal(row,col: col-1)
            }
        }
        
    }
    
}