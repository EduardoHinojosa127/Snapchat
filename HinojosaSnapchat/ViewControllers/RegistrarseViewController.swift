//
//  RegistrarseViewController.swift
//  HinojosaSnapchat
//
//  Created by Mac 04 on 7/06/23.
//

import UIKit
import Firebase
import FirebaseAuth

class RegistrarseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var btnCrearCuenta: UIButton!
    
    @IBAction func crearCuenta(_ sender: Any) {
        guard let email = emailTextField.text, let password = passwordTextField.text else {
                    return
                }
                
                // Crear usuario en Firebase Auth
                Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
                    if let error = error {
                        // Si hay un error al crear el usuario, mostrar un mensaje al usuario
                        print("Error al crear la cuenta:", error.localizedDescription)
                        let alerta = UIAlertController(title: "Creación de cuenta", message: "Ocurrió un error al momento de crear la cuenta, intentelo de nuevo mas tarde", preferredStyle: .alert)
                        let btnOK = UIAlertAction(title: "Aceptar", style: .default, handler: { (UIAlertAction) in
                        })
                        alerta.addAction(btnOK)
                        self.present(alerta, animated: true, completion: nil)
                        // Aquí puedes mostrar una alerta o un mensaje en un label para informar al usuario sobre el error.
                    } else {
                        // El usuario se ha creado exitosamente
                        print("Cuenta creada exitosamente")
                        Database.database().reference().child("usuarios").child(user!.user.uid).child("email").setValue(user!.user.email)
                        let alerta = UIAlertController(title: "Creación de cuenta", message: "Cuenta creada exitosamente", preferredStyle: .alert)
                        let btnOK = UIAlertAction(title: "Aceptar", style: .default, handler: { (UIAlertAction) in
                            self.performSegue(withIdentifier: "iniciarsegue", sender: nil)
                        })
                        alerta.addAction(btnOK)
                        self.present(alerta, animated: true, completion: nil)
                        // Aquí puedes realizar alguna acción adicional, como redirigir al usuario a otra pantalla
                    }
                }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
