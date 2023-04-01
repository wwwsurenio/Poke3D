//
//  ViewController.swift
//  Poke3D
//
//  Created by User01 on 29/3/23.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        sceneView.autoenablesDefaultLighting = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARImageTrackingConfiguration()
        
        if let imageToTrack = ARReferenceImage.referenceImages(inGroupNamed: "PokemonCards", bundle: Bundle.main){
            
            configuration.trackingImages = imageToTrack
            configuration.maximumNumberOfTrackedImages = 2
            
            print("Images succesfully added")
            
        }
        
        

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    // MARK: - ARSCNViewDelegate
    
    var cardName = [""]
   
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        
        let node = SCNNode()
        
        if let imageAnchor = anchor as? ARImageAnchor{
            
            cardName = imageAnchor.referenceImage.name!.components(separatedBy: "-")
            
            let plane = SCNPlane(
                width: imageAnchor.referenceImage.physicalSize.width,
                height: imageAnchor.referenceImage.physicalSize.height)
            
            plane.firstMaterial?.diffuse.contents = UIColor(white: 1.0, alpha: 0.5)
            
            let planeNode = SCNNode(geometry: plane)
            
            planeNode.eulerAngles.x = -.pi / 2
            
            node.addChildNode(planeNode)
            
            if let pokeScene = SCNScene(named: "art.scnassets/\(cardName)"){
                
                if let pokeNode = pokeScene.rootNode.childNodes.first{
                    
                    planeNode.addChildNode(pokeNode)
                    
                    planeNode.eulerAngles.x = .pi / 2
                }
            }
            
        }
        return node
        
    }
    
}//end of class
