//
//  FilterView.swift
//  Business_Search
//
//  Created by admin on 7/28/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class FilterView {
    
    private let topStringAttributes: [NSAttributedString.Key: Any]   = [
        .font:UIFont.boldSystemFont(ofSize: 26),
        .underlineStyle : NSUnderlineStyle.single.rawValue,
        .foregroundColor: UIColor.white
    ]
    
    var viewModel: FilterViewModel?{
        didSet{
            guard let viewModel = viewModel else {
                print("SettingsView.ViewModel = NIL")
                return
            }
            minimumRatingText               = viewModel.minimumRating
            sliderValue                     = viewModel.getSliderValue
            sliderValueLabel.text           = "\(viewModel.getSliderValue ?? 1.0)"
            dollarOneButton.isSelected      = viewModel.dollarOne
            dollarTwoButton.isSelected      = viewModel.dollarTwo
            dollarThreeButton.isSelected    = viewModel.dollarThree
            dollarFourButton.isSelected     = viewModel.dollarFour
            noPriceSwitch.isOn              = viewModel.priceExist
            favoriteAtTopSwitch.isOn        = viewModel.favoritesTop
            updateButtonColors()
        }
    }
    
    var isFilteredLabel     = GenericLabel(text: "  Selected options are restricting results  ",
                                           backgroundColor: .red,
                                           textColor: .white,
                                           alignment: .center,
                                           numberOfLines: -1)
    
    private var sliderLabel         = GenericLabel(text: "Minimum Customer Rating:", size: 20)
    private var sliderLeftLabel     = GenericLabel(text: "1.0")
    private var sliderRightLabel    = GenericLabel(text: "5.0")
    private var priceLabel          = GenericLabel(text: "Price Ranges:",  size: 20)
    private var noPriceLabel        = GenericLabel(text: "Show if No Price Listed:", size: 18, alignment: .left)
    private var favoriteAtTopLabel  = GenericLabel(text: "All Favorites at Top:", size: 18, alignment: .left)
    
    private var fillerLabel         = GenericLabel(text: "+ ")
    private var filterTitleLabel    = GenericLabel(text: "FILTER OPTIONS\n\n\n", size: 26)
    private lazy var attribTitle    = GenericAttributedTextLabel(text: "FILTER OPTIONS\n\n\n",
                                                                 attributes: topStringAttributes)
    
    
    func getTitleLabel()->UILabel{
        return filterTitleLabel
    }
    
    let dollarOneButton     = GenericSegmentButton(title: "$", isCorner: true, corners: [.layerMinXMinYCorner, .layerMinXMaxYCorner])
    let dollarTwoButton     = GenericSegmentButton(title: "$$")
    let dollarThreeButton   = GenericSegmentButton(title: "$$$")
    let dollarFourButton    = GenericSegmentButton(title: "$$$$", isCorner: true, corners: [.layerMaxXMinYCorner, .layerMaxXMaxYCorner])

    let saveButton          = GenericButton(title: "SAVE", isCorner: true)
    let cancelButton        = GenericButton(title: "CANCEL", isCorner: true)

    let defaultButton       : HighlightedButton = {
        let button = HighlightedButton()
        button.setTitle("   Reset to Defaults   ", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = UIColor.white
        button.clipsToBounds = true
        button.layer.cornerRadius = 10
        button.layer.borderWidth    = 1
        button.layer.borderColor    = UIColor.white.cgColor
        return button
    }()
    
    
    let noPriceSwitch       = GenericSwitch(onTintColor: .green)
    let favoriteAtTopSwitch = GenericSwitch(onTintColor: .green)
    
    private var minimumRatingText   : String!
    private var sliderValue         : Float!
    
    lazy var sliderValueLabel   = GenericLabel(text: minimumRatingText, size: 24, backgroundColor: .blue, textColor: .white, corner: true)
    lazy var distanceSlider     = GenericSlider(min: 1.0, max: 5.0, value: sliderValue, minColor: .gray, maxColor: .black, thumbColor: .white)
    
    private func updateButtonColors(){
        let allDollarButtons   = [dollarOneButton, dollarTwoButton, dollarThreeButton, dollarFourButton]
        allDollarButtons.forEach{$0.backgroundColor = $0.isSelected ? .white : .clear}
    }
    
    private func getFavoritesAtTopStack()->UIStackView{
        let isPriceListedStack =  GenericStack(spacing: 2, axis: .horizontal)
        [favoriteAtTopLabel, favoriteAtTopSwitch].forEach{isPriceListedStack.addArrangedSubview($0)}
        return isPriceListedStack
    }
    
    private func getNoPriceStack()->UIStackView{
        let isPriceListedStack =  GenericStack(spacing: 2, axis: .horizontal)
        [noPriceLabel, noPriceSwitch].forEach{isPriceListedStack.addArrangedSubview($0)}
        return isPriceListedStack
    }
    
    private func getSliderValueLabelStack()->UIStackView{
        let stack = GenericStack(spacing: 0, axis: .horizontal, distribution: .fillEqually)
        let fillerLabel = GenericLabel(text: " ")
        let fillerLabel2 = GenericLabel(text: " ")
        [fillerLabel, sliderValueLabel, fillerLabel2].forEach{stack.addArrangedSubview($0)}
        return stack
    }
    
    private func getSliderStack()->UIStackView{
        sliderLeftLabel.widthAnchor.constraint(equalToConstant: 50).isActive = true
        sliderRightLabel.widthAnchor.constraint(equalToConstant: 50).isActive = true
        let sliderStack = GenericStack(spacing: 2, axis: .horizontal)
        [sliderLeftLabel, distanceSlider, sliderRightLabel].forEach{sliderStack.addArrangedSubview($0)}
        return sliderStack
    }
    
    private func getDollarStack()->UIStackView{
        let dollarStack = GenericStack(spacing: 1, axis: .horizontal, distribution: .fillEqually)
        [dollarOneButton, dollarTwoButton, dollarThreeButton, dollarFourButton].forEach{dollarStack.addArrangedSubview($0)}
        return dollarStack
    }
    
    private var favoritesTextMessage: UILabel = {
        let textSting = "This option will not alter search results retrieved.  Only the display order is changed."
        let myAttributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font : UIFont.italicSystemFont(ofSize: 13),
                                                           NSAttributedString.Key.strokeColor : UIColor.white,
                                                           NSAttributedString.Key.foregroundColor: UIColor.white
        ]
        
        let textView = UILabel()
        textView.numberOfLines = -1
        textView.attributedText = NSAttributedString(string: textSting, attributes: myAttributes)
        return textView
    }()
    
    func getFilterOptionStack()->UIStackView{
        let space: CGFloat = 10
        let fullStack = GenericStack(spacing: space, axis: .vertical)
        let priceDollarsView: UIView = getDollarStack()
        let noPriceView: UIView = getNoPriceStack()
        let sliderValueView: UIView = getSliderValueLabelStack()
        
        let lineView    = SeparatorLine()
        let lineView2   = SeparatorLine()
        let lineView3   = SeparatorLine()
        
        [attribTitle,
         priceLabel, priceDollarsView, noPriceView,
         lineView,
         sliderLabel, getSliderStack(), sliderValueView,
         lineView2,
         getFavoritesAtTopStack(), favoritesTextMessage,
         lineView3].forEach{fullStack.addArrangedSubview($0)}
        fullStack.setCustomSpacing(space * 3, after: attribTitle)
        fullStack.setCustomSpacing(space * 1.5, after: lineView)
        fullStack.setCustomSpacing(space * 1.5, after: lineView2)
        fullStack.setCustomSpacing(space * 1.5, after: lineView3)
        return fullStack
    }
    
    func getSaveCancelDefaultStack()->UIStackView{
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 10
        stack.translatesAutoresizingMaskIntoConstraints = false
        [saveButton, cancelButton, defaultButton].forEach{stack.addArrangedSubview($0)}
        return stack
    }
}

class SeparatorLine: UIView {
    init(frame: CGRect = .zero, color: UIColor = UIColor.white, height: CGFloat = 0.5) {
        super.init(frame: frame)
        self.backgroundColor = color
        self.translatesAutoresizingMaskIntoConstraints = false
        self.heightAnchor.constraint(equalToConstant: height).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
