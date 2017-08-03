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
class QRCodeScanVC: UIViewController {
    
    deinit{
        WTLog("deinit")
    }
    //session
    let sessionQueue = OperationQueue.init()
    var permission:AVAuthorizationStatus = .notDetermined
    override func viewDidLoad() {
        super.viewDidLoad()
        checkPermission()
        sessionQueue.addOperation { [weak self] in
            self?.configSession()
        }
        
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
        let session:AVCaptureSession = AVCaptureSession.init()
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
        
        OperationQueue.main.addOperation { 
            if let previewLayer = AVCaptureVideoPreviewLayer.init(session: session){
                previewLayer.bounds = self.view.bounds
                previewLayer.position = self.view.layer.position
                self.view.layer.addSublayer(previewLayer)
            }
        }
        
        session.commitConfiguration()
        session.startRunning()
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

}
