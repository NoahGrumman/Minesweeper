//
//  ViewController.swift
//  MineSweeper
//
//  Created by Noah Grumman on 26/02/15.
//  Copyright (c) 2015 Noah Grumman. All rights reserved.
//

import UIKit
import AudioToolbox

class ViewController: UIViewController {

    var cells = [UIButton]()
    var gameSize = MineSweeperModel.sharedModel.getSize()
    var screenWidth: Int = Int(UIScreen.mainScreen().bounds.width)
    
    func buildGameBoard() {
        
        cells = []
        
        let cellSize = CGSize(width: (screenWidth / (gameSize + 2)), height: (screenWidth / (gameSize + 2)))
        
        for row in 0..<gameSize {
            for col in 0..<gameSize {
                let cell = UIButton(type: .Custom)
                
                cell.frame = CGRect(x: cellSize.width + CGFloat(col) * (cellSize.width), y: 80 + CGFloat(row) * (cellSize.height) , width: cellSize.width, height: cellSize.height)
                
                //cell.backgroundColor = UIColor.lightGrayColor()
                
                view.addSubview(cell)
                cells.append(cell)
                
                renderCell(row, col: col)
                
                cell.addTarget(self, action: "handleTap:", forControlEvents: .TouchUpInside)

                cell.addTarget(self, action: "handleLongPress:", forControlEvents: .TouchUpOutside)
                
            }
        }
    }
    
    func handleTap(cell: UIButton) {
        let cellIndex = cells.indexOf(cell)!
        let row = cellIndex / gameSize
        let col = cellIndex % gameSize
        
        if !MineSweeperModel.sharedModel.isExplored(row,col: col){
            MineSweeperModel.sharedModel.setExplored(row, col: col)
            renderAllCells()
        }
        
        checkOutcome()
    }
    
    func handleLongPress(cell: UIButton) {
        let cellIndex = cells.indexOf(cell)!
        let row = cellIndex / gameSize
        let col = cellIndex % gameSize
        
        if !MineSweeperModel.sharedModel.isExplored(row,col: col){
            MineSweeperModel.sharedModel.setFlagged(row, col: col)
        }
        
        renderCell(row, col: col)
        
        checkOutcome()
    }
    
    func checkOutcome(){
        if (MineSweeperModel.sharedModel.loser == true){
            
            // This is supposed to make the phone vibrate upon losing. Not sure if it actually works.
            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
            
            let alert = UIAlertController(title: "Game Over", message: "You lose!", preferredStyle: .ActionSheet)
            let okAction = UIAlertAction(title: "Restart", style: .Default, handler: { action in
                MineSweeperModel.sharedModel.reset()
                self.reset()
                self.buildGameBoard()
            })
            alert.addAction(okAction)
            presentViewController(alert, animated: true, completion: nil)
        }
        if (MineSweeperModel.sharedModel.winner == true){
            let alert = UIAlertController(title: "Congratulations!", message: "You won in \(MineSweeperModel.sharedModel.steps) steps.", preferredStyle: .ActionSheet)
            let okAction = UIAlertAction(title: "Restart", style: .Default, handler: { action in
                MineSweeperModel.sharedModel.reset()
                self.reset()
                self.buildGameBoard()
            })
            alert.addAction(okAction)
            presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    func reset(){
        for cell in cells {
            cell.removeTarget(self, action: "handleTap:", forControlEvents: .TouchUpInside)
            cell.removeTarget(self, action: "handleLongPress:", forControlEvents: .TouchUpOutside)
            cell.setImage(nil, forState: .Normal)
            cell.setBackgroundImage(nil, forState: .Normal)
        }
    }
    
        
    func renderCell(row: Int, col: Int) {
        let cell = cells[row*gameSize + col]
        
        let (marker,content) = MineSweeperModel.sharedModel.getCell(row, col: col)
        
        
        switch marker {
        case .Unexplored: cell.setImage(UIImage(named: "Unexplored"), forState: .Normal)
        case .Flagged: cell.setImage(UIImage(named: "Flagged"), forState: .Normal)
        case .Explored:
            cell.setBackgroundImage(nil, forState: .Normal)
            switch content {
            case .C0: cell.setImage(nil, forState: .Normal)
            case .C1: cell.setImage(UIImage(named: "C1"), forState: .Normal)
            case .C2: cell.setImage(UIImage(named: "C2"), forState: .Normal)
            case .C3: cell.setImage(UIImage(named: "C3"), forState: .Normal)
            case .C4: cell.setImage(UIImage(named: "C4"), forState: .Normal)
            case .C5: cell.setImage(UIImage(named: "C5"), forState: .Normal)
            case .C6: cell.setImage(UIImage(named: "C6"), forState: .Normal)
            case .C7: cell.setImage(UIImage(named: "C7"), forState: .Normal)
            case .C8: cell.setImage(UIImage(named: "C8"), forState: .Normal)
            case .Bomb: cell.setImage(UIImage(named: "Bomb"), forState: .Normal)
                
            case .Empty: cell.setImage(nil, forState: .Normal)
            }
        }
    }
    
    func renderAllCells() {
        for row in 0..<gameSize {
            for col in 0..<gameSize {
                renderCell(row, col: col)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buildGameBoard()
        
    }


}

