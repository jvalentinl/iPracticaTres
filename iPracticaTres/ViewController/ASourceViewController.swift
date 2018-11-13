//
//  ASourceViewController.swift
//  iPracticaTres
//
//  Created by ALEXIS-PC on 11/12/18.
//  Copyright © 2018 upc.edu.pe. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import SwiftyJSON

class ASourceViewController: UIViewController {
    var source: Source?
    var isFavorite: Bool = false
    
    @IBOutlet weak var aImageSource: UIImageView!
    @IBOutlet weak var aNameSource: UILabel!
    @IBOutlet weak var aDescriptionSource: UILabel!
    @IBOutlet weak var aCategorySource: UILabel!
    @IBOutlet weak var aCountrySource: UILabel!
    @IBOutlet weak var aLanguageSource: UILabel!
    
    @IBOutlet weak var aFavoriteButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let source = source {
            aNameSource.text = source.name
            aDescriptionSource.text = source.description
            aCategorySource.text = source.category
            aCountrySource.text = source.country
            aLanguageSource.text = source.language
            
            if let url = URL(string: source.urlToLogo()) {
                aImageSource.af_setImage(withURL: url)
            }
            //para favorite, en Source debemos setear favorite:
            isFavorite = source.isFavoriteSource()
            setupFavoriteButtomImageSource()
        }
    }
    
    @IBAction func DoneSource(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true)
    }
    /* para marcar como favorito - arriba se agrego la variable isFavorite
     tambien dentro de viewDidload
     
     */
    
    @IBAction func AFavoriteAction(_ sender: UIButton) {
        isFavorite = !isFavorite
        setupFavoriteButtomImageSource()
        if let source = source {
            source.setFavoritesSource(isFavorite: isFavorite)
            let  store = iPracticaTresStore()
            print("Favorites: \(store.favoriteSourceIdAsString())")     // usa el store
        }
    }
    
    func setupFavoriteButtomImageSource() {
        aFavoriteButton.setImage(UIImage(named: (isFavorite ? "star" : "heart-24")), for: .normal)
    }

}
