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
class QRCodeScanVC: UIViewController,AVCaptureMetadataOutputObjectsDelegate {
    
    deinit{
        WTLog("deinit")
    }
    //session
    let sessionQueue = OperationQueue.init()
    let label = UILabel()
    //AVCaptureSession
    let session:AVCaptureSession = AVCaptureSession.init()
    var permission:AVAuthorizationStatus = .notDetermined
    override func viewDidLoad() {
        super.viewDidLoad()
        checkPermission()
        sessionQueue.addOperation { [weak self] in
            self?.configSession()
        }
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        stopSession()
        super.viewWillDisappear(animated)
    }
    func addLabel(){
        let frame = self.view.frame
        label.frame = CGRect.init(x: 0, y: frame.height - 40, width: frame.width, height: 40)
        label.backgroundColor = UIColor.black.withAlphaComponent(0.3)
//        label.backgroundColor = UIColor.red
        label.textAlignment = .center
        label.textColor = UIColor.white
        label.text = "scanning..."
        self.view.addSubview(label)
    }
    
    func checkPermission(){
        
        let authorizationStatus:AVAuthorizationStatus = AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo)
        switch authorizationStatus {
        case .authorized:
            permission = .authorized
            break
        case .notDetermined:
            sessionQueue.isSuspended = true
            AVCaptureDevice.requestAccess(forMediaType: AVMediaTypeVideo, completionHandler: { [weak self](flag) in
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
        let videoDevice:AVCaptureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
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
        output.metadataObjectTypes = [AVMetadataObjectTypeQRCode]
        
        OperationQueue.main.addOperation { 
            if let previewLayer = AVCaptureVideoPreviewLayer.init(session: self.session){
                previewLayer.bounds = self.view.bounds
                previewLayer.position = self.view.layer.position
                self.view.layer.addSublayer(previewLayer)
                self.addLabel()
            }
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
    override func didReceiveMemoryWarning() {
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
    
    public func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!){
        if metadataObjects.count > 0 {
            if let qrCode:AVMetadataMachineReadableCodeObject = metadataObjects[0] as? AVMetadataMachineReadableCodeObject{
                print("\(qrCode.stringValue)")
                label.text = qrCode.stringValue
            }
        }
//        WTLog("captureOutput:\(captureOutput) metadataObjects:\(metadataObjects)  connection:\(connection)")
    }

}
