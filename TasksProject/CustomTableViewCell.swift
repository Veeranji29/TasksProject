//
//  CustomTableViewCell.swift
//  TasksProject
//
//  Created by Veera Diande on 21/01/20.
//  Copyright © 2020 Brandenburg. All rights reserved.
//

import UIKit
import SDWebImage
class CustomTableViewCell: UITableViewCell {
    var myViewHeightConstraint: NSLayoutConstraint!

    var rowValues: Row? {
        didSet {
            guard let rowItem = rowValues else {return}
            if let title = rowItem.title {
                lblTitle.text = title
            }
            if let rowDescription = rowItem.rowDescription {
                lblDesc.text = rowDescription
            }
            
            if let rowImageVw = rowItem.imageHref {
                imvwLogo.sd_setImage(with: URL(string: rowImageVw), placeholderImage: UIImage(named: "img_not_available"))
            }
        }
    }
    // MARK: imvwLogo
    private let imvwLogo:UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFill // image will never be strecthed vertially or horizontally
        img.translatesAutoresizingMaskIntoConstraints = false // enable autolayout
        img.layer.cornerRadius = 30.0
        img.clipsToBounds = true
        return img
    }()
    // MARK: lblTitle
    private let lblTitle:UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    // MARK: lblDesc
    private let lblDesc:UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textColor =  .black
//        label.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        label.layer.cornerRadius = 5
        label.clipsToBounds = true
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    // MARK: UITableViewCell
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        let marginGuide = contentView.layoutMarginsGuide
        // configure imvwLogo
        contentView.addSubview(imvwLogo)
        imvwLogo.centerYAnchor.constraint(equalTo:self.contentView.centerYAnchor).isActive = true
        imvwLogo.leadingAnchor.constraint(equalTo:self.contentView.leadingAnchor, constant:10).isActive = true
        imvwLogo.widthAnchor.constraint(equalToConstant:60).isActive = true
        imvwLogo.heightAnchor.constraint(equalToConstant:60).isActive = true
        // configure lblTitle
        contentView.addSubview(lblTitle)
        lblTitle.translatesAutoresizingMaskIntoConstraints = false
        lblTitle.leadingAnchor.constraint(equalTo:self.imvwLogo.trailingAnchor, constant:10).isActive = true
        lblTitle.topAnchor.constraint(equalTo: marginGuide.topAnchor).isActive = true
        lblTitle.trailingAnchor.constraint(equalTo: marginGuide.trailingAnchor).isActive = true
        lblTitle.numberOfLines = 0
        lblTitle.font = UIFont(name: "AvenirNext-DemiBold", size: 20)
        lblTitle.textColor = UIColor.black
        // configure lblDesc
        contentView.addSubview(lblDesc)
        lblDesc.translatesAutoresizingMaskIntoConstraints = false
//        rowDetailedLabel.leadingAnchor.constraint(equalTo: marginGuide.leadingAnchor).isActive = true
        lblDesc.leadingAnchor.constraint(equalTo:self.imvwLogo.trailingAnchor, constant:10).isActive = true
        lblDesc.bottomAnchor.constraint(equalTo: marginGuide.bottomAnchor).isActive = true
        lblDesc.trailingAnchor.constraint(equalTo: marginGuide.trailingAnchor).isActive = true
        lblDesc.topAnchor.constraint(equalTo: lblTitle.bottomAnchor).isActive = true
        lblDesc.numberOfLines = 0
        lblDesc.font = UIFont(name: "Avenir-Book", size: 15)
        lblDesc.textColor = UIColor.black
    }
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
    }
}
