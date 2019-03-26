//
//  ViewController.swift
//  Project 1
//
//  Created by Drew Westcott on 18/02/2019.
//  Copyright © 2019 Drew Westcott. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {

    var images = [Image]()
    var defaults = UserDefaults.standard
    
    fileprivate func loadSavedImages() {
        let jsonDecoder = JSONDecoder()
        
        if let savedPictures = defaults.object(forKey: "pictures") as? Data {
            do {
                let decodedPictures = try jsonDecoder.decode([Image].self, from: savedPictures)
                images = decodedPictures
            }  catch {
                print("unable to decode")
            }
        }
    }
    
    fileprivate func loadImagesFromFile() {
        let fm = FileManager.default
        let path = Bundle.main.resourcePath!
        print("Path was: \(path.debugDescription)")
        let items = try! fm.contentsOfDirectory(atPath: path)
        
        loadSavedImages()
        
        for item in items {
            if item.hasPrefix("nssl") {
                let filtered = images.filter{ ( $0.name.lowercased().contains(item.lowercased()) ) }
                if filtered.isEmpty {
                    let picture = Image(name: item, count: 0)
                    images.append(picture)
                }
            }
        }
        images.sort { (lhs: Image, rhs: Image) -> Bool in
            return lhs.name < rhs.name
        }
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Storm Viewer"
        navigationController?.navigationBar.prefersLargeTitles = true

        DispatchQueue.global(qos: .default).async { [weak self] in
            self?.loadImagesFromFile()
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return images.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Picture", for: indexPath)
        let picture = images[indexPath.row]
        cell.textLabel?.text = picture.name
        cell.detailTextLabel?.text = "Viewed: \(picture.count) time(s)"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailVC {
            let picture = images[indexPath.row]
            vc.imageName = picture.name
            vc.imageNumber = indexPath.row + 1
            vc.totalImages = images.count
            images[indexPath.row].count += 1
            saveImages()
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func saveImages() {
        let jsonEncoder = JSONEncoder()
        do {
            let encoded = try jsonEncoder.encode(images)
            defaults.set(encoded, forKey: "pictures")
        } catch {
            print("Unable to save")
        }
        
    }
    
    
}

