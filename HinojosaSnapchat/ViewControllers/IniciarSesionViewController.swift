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
import FirebaseDatabase

class IniciarSesionViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
        
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var googleButton: UIButton!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBAction func iniciarGoogle(_ sender: Any) {
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
    @IBAction func IniciarSesionTapped(_ sender: Any) {
        // Start the sign in flow!
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!){ (user, error) in
            print("Intentando Iniciar Sesión")
            if error != nil{
                print("Se presento el siguiente error: \(error)")
                let alerta = UIAlertController(title: "Inicio de sesión", message: "Credenciales incorrectas", preferredStyle: .alert)
                let btnOK = UIAlertAction(title: "Crear", style: .default, handler: { (UIAlertAction) in
                    self.performSegue(withIdentifier: "registrarsegue", sender: nil)
                })
                let btnCancelar = UIAlertAction(title: "Cancelar", style: .default, handler: { (UIAlertAction) in })
                alerta.addAction(btnOK)
                alerta.addAction(btnCancelar)
                self.present(alerta, animated: true, completion: nil)
                
            }else{
                print("Inicio de sesión exitoso")
                self.performSegue(withIdentifier: "iniciarsesionsegue", sender: nil)
            }
        }
    }
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        return GIDSignIn.sharedInstance.handle(url)
    }

}

