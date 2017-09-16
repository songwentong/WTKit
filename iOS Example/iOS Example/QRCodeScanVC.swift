//
//  QRCodeScanVC.swift
//  WTKit
//
//  Created by SongWentong on 6/8/16.
//  Copyright © 2016 SongWentong. All rights reserved.
//

import UIKit
//二维码扫描
import WTKit
import AVFoundation
public class QRCodeScanVC: UIViewController,AVCaptureMetadataOutputObjectsDelegate {
    
    deinit{
        WTLog("deinit")
    }
    //session
    let sessionQueue = OperationQueue.init()
    let label = UILabel()
    //AVCaptureSession
    let session:AVCaptureSession = AVCaptureSession.init()
    var permission:AVAuthorizationStatus = .notDetermined
    override public func viewDidLoad() {
        super.viewDidLoad()
        checkPermission()
        sessionQueue.addOperation { [weak self] in
            self?.configSession()
        }
        
    }
    override public func viewWillDisappear(_ animated: Bool) {
        stopSession()
        super.viewWillDisappear(animated)
    }
    func addLabel(){
        let frame = self.view.frame
        label.frame = CGRect.init(x: 0, y: 0, width: frame.width, height: frame.height)
        label.backgroundColor = UIColor.black.withAlphaComponent(0.3)
//        label.backgroundColor = UIColor.red
        label.textAlignment = .center
        label.textColor = UIColor.white
        label.numberOfLines = 0;
        label.text = "scanning..."
        self.view.addSubview(label)
    }
    
    func checkPermission(){
        
        let authorizationStatus:AVAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        switch authorizationStatus {
        case .authorized:
            permission = .authorized
            break
        case .notDetermined:
            sessionQueue.isSuspended = true
            AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { [weak self](flag) in
                if flag{
                    self?.permission = .authorized
                }else{
                    self?.permission = .denied
                }
                //resule config queue
                self?.sessionQueue.isSuspended = false
            })
            break
        default:
            permission = .denied
            break
        }
    }

    func configSession(){
        if permission != .authorized {
            return
        }
        
        session.beginConfiguration()
        let videoDevice:AVCaptureDevice = AVCaptureDevice.default(for: AVMediaType.video)!
        do{
            let input = try AVCaptureDeviceInput.init(device: videoDevice)
            if session.canAddInput(input) {
                session.addInput(input)
            }else{
                print("can not add device")
            }
            
        }catch let error as NSError{
            print("\(error)")
        }
        //
        
        let output:AVCaptureMetadataOutput = AVCaptureMetadataOutput.init()
        output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        session.addOutput(output)
        let availableMetadataObjectTypes = output.availableMetadataObjectTypes;
        WTLog("availableMetadataObjectTypes:\(String(describing: availableMetadataObjectTypes))")
        output.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
        
        OperationQueue.main.addOperation {
            let previewLayer = AVCaptureVideoPreviewLayer.init(session: self.session)
            
                previewLayer.bounds = self.view.bounds
                previewLayer.position = self.view.layer.position
                self.view.layer.addSublayer(previewLayer)
                self.addLabel()
            
        }
        
        session.commitConfiguration()
        session.startRunning()
    }
    func stopSession(){
        sessionQueue.addOperation {[weak self] in
            let isRunning =  self?.session.isRunning
            if isRunning == true {
                 self?.session.stopRunning()
            }
        }
    }
    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    public func metadataOutput(captureOutput: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection){
        if metadataObjects.count > 0 {
            if let qrCode:AVMetadataMachineReadableCodeObject = metadataObjects[0] as? AVMetadataMachineReadableCodeObject{
                print("\(String(describing: qrCode.stringValue))")
                label.text = qrCode.stringValue
            }
        }
//        WTLog("captureOutput:\(captureOutput) metadataObjects:\(metadataObjects)  connection:\(connection)")
    }

}
