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
    
    
    let myTextViewLabel: UILabel = {
        let label = UILabel()
        label.text = "All outgoing messages include:"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textAlignment = .center
        label.backgroundColor = .clear
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var myTextView: UITextView = {
       let textView = UITextView()
        textView.backgroundColor = .white
        textView.text = UserDefaults.standard.object(forKey: AppConstants.greetingMessage.rawValue) as? String ?? "3 - This is the yelp page for what I'm looking at: "
        textView.layer.cornerRadius = 10
        textView.font = UIFont.boldSystemFont(ofSize: 12)
        return textView
    }()
    
    
    
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
    var maximumSliderValue: Int? {
        didSet {
            if let max = maximumSliderValue {
                distanceSlider.maximumValue = Float(max)
                sliderRightLabel.text = "\(max)"
            }
        }
    }
    
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
        //newRadiusValue = Int(radius)
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
        [myTextViewLabel, myTextView, sliderValueLabel, saveButton, cancelButton, deleteAllButton, deleteAllLabel].forEach{stackView.addArrangedSubview($0)}
        [informationLabel, stackView, sliderStack].forEach{view.addSubview($0)}
        
        NSLayoutConstraint.activate([
            informationLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            informationLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 160),
            
            sliderStack.topAnchor.constraint(equalTo: informationLabel.bottomAnchor, constant: 20),
            sliderStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            sliderStack.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.66),
            
            stackView.topAnchor.constraint(equalTo: sliderStack.bottomAnchor, constant: 30),
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            myTextView.heightAnchor.constraint(equalToConstant: 50)
            ])
    }
    
    
    var newRadiusValue: Int!
    
    //MARK:- Handlers
    @objc func handleDeleteAllButton(){
        let context: NSManagedObjectContext!  = dataController.backGroundContext
        context.perform {
            let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Location")
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetch)
            do {
                _  = try context.execute(deleteRequest) as! NSBatchDeleteResult
                DispatchQueue.main.async {
                    self.deleteAllLabel.isHidden = false
                    self.handlecancelButton()
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
        if let newRadius = newRadiusValue {
            radius = newRadius
            saveDefaults()
        }
        
        UserDefaults.standard.set(myTextView.text, forKey: AppConstants.greetingMessage.rawValue)
        
        dismiss(animated: true, completion: {
            self.delegate?.undoBlur()
        })
    }
    
    func saveDefaults(){
        UserDefaults.standard.set(radius, forKey: AppConstants.radius.rawValue)
    }
}

extension UIViewController {
    func showOKAlertController(title: String, message: String){
        let myAlertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        myAlertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(myAlertController, animated: true)
    }
    
    func showOKCancelAlertController(title: String, message: String, okFunction: ((UIAlertAction) -> Void)?) {
        let myAlertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        myAlertController.addAction(UIAlertAction(title: "OK", style: .default, handler: okFunction))
        myAlertController.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        present(myAlertController, animated: true)
    }
}
