//
//  FeedViewController.swift
//  
//
//  Created by Anthony Ronca on 3/7/19.
//

import UIKit
import Parse
import MessageInputBar

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate, MessageInputBarDelegate {
    

    @IBOutlet var tableView: UITableView!
    
    let commentBar = MessageInputBar()
    var showsCommentBar = false
    
    var posts = [PFObject] ( )
    var selectedPost: PFObject!
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let post = posts[section]
        let comments = (post["comments"] as? [PFObject]) ?? [ ] // Double question mark makes a nil value turn to the default.
        
        // returns post and comments plus extra row for adding a comment
        return  comments.count + 2
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let post = posts[indexPath.section]  //
        let comments = (post["comments"] as? [PFObject]) ?? [ ]
        
        if indexPath.row == 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as! PostCell
            
            
            let user = post["author"] as! PFUser
            cell.usernameLabel.text = user.username
            
            cell.captionLabel.text = post["caption"] as? String
            
            
            let imageFile = post["image"] as! PFFileObject
            let urlString = imageFile.url!
            let url = URL(string: urlString)!
            
            cell.photoView.af_setImage(withURL: url)
            
            return cell
        
        } else if indexPath.row <= comments.count {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell") as! CommentCell
            
            //  Must cast when coming out of dictionary
            let comment = comments[indexPath.row - 1]
            cell.commentLabel.text = comment["text"] as? String
            
            let user = comment["author"] as! PFUser
            cell.nameLabel.text = user.username // changed as? String to no as? string
            
            
            return cell
            
        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddCommentCell")!
            
            return cell
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let query = PFQuery(className:"Posts")
        query.includeKeys(["author", "comments", "comments.author"])
        query.limit = 20
        
    //  Descending order caused by code
        //query.includeKey("created_at")
        //query.order(byDescending: "created_at")
        
        query.findObjectsInBackground { ( posts, error ) in
            if posts != nil{
                self.posts = posts!
                print(self.posts )
                self.tableView.reloadData()
            }
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        commentBar.inputTextView.placeholder = "Add a Comment..."
        commentBar.sendButton.title = "Post"
        commentBar.delegate = self
        
        tableView.delegate = self
        tableView.dataSource = self

        // dismisses keyboard by dragging down on Table View
        tableView.keyboardDismissMode = .interactive
        
        //  Passes event notification
        let center = NotificationCenter.default
        center.addObserver(self, selector: #selector(keyboardWillBeHidden(note:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    @objc func keyboardWillBeHidden(note: Notification) {
        //  clear commentBar on dismissal
        commentBar.inputTextView.text = nil

        showsCommentBar = false
        becomeFirstResponder()
        
    }
    
    override var inputAccessoryView: UIView? {
        return commentBar
        
    }
    
    override var canBecomeFirstResponder: Bool {
        return showsCommentBar
        
    }
    
    
    @IBAction func onLogoutButton(_ sender: Any) {
        // Tells Parse Server we are logged out
        PFUser.logOut()
        
        // ##Programmatically switch to another screen
        
        //  Set destination as main
        let main = UIStoryboard(name: "Main", bundle: nil)
        //  create variable that points to destination
        let loginViewController = main.instantiateViewController(withIdentifier: "LoginViewController")
        //  set as delegate since it's a subclass of AppDelegate
       let delegate = UIApplication.shared.delegate as! AppDelegate
        //  Complete transition
        delegate.window?.rootViewController = loginViewController
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Allows user to select a post and add comments
        
        let post = posts[indexPath.section]
        let comments = (post["comments"] as? [PFObject]) ?? [ ]
        
        //  If it's the last cell, show comments
        if indexPath.row == comments.count + 1 {
          showsCommentBar = true
            becomeFirstResponder()
            commentBar.inputTextView.becomeFirstResponder()
            
            selectedPost = post
            
        }
        
       func messageInputBar(_ inputBar: MessageInputBar, didPressSendButtonWith text: String){
       // create comment
        let comment = PFObject(className: "Comments")
        comment["text"] = text
        comment["post"] = selectedPost
        comment["author"] = PFUser.current( )!
        
        // adds an array of comments for each post
        selectedPost.add(comment, forKey: "comments")
        
        selectedPost.saveInBackground { (success, error) in
            if success{
                print("Comment Saved")
            } else {
                print("ERROR - Comment not saved")
            }
            
        }
        
        tableView.reloadData()
        
        
        // clear and dismiss the input bar
        commentBar.inputTextView.text = nil
        showsCommentBar = false
        becomeFirstResponder()
        commentBar.inputTextView.resignFirstResponder()
        }
        
        
    }

}
