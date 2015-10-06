//
//  PrimitivesScene.swift
//  Entropy
//

import UIKit
import SceneKit

class PrimitivesScene: SCNScene {
    
    override init() {
        super.init()
        let sphereGeometry = SCNSphere(radius: 1.0)
        sphereGeometry.firstMaterial?.diffuse.contents = UIColor.yellowColor()
        let sphereNode = SCNNode(geometry: sphereGeometry)
        self.rootNode.addChildNode(sphereNode)
        
        let secondSphereGeometry = SCNSphere(radius: 0.5)
        secondSphereGeometry.firstMaterial?.diffuse.contents = UIColor.greenColor()
        let secondSphereNode = SCNNode(geometry: secondSphereGeometry)
        secondSphereNode.position = SCNVector3(x: 3.0, y: 0.0, z: 0.0)
        self.rootNode.addChildNode(secondSphereNode)
        
        let thirdSphereGeometry = SCNSphere(radius: 0.3)
        thirdSphereGeometry.firstMaterial?.diffuse.contents = UIColor.orangeColor()
        let thirdSphereNode = SCNNode(geometry: thirdSphereGeometry)
        thirdSphereNode.position = SCNVector3(x: 5.0, y: 0.0, z: 0.0)
        
        let camera = SCNCamera()
        let cameraNode = SCNNode()
        cameraNode.camera = camera
        cameraNode.position = SCNVector3(x: 0.0, y: 0.0, z: 0.0)
        self.rootNode.addChildNode(thirdSphereNode)
        
        let light = SCNLight()
        light.type = SCNLightTypeOmni
        let lightNode = SCNNode()
        lightNode.light = light
        lightNode.position = SCNVector3(x: 1.5, y: 1.5, z: 1.5)
        
        let bottomlight = SCNLight()
        bottomlight.type = SCNLightTypeOmni
        let bottomlightNode = SCNNode()
        bottomlightNode.light = bottomlight
        bottomlightNode.position = SCNVector3(x: 1.5, y: 1.5, z: -1.5)

        
        let cubeGeometry = SCNBox(width: 1.0, height: 1.0, length: 1.0, chamferRadius: 0.0)
        let redMaterial = SCNMaterial()
        redMaterial.diffuse.contents = UIColor.purpleColor()
        cubeGeometry.materials = [redMaterial]
        // cubeGeometry.firstMaterial?.diffuse.contents = UIColor.redColor()
        let cubeNode = SCNNode(geometry: cubeGeometry)
        cubeNode.position = SCNVector3(x: 10.0, y: 0.0, z: 0.0)
        self.rootNode.addChildNode(cubeNode)
        
        /*
        let planeGeometry = SCNPlane(width: 50.0, height: 50.0)
        let blueMaterial = SCNMaterial()
        blueMaterial.diffuse.contents = UIColor.blueColor()
        planeGeometry.materials = [blueMaterial]
        let planeNode = SCNNode(geometry: planeGeometry)
        planeNode.eulerAngles = SCNVector3(x: GLKMathDegreesToRadians(-90), y: 0, z: 0)
        planeNode.position = SCNVector3(x: 0, y: -0.5, z: 0)
        self.rootNode.addChildNode(planeNode)
        */
        
        

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
   
}
