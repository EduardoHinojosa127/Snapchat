//
//  ElegirUsuarioViewController.swift
//  HinojosaSnapchat
//
//  Created by Mac 04 on 7/06/23.
//

import UIKit
import Firebase

class ElegirUsuarioViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usuarios.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let usuario = usuarios[indexPath.row]
        cell.textLabel?.text = usuario.email
        return cell
    }
    

    @IBOutlet weak var listaUsuarios: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        listaUsuarios.delegate = self
        listaUsuarios.dataSource = self
        
        Database.database().reference().child("usuarios").getData { (error, snapshot) in
                if let error = error {
                    print("Error al obtener los datos de Firebase: \(error.localizedDescription)")
                    return
                }
                
            guard let usuariosSnapshot = snapshot!.children.allObjects as? [DataSnapshot] else {
                    return
                }
                
                for usuarioSnapshot in usuariosSnapshot {
                    if let email = usuarioSnapshot.childSnapshot(forPath: "email").value as? String {
                        let usuario = Usuario()
                        usuario.email = email
                        self.usuarios.append(usuario)
                    }
                }
                
                self.listaUsuarios.reloadData()
            }
        // Do any additional setup after loading the view.
    }
    
    var usuarios:[Usuario] = []
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
