//
//  SettingsController.swift
//  Business_Search
//
//  Created by admin on 5/23/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import CoreData

class SettingsController: UIViewController, NSFetchedResultsControllerDelegate {
    
    var dataController: DataController!
    
    var fetchLocationController: NSFetchedResultsController<Location>? {
        didSet {
            if fetchLocationController == nil {
                fetchLocationController = {
                    let fetchRequest: NSFetchRequest<Location> = Location.fetchRequest()
                    let sortDescriptor = NSSortDescriptor(keyPath: \Location.latitude, ascending: true)
                    fetchRequest.sortDescriptors = [ sortDescriptor]
                    let aFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                                               managedObjectContext: dataController.viewContext,
                                                                               sectionNameKeyPath: nil,
                                                                               cacheName: nil)
                    aFetchedResultsController.delegate = self
                    do {
                        try aFetchedResultsController.performFetch()
                    } catch let error {
                        fatalError("Unresolved error \(error)")
                    }
                    return aFetchedResultsController
                }()
            }
        }
    }
    
    var delegate: MenuControllerDelegate?
    
    lazy var distanceSlider: UISlider = {
        var slider = UISlider()
        slider.minimumTrackTintColor = .blue
        slider.maximumTrackTintColor = .red
        slider.minimumValue = 0
        slider.maximumValue = 1000
        slider.value = Float(radius)
        slider.thumbTintColor = .purple
        slider.isContinuous = true
        slider.addTarget(self, action: #selector(handleSliderValueChange(_:forEvent:)), for: .valueChanged)
        slider.translatesAutoresizingMaskIntoConstraints = false
        return slider
    }()
    
    var sliderLeftLabel: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var sliderRightLabel: UILabel = {
        let label = UILabel()
        label.text = "1000"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var saveButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(handleSaveButton), for: .touchUpInside)
        button.backgroundColor = UIColor.white
        button.setTitle("     SAVE     ", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(handlecancelButton), for: .touchUpInside)
        button.backgroundColor = UIColor.white
        button.setTitle("     CANCEL     ", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var deleteAllButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(handleDeleteAllButton), for: .touchUpInside)
        button.backgroundColor = UIColor.red
        button.setTitle("     DELETE ALL     ", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    lazy var sliderValueLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .blue
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textColor = .white
        let intRadius = Int(radius)
        label.text = "\(intRadius)"
        label.layer.cornerRadius = 10
        label.clipsToBounds = true
        label.textAlignment = .center
        return label
    }()
    
    
    let informationLabel: UILabel = {
        let label = UILabel()
        label.text = "Search Radius"
        label.font = UIFont.boldSystemFont(ofSize: 30)
        label.textAlignment = .center
        label.backgroundColor = .clear
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let deleteAllLabel: UILabel = {
        let label = UILabel()
        label.text = "All saved business data deleted"
        label.textColor = UIColor.red
        //label.font = UIFont.boldSystemFont(ofSize: 30)
        label.textAlignment = .center
        label.backgroundColor = .clear
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        distanceSlider.value = Float(radius)
        sliderValueLabel.text = String(radius)
        deleteAllLabel.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        view.isOpaque = false
        let stackView: UIStackView = {
            let stack = UIStackView()
            stack.axis = .vertical
            stack.spacing = 50
            stack.translatesAutoresizingMaskIntoConstraints = false
            return stack
        }()
        
        let sliderStack: UIStackView = {
            let stack = UIStackView()
            stack.axis = .horizontal
            stack.spacing = 10
            stack.translatesAutoresizingMaskIntoConstraints = false
            return stack
        }()
        
        
        
        [sliderLeftLabel, distanceSlider, sliderRightLabel].forEach{sliderStack.addArrangedSubview($0)}
        [sliderValueLabel, saveButton, cancelButton, deleteAllButton, deleteAllLabel].forEach{stackView.addArrangedSubview($0)}
        [informationLabel, stackView, sliderStack].forEach{view.addSubview($0)}
        
        NSLayoutConstraint.activate([
            informationLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            informationLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 160),
            
            sliderStack.topAnchor.constraint(equalTo: informationLabel.bottomAnchor, constant: 20),
            sliderStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            sliderStack.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.66),
            
            stackView.topAnchor.constraint(equalTo: sliderStack.bottomAnchor, constant: 30),
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            ])
    }
    
    
    var newRadiusValue: Int!
    
    //MARK:- Handlers
    @objc func handleDeleteAllButton(_ sender: UIButton){
        let context: NSManagedObjectContext!  = dataController.backGroundContext
        context.perform {
            let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Location")
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetch)
            do {
                _  = try context.execute(deleteRequest) as! NSBatchDeleteResult
                DispatchQueue.main.async {
                    self.deleteAllLabel.isHidden = false
                }
            } catch {
                print("Error deleting All \(error)")
            }
        }
    }
    
    
    @objc func handleSliderValueChange(_ sender: UISlider, forEvent event: UIEvent){
        let intRadius = Int(sender.value)
        newRadiusValue = intRadius
        sliderValueLabel.text = "\(intRadius)"
        print("Radius ---> \(radius)")
    }
    
    @objc func handlecancelButton(){
        dismiss(animated: true, completion: {
            self.delegate?.undoBlur()
        })
    }
    
    @objc func handleSaveButton(){
        dismiss(animated: true, completion: {
            radius = self.newRadiusValue
            self.delegate?.undoBlur()
        })
    }
}
