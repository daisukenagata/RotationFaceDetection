//
//  AVPlayereObject.swift
//  FaceDetectionRotation
//
//  Created by 永田大祐 on 2020/12/05.
//

import UIKit
import AVFoundation


class AVPlayereObject: NSObject, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    var imageView = UIImageView()

    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {

        imageView.image = UIImageFromCMSamleBuffer(buffer: sampleBuffer)
        imageView.image = imageView.image?.horizontalInversion()
    }
    
    func UIImageFromCMSamleBuffer(buffer:CMSampleBuffer)-> UIImage {
        let pixelBuffer:CVImageBuffer = CMSampleBufferGetImageBuffer(buffer)!
        let ciImage = CIImage(cvPixelBuffer: pixelBuffer)

        let pixelBufferWidth = CGFloat(CVPixelBufferGetWidth(pixelBuffer))
        let pixelBufferHeight = CGFloat(CVPixelBufferGetHeight(pixelBuffer))
        let imageRect:CGRect = CGRect(x:0,y:0, width: pixelBufferWidth, height: pixelBufferHeight)
        let ciContext = CIContext.init()
        guard let cgimage = ciContext.createCGImage(ciImage, from: imageRect ) else { return UIImage() }
        let uiImage = UIImage(cgImage: cgimage, scale: 0, orientation: UIImage(cgImage: cgimage).imageOrientation)

        return uiImage
    }
    
    //キャプチャセッションに入力（オーディオやビデオなど）を提供し、ハードウェア固有のキャプチャ機能のコントロールを提供するデバイス。
    var captureDevice  = AVCaptureDevice.default(for: .video)
    var stillImageOutput: AVCaptureMovieFileOutput?//静止画、ライブ写真、その他の写真ワークフローの出力をキャプチャします。

    
    private var captureSession = AVCaptureSession()
    private var videoDevice = AVCaptureDevice.default(for: AVMediaType.video)
    private var videoOutput = AVCaptureVideoDataOutput()
    private var videoLayer : AVCaptureVideoPreviewLayer? = nil
    
    func inSideOutSideCameraSet(_ view: UIImageView) {
        imageView = view
        captureSession = AVCaptureSession()
        videoOutput = AVCaptureVideoDataOutput()
        videoDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front)
        
        do {
            let videoInput = try AVCaptureDeviceInput(device: videoDevice!) as AVCaptureDeviceInput
            captureSession.addInput(videoInput)
        } catch let error as NSError {
            print(error)
        }
        
        videoOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as AnyHashable as! String : Int(kCVPixelFormatType_32BGRA)]
        
        videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue.main)
        videoOutput.alwaysDiscardsLateVideoFrames = true
        
        captureSession.addOutput(videoOutput)
        
        for connection in self.videoOutput.connections {
            connection.videoOrientation = .portrait
        }

        var previewLayer: AVCaptureVideoPreviewLayer?

        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)

        previewLayer?.videoGravity = AVLayerVideoGravity.resizeAspect

        previewLayer?.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
        self.imageView.layer.addSublayer(previewLayer!)

        self.captureSession.startRunning()
    }
}

extension UIImage {
    func horizontalInversion() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, CGFloat(1.0))
        let imageRef = self.cgImage
        let context = UIGraphicsGetCurrentContext()
        context?.translateBy(x: size.width, y:  size.height)
        context?.scaleBy(x: -1.0, y: -1.0)
        context?.draw(imageRef!, in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let flipHorizontalImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return flipHorizontalImage!
    }
}
