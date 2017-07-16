//
//  ProfileViewController.swift
//  ParseProject
//
//  Created by John Zoldos on 7/13/17.
//  Copyright © 2017 John Zoldos. All rights reserved.
//

import UIKit
import Parse

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var user: PFUser?
    var posts: [PFObject]?

    override func viewDidLoad() {
        super.viewDidLoad()
        retrievePosts()
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

  
    @IBAction func photoLibrary(_ sender: UIButton) {
        let vc = UIImagePickerController()
        vc.delegate = self
        vc.allowsEditing = true
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            vc.sourceType = .camera
        } else {
            vc.sourceType = .photoLibrary
        }
        self.present(vc, animated: true, completion: nil)

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let posts = posts {
            return posts.count
        } else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PhotoCell", for: indexPath) as! PhotoCell
        let post = posts![indexPath.row] as! PFObject
        let caption = post["caption"] as? String
        let file = post["media"] as? PFFile
        if let file = file {
            file.getDataInBackground({ (imageData: Data?, error: Error?) -> Void in
                let image = UIImage(data: imageData!)
                if image != nil {
                    cell.post = Post(image: image!, caption: caption!)
                }
            })
        }
        return cell
        /* init(parseObject: PFObject){
         self.caption = parseObject["caption"] as? String
         let file = parseObject["media"] as? PFFile
         if let file = file {
         file.getDataInBackground({ (imageData: Data?, error: Error?) -> Void in
         let image = UIImage(data: imageData!)
         if image != nil {
         self.image = image
         }
         })
         }
         
         
         
         }*/
        
    }
    
    
    @IBAction func onLogOut(_ sender: UIButton) {
        PFUser.logOutInBackground { (error: Error?) in
            if(error != nil) {
                print(error!.localizedDescription)
            } else {
                print("Logged Out")
                
                NotificationCenter.default.post(name: Notification.Name(rawValue: "UserDidLogout") as NSNotification.Name, object: nil)
            }
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : Any]) {
        // Get the image captured by the UIImagePickerController
        let originalImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        //let editedImage = info[UIImagePickerControllerEditedImage] as! UIImage
        //let newSize = CGSize(width: 150, height: 150)
        //let image = resize(image: originalImage, newSize: newSize)
        // Do something with the images (based on your use case)
        let post = Post(image: originalImage, caption: "Different Caption!")
        post.postUserImage{ (success: Bool, error: Error?) in
            if success {
                print ("image was posted")
            } else {
                print(error?.localizedDescription)
            }
        }
        // Dismiss UIImagePickerController to go back to your original view controller
        dismiss(animated: true, completion: nil)
    }
    
    
    func resize(image: UIImage, newSize: CGSize) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        let resizeImageView = UIImageView(frame: rect)
        resizeImageView.contentMode = UIViewContentMode.scaleAspectFill
        resizeImageView.image = image
        
        UIGraphicsBeginImageContext(resizeImageView.frame.size)
        resizeImageView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    
    
    func retrievePosts(){
        // construct PFQuery
        //let predicate = NSPredicate(format: "fromUser = %@", PFUser.current()!)
        let query = PFQuery(className: "Post")
        query.order(byDescending: "createdAt")
        query.includeKey("author")
        query.limit = 20
        
        // fetch data asynchronously
        query.findObjectsInBackground { (posts: [PFObject]?, error: Error?) -> Void in
            if let posts = posts {
                self.posts = posts
                self.tableView.dataSource = self
                self.tableView.delegate = self
                self.tableView.rowHeight = UITableViewAutomaticDimension
                self.tableView.estimatedRowHeight = 120

                print(posts)
                
            } else {
                print(error?.localizedDescription)
            }
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
