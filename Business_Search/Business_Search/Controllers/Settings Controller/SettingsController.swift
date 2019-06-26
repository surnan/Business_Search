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
    
    var dataController: DataController!     //injected
    var newRadiusValue: Int!
    
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
    

    let searchRadiusLabel: UILabel = {
        let label = UILabel()
        let memeTextAttributes:[NSAttributedString.Key: Any] = [
            NSAttributedString.Key.strokeColor: UIColor.black,
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 20)!,
            NSAttributedString.Key.strokeWidth: -2.6
        ]
        label.attributedText = NSAttributedString(string: "Meters to Search for Businesses", attributes: memeTextAttributes)
        label.textAlignment = .center
        label.backgroundColor = .clear
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
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

    let myTextViewLabel: UILabel = {
        let label = UILabel()
        let memeTextAttributes:[NSAttributedString.Key: Any] = [
            NSAttributedString.Key.strokeColor: UIColor.black,
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 20)!,
            NSAttributedString.Key.strokeWidth: -2.6
        ]
        label.attributedText = NSAttributedString(string: "All outgoing messages include:", attributes: memeTextAttributes)
        label.textAlignment = .center
        label.layer.cornerRadius = 5
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var myTextView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .white
        textView.text = UserDefaults.standard.object(forKey: AppConstants.greetingMessage.rawValue) as? String ?? "Hi.  This is the Yelp page for a business that I am looking at: "
        textView.layer.cornerRadius = 5
        textView.font = UIFont.boldSystemFont(ofSize: 12)
        return textView
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
        button.setTitle(" DELETE ALL ", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
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
    
    let directionsDefaultLabel: UILabel = {
        let label = UILabel()
        label.text = "Default travel mode when retrieving directions:"
        return label
    }()
    
    let directionSegmentControl: UISegmentedControl = {
        let items = ["Walking", "Driving", "Mass-Transit"]
        let segment = UISegmentedControl(items: items)
        segment.backgroundColor = .white
        segment.addTarget(self, action: #selector(handleDirectionSegmentControl(_:)), for: .valueChanged)
        segment.layer.cornerRadius = 10
        segment.translatesAutoresizingMaskIntoConstraints = false
        return segment
    }()
    
    @objc func handleDirectionSegmentControl(_ sender: UISegmentedControl){
        print("")
    }
    
    
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

        let horizontalSliderStack: UIStackView = {
            let stack = UIStackView()
            stack.axis = .horizontal
            stack.spacing = 10
            stack.translatesAutoresizingMaskIntoConstraints = false
            return stack
        }()
        
        let verticalSliderStack: UIStackView = {
            let stack = UIStackView()
            stack.axis = .vertical
            stack.spacing = 20
            stack.translatesAutoresizingMaskIntoConstraints = false
            return stack
        }()
        
        let textViewStack: UIStackView = {
            let stack = UIStackView()
            stack.axis = .vertical
            stack.spacing = 20
            stack.translatesAutoresizingMaskIntoConstraints = false
            return stack
        }()
        
        let saveCancelDeleteStack: UIStackView = {
            let stack = UIStackView()
            stack.axis = .vertical
            stack.spacing = 20
            stack.translatesAutoresizingMaskIntoConstraints = false
            return stack
        }()
        
        [sliderLeftLabel, distanceSlider, sliderRightLabel].forEach{horizontalSliderStack.addArrangedSubview($0)}
        [searchRadiusLabel, horizontalSliderStack, sliderValueLabel].forEach{verticalSliderStack.addArrangedSubview($0)}
        [myTextViewLabel, myTextView].forEach{textViewStack.addArrangedSubview($0)}
        [saveButton, cancelButton, deleteAllButton, deleteAllLabel].forEach{saveCancelDeleteStack.addArrangedSubview($0)}
        [verticalSliderStack, textViewStack, saveCancelDeleteStack].forEach{view.addSubview($0)}
        
        NSLayoutConstraint.activate([
            horizontalSliderStack.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.66),
            myTextView.heightAnchor.constraint(equalToConstant: 50),
            verticalSliderStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60),
            verticalSliderStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            textViewStack.topAnchor.constraint(equalTo: verticalSliderStack.bottomAnchor, constant: 70),
            textViewStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            saveCancelDeleteStack.topAnchor.constraint(equalTo: textViewStack.bottomAnchor, constant: 70),
            saveCancelDeleteStack.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            ])
    }
    
    
    
    
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
        dismiss(animated: true, completion: {self.delegate?.undoBlur()})
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
