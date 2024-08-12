//
//  ProductTableViewCell.swift
//  alura geek
//
//  Created by Evolua Tech on 10/08/24.
//

import UIKit

class ProductTableViewCell: UITableViewCell {

    @IBOutlet var productTitleLabel: UILabel!
    @IBOutlet var productPriceLabel: UILabel!
    @IBOutlet var productImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // add shadow on cell
        backgroundColor = .clear // very important
        layer.masksToBounds = false
        layer.shadowOpacity = 0.23
        layer.shadowRadius = 4
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowColor = UIColor.black.cgColor

        // add corner radius on `contentView`
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 8
        
        productTitleLabel.font = UIFont(name: "Orbitron-Bold", size: 25)
        productPriceLabel.font = UIFont(name: "Orbitron-Bold", size: 25)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupCell(imageUrl: String, title: String, price: String) {
        
        
        productImageView.kf.setImage(with: URL(string: imageUrl))
        productTitleLabel.text = title
        productPriceLabel.text = price
        
        
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0))
    }
}
