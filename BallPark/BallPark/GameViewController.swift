//
//  GameViewController.swift
//  BallPark
//


import UIKit
import QuartzCore
import SceneKit
import SpriteKit

class GameViewController: UIViewController, SCNSceneRendererDelegate, SCNPhysicsContactDelegate {
    
    let BALL_RADIUS = CGFloat(15)
    
    private var _scene: SCNScene!
    private var _cameraNode: SCNNode!
    private var _cameraHandle: SCNNode!
    private var _cameraOrientation: SCNNode!
    private var _ambientLightNode: SCNNode!
    private var _spotLightNode: SCNNode!
    private var _spotLightParentNode: SCNNode!
    private var _floorNode: SCNNode!
    private var _skyNode: SCNNode!
    private var _rollingBall: SCNNode!
    
    
    private var _cameraHandleTransforms = [SCNMatrix4](count:10, repeatedValue:SCNMatrix4(m11: 0.0, m12: 0.0, m13: 0.0, m14: 0.0, m21: 0.0, m22: 0.0, m23: 0.0, m24: 0.0, m31: 0.0, m32: 0.0, m33: 0.0, m34: 0.0, m41: 0.0, m42: 0.0, m43: 0.0, m44: 0.0))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        
    }
    
    func setup() {
        let sceneView = self.view as! SCNView
        sceneView.backgroundColor = SKColor.blackColor()
        
        setupScene()
        sceneView.scene = _scene;
        // sceneView.scene = PrimitivesScene()
        
        
        
        
        
        // sceneView.autoenablesDefaultLighting = true
        // sceneView.allowsCameraControl = true
        
        sceneView.delegate = self;
        sceneView.jitteringEnabled = true
        sceneView.pointOfView = _cameraNode
        
        // add a tap gesture recognizer
        let tapGesture = UITapGestureRecognizer(target: self, action: ("handleTap"))
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: ("handleLongPress:"))
        
        let swipeUpGesture = UISwipeGestureRecognizer(target: self, action: ("handleSwipeUp"))
        swipeUpGesture.direction = UISwipeGestureRecognizerDirection.Up
        
        let swipeDownGesture = UISwipeGestureRecognizer(target: self, action: ("handleSwipeDown"))
        swipeDownGesture.direction = UISwipeGestureRecognizerDirection.Down
        
        let gestureRecognizers = [tapGesture, longPressGesture, swipeUpGesture, swipeDownGesture]
        sceneView.gestureRecognizers = gestureRecognizers
        
    }
    
    func setupScene() {
        _scene = SCNScene()
        setupEnvironment()
        setupSceneElements()
        setupInitial()
        // let modelScene = SCNScene(named: "model.dae")
        // let lastNode = modelScene?.rootNode.childNodeWithName("Last", recursively: true)
        // _scene.rootNode.addChildNode(lastNode!)
    }
    
    func handleTap() {
        animateCameraForwardBy(100)
    }
    func animateRollingBallForwardBy(amount: Float) {
        SCNTransaction.begin()
        SCNTransaction.setAnimationDuration(1.0)
        
        SCNTransaction.setCompletionBlock(){
            print("done")
        }
        _rollingBall.position.y += CFloat(BALL_RADIUS)
        SCNTransaction.commit()
        
        
        
    }
    
    func animateCameraForwardBy(amount: Float) {
        SCNTransaction.begin()
        SCNTransaction.setAnimationDuration(1.0)
        
        SCNTransaction.setCompletionBlock(){
            print("done")
        }
        _cameraNode.position.z -= amount
        SCNTransaction.commit()
    }
    func animateCameraBackBy(amount: Float) {
        SCNTransaction.begin()
        SCNTransaction.setAnimationDuration(1.0)
        
        SCNTransaction.setCompletionBlock(){
            print("done")
        }
        /*
        if (_cameraNode.position.y > amount) {
            _cameraNode.position.y -= amount
        }
        */
        _cameraNode.position.z += amount
        
        SCNTransaction.commit()
    }
    func handleLongPress(sender:AnyObject) {
        if (sender.state == UIGestureRecognizerState.Began) {
            print("began")
        } else if (sender.state == UIGestureRecognizerState.Changed) {
            animateCameraForwardBy(10)
            print("changed")
        } else if (sender.state == UIGestureRecognizerState.Ended) {
            print("endede")
        }
        
    }
    
    func handleSwipeUp() {
        animateCameraForwardBy(100)
        // animateRollingBallForwardBy(100)
        
    }
    
    func handleSwipeDown() {
        animateCameraBackBy(100)
    }
    
    
    func setupEnvironment() {
        // create main camera
        _cameraNode = SCNNode()
        _cameraNode.position = SCNVector3Make(0, 0, 120)
        
        // create a node to manipulate the camera orientation
        _cameraHandle = SCNNode()
        _cameraHandle.position = SCNVector3Make(0, 60, 0)
        
        _cameraOrientation = SCNNode()
        
        _scene.rootNode.addChildNode(_cameraHandle)
        
        _cameraHandle.addChildNode(_cameraOrientation)
        _cameraOrientation.addChildNode(_cameraNode)
        
        _cameraNode.camera = SCNCamera()
        _cameraNode.camera!.zFar = 10000
        
        if UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Phone {
            _cameraNode.camera?.yFov = 55
        } else {
            _cameraNode.camera?.yFov = 75
        }
        _cameraHandleTransforms.insert(_cameraNode.transform, atIndex: 0)
        
        
        let position = SCNVector3Make(200, 0, 1000)
        _cameraNode.position = SCNVector3Make(200, 20, position.z+150)
        _cameraNode.eulerAngles = SCNVector3Make(CFloat(-M_PI_2)*0.06, 0, 0)
        
        // add an ambient light
        _ambientLightNode = SCNNode()
        _ambientLightNode.light = SCNLight()
        
        _ambientLightNode.light?.type = SCNLightTypeAmbient
        _ambientLightNode.light?.color = SKColor(white: 0.3, alpha: 1.0)
        _scene.rootNode.addChildNode(_ambientLightNode)
        
        // add a spot light
        
        _spotLightParentNode = SCNNode()
        _spotLightParentNode.position = SCNVector3Make(0, 90, 20)
        
        _spotLightNode = SCNNode()
        _spotLightNode.rotation = SCNVector4Make(1, 0, 0, CFloat(-M_PI_4))
        _spotLightNode.light = SCNLight()
        _spotLightNode.light?.type = SCNLightTypeSpot
        _spotLightNode.light?.color = SKColor(white: 1.0, alpha: 1.0)
        _spotLightNode.light?.castsShadow = true
        _spotLightNode.light?.shadowColor = SKColor(white: 0, alpha: 0.5)
        _spotLightNode.light?.zNear = 30;
        _spotLightNode.light?.zFar = 800;
        _spotLightNode.light?.shadowRadius = 1.0
        _spotLightNode.light?.spotInnerAngle = 15
        _spotLightNode.light?.spotOuterAngle = 70
        
        _cameraNode.addChildNode(_spotLightParentNode)
        _spotLightParentNode.addChildNode(_spotLightNode)
        
        // floor
        let floor = SCNFloor()
        floor.reflectionFalloffEnd = 0
        floor.reflectivity = 0
        
        _floorNode = SCNNode()
        _floorNode.geometry = floor
        _floorNode.geometry?.firstMaterial?.diffuse.contents = "wood.png"
        _floorNode.geometry?.firstMaterial?.locksAmbientWithDiffuse = true
        _floorNode.geometry?.firstMaterial?.diffuse.wrapS = SCNWrapMode.Repeat
        _floorNode.geometry?.firstMaterial?.diffuse.wrapS = SCNWrapMode.Repeat
        _floorNode.geometry?.firstMaterial?.diffuse.mipFilter = SCNFilterMode.Linear
        
        _floorNode.physicsBody = SCNPhysicsBody(type:SCNPhysicsBodyType.Static, shape: nil)
        _floorNode.physicsBody?.restitution = 1.0
        
        _scene.rootNode.addChildNode(_floorNode)
        
        
    }
    
    func setupSceneElements() {
        let wallGeometry = SCNPlane(width: 800, height: 200)
        wallGeometry.firstMaterial?.diffuse.contents = "wallpaper.png"
        wallGeometry.firstMaterial?.diffuse.contentsTransform = SCNMatrix4Mult(SCNMatrix4MakeScale(8.0, 2.0, 1.0), SCNMatrix4MakeRotation(CFloat(M_PI_4), 0.0, 0.0, 1.0))
        wallGeometry.firstMaterial?.diffuse.wrapS = SCNWrapMode.Repeat
        wallGeometry.firstMaterial?.diffuse.wrapT = SCNWrapMode.Repeat
        wallGeometry.firstMaterial?.doubleSided = true
        wallGeometry.firstMaterial?.locksAmbientWithDiffuse = true
        
        let wallWithBaseboardNode = SCNNode(geometry: wallGeometry)
        wallWithBaseboardNode.position = SCNVector3Make(200, 100, -20)
        wallWithBaseboardNode.physicsBody = SCNPhysicsBody(type: SCNPhysicsBodyType.Static, shape: nil)
        wallWithBaseboardNode.physicsBody?.restitution = 1.0
        wallWithBaseboardNode.castsShadow = false
        
        let baseBoardNode = SCNNode(geometry: SCNPlane(width: 800, height: 8))
        baseBoardNode.geometry?.firstMaterial?.diffuse.contents = "baseboard.jpg"
        baseBoardNode.geometry?.firstMaterial?.diffuse.wrapS = SCNWrapMode.Repeat
        baseBoardNode.geometry?.firstMaterial?.doubleSided = true
        baseBoardNode.geometry?.firstMaterial?.locksAmbientWithDiffuse = true
        baseBoardNode.position = SCNVector3Make(0, -wallWithBaseboardNode.position.y + 4, 0.5)
        baseBoardNode.castsShadow = false
        
        
        
        wallWithBaseboardNode.addChildNode(baseBoardNode)
        _scene.rootNode.addChildNode(wallWithBaseboardNode)
        
        
    }
    
    func setupInitial() {
        // initial dark lighting
        _ambientLightNode.light?.color = SKColor.blackColor()
        _spotLightNode.light?.color = SKColor.blackColor()
        _spotLightNode.position = SCNVector3Make(50, 90, -50)
        _spotLightNode.eulerAngles = SCNVector3Make(CFloat(-M_PI_2)*0.75, CFloat(M_PI_4)*0.5, 0)
        
        _rollingBall = SCNNode(geometry: SCNSphere(radius: BALL_RADIUS))
        _rollingBall.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "balldimpled.png")
        _rollingBall.geometry?.firstMaterial?.emission.contents = UIImage(named: "balldimpled.png")
        _rollingBall.geometry?.firstMaterial?.emission.intensity = 0
        _rollingBall.physicsBody = SCNPhysicsBody(type: SCNPhysicsBodyType.Dynamic, shape: nil)
        _rollingBall.physicsBody?.restitution = 1.0
        _rollingBall.physicsBody?.angularVelocity = SCNVector4(x: 1, y: 1, z: 1, w: 1)
        
        let position = SCNVector3Make(200, 0, 1000)
        _rollingBall.position = position
        _rollingBall.position.y += CFloat(BALL_RADIUS * 8)
        
        _scene.rootNode.addChildNode(_rollingBall)
        
        SCNTransaction.begin()
        SCNTransaction.setAnimationDuration(1.0)
        
        SCNTransaction.setCompletionBlock() {
            SCNTransaction.begin()
            SCNTransaction.setAnimationDuration(2.5)
            self._spotLightNode.light?.color = SKColor(white: 1, alpha: 1)
            SCNTransaction.commit()
            
        }
        
        _spotLightNode.light?.color = SKColor(white: 0.001, alpha: 1)
        SCNTransaction.commit()
        
        
    }
    
    override func shouldAutorotate() -> Bool {
        return true
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return UIInterfaceOrientationMask.AllButUpsideDown
        } else {
            return UIInterfaceOrientationMask.All
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
}