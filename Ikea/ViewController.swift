//
//  ViewController.swift
//  Ikea
//
//  Created by Martin Saporiti on 13/05/2018.
//  Copyright © 2018 Martin Saporiti. All rights reserved.
//

import UIKit
import ARKit
class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    let itemsArray: [String] = ["cup", "vase", "boxing", "table"];
    
    var selectedItem: String?;
    
    @IBOutlet weak var sceneView: ARSCNView!

    @IBOutlet weak var itemsCollectionView: UICollectionView!
    let configuration = ARWorldTrackingConfiguration();

    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints,
                                       ARSCNDebugOptions.showWorldOrigin]
        self.sceneView.session.run(configuration);
        self.configuration.planeDetection = .horizontal
        
        self.itemsCollectionView.dataSource = self;
        self.itemsCollectionView.delegate = self;
        
        self.registerGestureRecognizer();
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    /**
 
    */
    func registerGestureRecognizer(){
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapped));
        self.sceneView.addGestureRecognizer(tapGestureRecognizer)
        
    }
    
    /**
    */
    @objc func tapped(sender: UITapGestureRecognizer){
        let sceneView = sender.view as! ARSCNView
        let tapLocation = sender.location(in: sceneView)
        let hitTest = sceneView.hitTest(tapLocation, types: .existingPlaneUsingExtent)
        
        if(!hitTest.isEmpty){
            print("tap horizonatl surface");
            self.addItem(hitTestResult: hitTest.first!)
        }else {
            print("no match")
        }
    }
    
    
    
    /**
 
    */
    func addItem(hitTestResult: ARHitTestResult){
        if let selectedItem = self.selectedItem{
            let scene = SCNScene(named: "Models.scnassets/\(selectedItem).scn")
            let node = scene?.rootNode.childNode(withName: selectedItem, recursively: false)
            let transform = hitTestResult.worldTransform;
            let thirdColumn = transform.columns.3
            node?.position = SCNVector3(thirdColumn.x, thirdColumn.y, thirdColumn.z)
            self.sceneView.scene.rootNode.addChildNode(node!);
        }
        
        
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.itemsArray.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "item", for: indexPath) as! ItemCell
        cell.itemLabel.text = itemsArray[indexPath.row];
        return cell;
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        self.selectedItem = self.itemsArray[indexPath.row]
        cell?.backgroundColor = UIColor.gray
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.backgroundColor = UIColor.black
    }

}

