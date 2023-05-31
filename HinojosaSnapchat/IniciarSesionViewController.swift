//
//  ViewController.swift
//  HinojosaSnapchat
//
//  Created by Mac 04 on 31/05/23.
//

import UIKit
import Firebase
import FirebaseAuth
import GoogleSignIn

class IniciarSesionViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
        
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var googleButton: UIButton!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBAction func iniciarGoogle(_ sender: Any) {
        GIDSignIn.sharedInstance.signIn(withPresenting: self)
        
    }
    @IBAction func IniciarSesionTapped(_ sender: Any) {
        // Start the sign in flow!
                GIDSignIn.sharedInstance.signIn(withPresenting: self) { [unowned self] result, error in
                  guard error == nil else {
                    return
                  }

                  guard let user = result?.user,
                    let idToken = user.idToken?.tokenString
                  else {
                    return
                  }

                  let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                                 accessToken: user.accessToken.tokenString)

                  // ...
                }
    }
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        return GIDSignIn.sharedInstance.handle(url)
    }

}

