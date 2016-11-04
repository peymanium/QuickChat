//
//  Camera.swift
//  QuickChat
//
//  Created by Peyman Attarzadeh on 11/2/16.
//  Copyright © 2016 PeymaniuM. All rights reserved.
//

import Foundation
import MobileCoreServices

class Camera
{
    static let imagePickerController = UIImagePickerController()
    static let type = kUTTypeImage as String
    
    class func PresentPhotoLibrary(target: ChatViewController, canEdit: Bool)
    {
        if !UIImagePickerController.isSourceTypeAvailable(.PhotoLibrary) &&
            !UIImagePickerController.isSourceTypeAvailable(.SavedPhotosAlbum)
        {
            return;
        }
        
        if UIImagePickerController.isSourceTypeAvailable(.PhotoLibrary)
        {
            self.imagePickerController.sourceType = .PhotoLibrary
            
            if let availableType = UIImagePickerController.availableMediaTypesForSourceType(.PhotoLibrary)
            {
                if (availableType as NSArray).containsObject(self.type)
                {
                    self.imagePickerController.mediaTypes = [self.type]
                }
            }
        }
        else if UIImagePickerController.isSourceTypeAvailable(.SavedPhotosAlbum)
        {
            self.imagePickerController.sourceType = .SavedPhotosAlbum
            
            if let availableType = UIImagePickerController.availableMediaTypesForSourceType(.SavedPhotosAlbum)
            {
                if (availableType as NSArray).containsObject(self.type)
                {
                    self.imagePickerController.mediaTypes = [self.type]
                }
            }
            
        }
        else
        {
            return;
        }
        
        
        self.imagePickerController.allowsEditing = canEdit
        self.imagePickerController.delegate = target
        
        target.presentViewController(self.imagePickerController, animated: true, completion: nil)
        
    }
    
    
    class func PresentCamera(target: ChatViewController, canEdit: Bool)
    {
        if !UIImagePickerController.isSourceTypeAvailable(.Camera)
        {
            return;
        }
        
        if UIImagePickerController.isSourceTypeAvailable(.Camera)
        {
            self.imagePickerController.sourceType = .Camera
            if let availableType = UIImagePickerController.availableMediaTypesForSourceType(.SavedPhotosAlbum)
            {
                if (availableType as NSArray).containsObject(type)
                {
                    self.imagePickerController.mediaTypes = [type]
                }
            }
            
            if UIImagePickerController.isCameraDeviceAvailable(.Rear)
            {
                self.imagePickerController.cameraDevice = .Rear
            }
            else if UIImagePickerController.isCameraDeviceAvailable(.Front)
            {
                self.imagePickerController.cameraDevice = .Front
            }
            else
            {
                return
            }
            
            self.imagePickerController.allowsEditing = canEdit
            self.imagePickerController.showsCameraControls = true
            self.imagePickerController.delegate = target
            
            target.presentViewController(self.imagePickerController, animated: true, completion: nil)
        }
    }
}
