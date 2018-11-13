//
//  SourceViewController.swift
//  iPracticaTres
//
//  Created by ALEXIS-PC on 10/29/18.
//  Copyright © 2018 upc.edu.pe. All rights reserved.
//

import UIKit
import AlamofireImage
import Alamofire
import SwiftyJSON

private let reuseIdentifier = "Cell"

class MYCeldaSource: UICollectionViewCell {
    @IBOutlet weak var imageSource: UIImageView!
    @IBOutlet weak var nameSourceLabel: UILabel!
    @IBOutlet weak var categorySourceLabel: UILabel!
    @IBOutlet weak var countrySourceLabel: UILabel!
    @IBOutlet weak var descriptionSourceLabel: UILabel!
    
    //para favorite
    var isFavorite: Bool = false
    @IBOutlet weak var imageFavoriteSource: UIImageView!
    
    func updateViewData(from source: Source){
        nameSourceLabel.text = source.name
        categorySourceLabel.text = source.category
        countrySourceLabel.text = source.country
        descriptionSourceLabel.text = source.description
        if let urlToLogo = URL(string: source.urlToLogo()) {
            imageSource.af_setImage(withURL: urlToLogo, placeholderImage: UIImage(named: "noimage"))
        }
        //favorite
        isFavorite = source.isFavoriteSource()
        setupFavoriteImageSource()
    }
    //to favorite
    func setupFavoriteImageSource() {
        imageFavoriteSource.image = UIImage(named: (self.isFavorite ? "star" : "heart-24"))
    }
    
}

class SourceViewController: UICollectionViewController {
    
    var sources: [Source] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateDataSource()
    }

    func updateDataSource() {
        let parameters = ["apiKey" : NewsApi.key]
        Alamofire.request(NewsApi.sourcesUrl, parameters: parameters)
        .validate()
        .responseJSON(completionHandler: {response in
            switch (response.result){
            case .success(let  value):
                let json = JSON(value)
                let status = json["status"].stringValue
                if status == "error" {
                    print("NewsApi Error: \(json["message"].stringValue)")
                    return
                }
                let jsonSources = json["sources"].arrayValue
                self.sources = Source.buildAll(from: jsonSources)
                self.collectionView!.reloadData()
            case .failure(let error):
                print("Response Error: \(error.localizedDescription)")
            }
            
        })
    }
   

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return sources.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MYCeldaSource
    
        // Configure the cell
        cell.updateViewData(from: sources[indexPath.row])
    
        return cell
    }

    /* Seleccionar una imagen*/
    var currentItemSource: Int = 0
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showASource" {
            let thisSourceViewController =  (segue.destination as! UINavigationController).viewControllers.first as! ASourceViewController
            thisSourceViewController.source = sources[currentItemSource]
            
        }
    }
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //ojo AQUI!!
        currentItemSource = indexPath.row
        self.performSegue(withIdentifier: "showASource", sender: self)
    }
    override func viewDidAppear(_ animated: Bool) {
        if let myCollectionView = collectionView {
            if myCollectionView.numberOfItems(inSection: 0) > 0 {
                myCollectionView.reloadItems(at: [IndexPath(item: self.currentItemSource, section: 0)])
            }
        }
    }

}
