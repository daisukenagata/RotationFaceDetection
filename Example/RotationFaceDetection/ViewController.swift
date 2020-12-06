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

    // You do not need to set it when displaying in the remote library.
    var av = AVPlayereObject()

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageView2: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        imageView2.image = UIImage(named: "arrow")

        // set the screen to rotate.
        a = VNAngularStructure(v: VNImageRequest(), view: imageView2)

        // You do not need to set it when displaying in the remote library.
        av.inSideOutSideCameraSet(imageView)

        self.view.addSubview(g)
    }

    override func viewDidAppear(_ animeted: Bool) {
        super.viewDidAppear(animeted)

        // tap to detect the angle of rotation.
        g.tapped(view: imageView, v: a?.v)
    }
}
