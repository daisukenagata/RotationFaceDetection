//
//  ViewController.swift
//  RotationFaceDetection
//
//  Created by dbank0208@gmail.com on 12/06/2020.
//  Copyright (c) 2020 dbank0208@gmail.com. All rights reserved.
//

import UIKit
import RotationFaceDetection

class ViewController: UIViewController {

    var g = VNGetImageView()

    var a: VNAngularStructure?
    
    var v = VNCoreMohtion()

    // You do not need to set it when displaying in the remote library.
    var av = AVPlayereObject()
    
    var images = [UIImage(named: "dbank"),
                  UIImage(named: "dbank2"),
                  UIImage(named: "dbank3"),
                  UIImage(named: "dbank4")]

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageView2: UIImageView!
    
    override var shouldAutorotate: Bool {
        if UIDevice.current.orientation.isPortrait {
            UIDevice.current.setValue(0, forKey: "orientation")
        }
        return D.orientationFlg
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.orientation.isLandscape {
            UIDevice.current.setValue(0, forKey: "orientation")
        }
        return D.duration
    }
    

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)

        if D.orientationFlg == false {
            UIDevice.current.setValue(1, forKey: "orientation")
        } else {
            UIDevice.current.setValue(3, forKey: "orientation")
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()


        // set the screen to rotate.
        a = VNAngularStructure(v: VNImageRequest(), view: imageView2)

        // You do not need to set it when displaying in the remote library.
        // av.inSideOutSideCameraSet(imageView)

        self.view.addSubview(g)
    }

    override func viewDidAppear(_ animeted: Bool) {
        super.viewDidAppear(animeted)

        // tap to detect the angle of rotation.
        g.tapped(view: imageView, v: a?.v)

        // auto rotation
        v.checkMothionStart(interval: 1, v: a?.v ?? VNImageRequest(), images: images)
        
        print(self.v.durationHandOver)
    }
}
