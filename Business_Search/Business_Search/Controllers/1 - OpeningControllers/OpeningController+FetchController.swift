//
//  OpeningController+FetchController.swift
//  Business_Search
//
//  Created by admin on 6/19/19.
//  Copyright © 2019 admin. All rights reserved.
//

import Foundation
import CoreData


extension OpeningController {
    
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any, at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        //Object insert/update/remove/move changed
        if controller != fetchBusinessController {
            print("Returned")
            return
        }
        
        print("success")
        
        switch type {
        case .insert:
            //tableView.insertRows(at: [newIndexPath!], with: .fade)
            break
        default:
            //tableView.moveRow(at: indexPath!, to: newIndexPath!)
            break
        }
    }
    
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        //tableView.beginUpdates()
        print("")
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        //tableView.beginUpdates()
        print("")
    }
}

