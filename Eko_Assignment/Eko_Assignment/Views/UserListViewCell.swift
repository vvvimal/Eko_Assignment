//
//  UserListViewCell.swift
//  Eko_Assignment
//
//  Created by Venugopalan, Vimal on 26/01/20.
//  Copyright © 2020 Venugopalan, Vimal. All rights reserved.
//

import UIKit

// Only class object can conform to this protocol (struct/enum can't)
protocol UserListViewCellDelegate: AnyObject {
  func favoriteButtonTapped(_ userListViewCell: UserListViewCell) 
}

class UserListViewCell: UITableViewCell {
    /// Name Label
    lazy var nameLabel: UILabel = {
        let nl = UILabel()
        nl.numberOfLines = 0
        addSubview(nl)
        nl.translatesAutoresizingMaskIntoConstraints = false
        return nl
    }()
    
    /// Url Label
    lazy var urlLabel: UILabel = {
        let ul = UILabel()
        ul.numberOfLines = 0
        addSubview(ul)
        ul.translatesAutoresizingMaskIntoConstraints = false
        return ul
    }()
    
    /// Account Type Label
    lazy var accountTypeLabel: UILabel = {
        let al = UILabel()
        al.numberOfLines = 0
        addSubview(al)
        al.translatesAutoresizingMaskIntoConstraints = false
        return al
    }()
    
    /// Site Admin Status Label
    lazy var siteAdminStatusLabel: UILabel = {
        let sl = UILabel()
        sl.numberOfLines = 0
        addSubview(sl)
        sl.translatesAutoresizingMaskIntoConstraints = false
        return sl
    }()
    
    /// Favorite Button
    lazy var favoriteButton: UIButton = {
        let fb = UIButton(type: .custom)
        fb.backgroundColor = .clear
        fb.setBackgroundImage(UIImage.init(named: "BlankStar"), for: .normal)
        fb.addTarget(self, action: #selector(favoriteButtonTapped(_:)), for: .touchUpInside)
        addSubview(fb)
        fb.translatesAutoresizingMaskIntoConstraints = false
        return fb
    }()
    
    /// Avatar image view
    lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    // the delegate, remember to set to weak to prevent cycles
    weak var delegate : UserListViewCellDelegate?
    
    private let imageDownloadManager = ImageDownloadManager()
    
    /// UITableViewCell init method
    ///
    /// - Parameters:
    ///   - style: Tableview cell style
    ///   - reuseIdentifier: Identifier for cell
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        NSLayoutConstraint.activate([
            
            avatarImageView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 0.0),
            avatarImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10.0),
            avatarImageView.widthAnchor.constraint(equalToConstant: 50),
            avatarImageView.heightAnchor.constraint(equalToConstant: 50),

            
            nameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10.0),
            nameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 10.0),
            
            favoriteButton.topAnchor.constraint(equalTo: topAnchor, constant: 10.0),
            favoriteButton.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: 10.0),
            favoriteButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10.0),
            favoriteButton.widthAnchor.constraint(equalToConstant: 20),
            favoriteButton.heightAnchor.constraint(equalToConstant: 20),


            urlLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10.0),
            urlLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 10.0),
            urlLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.0),
            
            accountTypeLabel.topAnchor.constraint(equalTo: urlLabel.bottomAnchor, constant: 10.0),
            accountTypeLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 10.0),
            accountTypeLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.0),
            
            siteAdminStatusLabel.topAnchor.constraint(equalTo: accountTypeLabel.bottomAnchor, constant: 10.0),
            siteAdminStatusLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 10.0),
            siteAdminStatusLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.0),
            siteAdminStatusLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10.0),
            
            ])
        avatarImageView.isAccessibilityElement = true
        avatarImageView.accessibilityIdentifier = "avatarImageView"
        
        nameLabel.isAccessibilityElement = true
        nameLabel.accessibilityIdentifier = "nameLabel"
        
        favoriteButton.isAccessibilityElement = true
        favoriteButton.accessibilityIdentifier = "favoriteButton"
        
        urlLabel.isAccessibilityElement = true
        urlLabel.accessibilityIdentifier = "urlLabel"
        
        accountTypeLabel.isAccessibilityElement = true
        accountTypeLabel.accessibilityIdentifier = "accountTypeLabel"
        
        siteAdminStatusLabel.isAccessibilityElement = true
        siteAdminStatusLabel.accessibilityIdentifier = "siteAdminStatusLabel"
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var user: User! {
        didSet {
            avatarImageView.image = UIImage.init(named: "NoImageAvailable")
            let imageDownloadRequest = ImageDownloadRequest(urlString: user.avatar_url)
            imageDownloadManager.getImageFile(from: imageDownloadRequest, completion: ({ [weak self] result in
                switch result {
                case .success(let image):
                    DispatchQueue.main.async() { () -> Void in
                        self?.avatarImageView.image = image
                        self?.avatarImageView.alpha = 0
                        UIView.animate(withDuration: 0.5, delay: 0, options: UIView.AnimationOptions.showHideTransitionViews, animations: { () -> Void in
                            self?.avatarImageView.alpha = 1
                        }, completion: nil)
                    }
                    break
                    
                case .failure( _):
                    break
                }
                
            })
            )
            nameLabel.text = "\(user.login)"
            urlLabel.text = "\(user.html_url)"
            accountTypeLabel.text = "Type: \(user.type)"
            siteAdminStatusLabel.text = "Admin Status: \(user.site_admin)"
            let image = user.isFavorite == true ? UIImage.init(named: "BlueStar") : UIImage.init(named: "BlankStar")
            favoriteButton.setBackgroundImage(image, for: .normal)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func favoriteButtonTapped(_ sender: UIButton) {
        delegate?.favoriteButtonTapped(self)
    }
}


