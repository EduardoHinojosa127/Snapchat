//
//  ImagenViewController.swift
//  HinojosaSnapchat
//
//  Created by Mac 04 on 7/06/23.
//

import UIKit
import FirebaseStorage
import AVFoundation

class ImagenViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var audioURL: URL?
    var audioURLString = ""
    var imagenurl = ""
    var grabarAudio: AVAudioRecorder?
    var reproducirAudio: AVAudioPlayer?
    var imagePicker = UIImagePickerController()
    var imagenID = NSUUID().uuidString
    var audioID = NSUUID().uuidString
    @IBAction func camaraTapped(_ sender: Any) {
        imagePicker.sourceType = .savedPhotosAlbum
        imagePicker.allowsEditing = false
        present(imagePicker, animated: true, completion: nil)
    }
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var descripcionTextField: UITextField!
    @IBOutlet weak var elegirContactoBoton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        elegirContactoBoton.isEnabled = false
        configurarGrabacion()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func elegirContactoTapped(_ sender: Any) {
        self.elegirContactoBoton.isEnabled = false
        let imagenesFolder = Storage.storage().reference().child("imagenes")
        let imagenData = imageView.image?.jpegData(compressionQuality: 0.50)
        let cargarImagen = imagenesFolder.child("\(imagenID).jpg")
        
        let audiosFolder = Storage.storage().reference().child("audios")
        let audioData = try? Data(contentsOf: self.audioURL!)
        let uploadAudio = audiosFolder.child("\(self.audioID).m4a")
        
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        
            cargarImagen.putData(imagenData!, metadata: nil) { (metadata, error) in
                if error != nil {
                    self.mostrarAlerta(titulo: "Error", mensaje: "Se produjo un error al subir la imagen. Verifique su conexion a internet y vuelva a intentarlo", accion: "Aceptar")
                    self.elegirContactoBoton.isEnabled = true
                    print("Ocurrió un error al subir imagen \(error)")
                    return
                }else{
                    cargarImagen.downloadURL(completion: {(url, error) in
                        if let url = url{
                            self.imagenurl = url.absoluteString
                            print("URL de la imagen subida: \(self.imagenurl)")
                        }else{
                            print("Ocurrió un error al obtener la url de la imagen subida: \(error)")
                            self.mostrarAlerta(titulo: "Error", mensaje: "Se produjo un error al obtener la informacion de la imagen", accion: "Cancelar")
                            self.elegirContactoBoton.isEnabled = true
                        }
                        dispatchGroup.leave()
                        //self.performSegue(withIdentifier: "seleccionarContactoSegue", sender: url?.absoluteString)
                    })
                }
            }
        dispatchGroup.enter()
        uploadAudio.putData(audioData!, metadata: nil){ (metadata, error) in
            if let error = error{
                print("Ocurrió un error al subir el audio: \(error)")
                self.mostrarAlerta(titulo: "Error", mensaje: "Se produjo un error al subir el audio", accion: "Aceptar")
                self.elegirContactoBoton.isEnabled = true
            }else{
                uploadAudio.downloadURL {(url, error) in
                    if let url = url{
                        self.audioURLString = url.absoluteString
                        print("URL del audio subido: \(self.audioURLString)")
                    }else{
                        print("Ocurrió un error al obtener la url del audio subido: \(error)")
                    }
                    dispatchGroup.leave()
                    
                }
            }
            
        }
        
        dispatchGroup.notify(queue: .main){
            var senderURLS: [String: Any] = ["urlImagen":self.imagenurl, "urlAudio": self.audioURLString]
            print(senderURLS)
            self.performSegue(withIdentifier: "seleccionarContactoSegue", sender: senderURLS)
        }
        
        /*let alertaCarga = UIAlertController(title: "Cargando Imagen ...", message: "0%", preferredStyle: .alert)
        let progresoCarga: UIProgressView = UIProgressView(progressViewStyle: .default)
        cargarImagen.observe(.progress) { (snapshot) in
            let porcentaje = Double(snapshot.progress!.completedUnitCount) / Double(snapshot.progress!.totalUnitCount)
            print(porcentaje)
            progresoCarga.setProgress(Float(porcentaje), animated: true)
            progresoCarga.frame = CGRect(x: 10, y: 70, width: 250, height: 0)
            alertaCarga.message = String(round(porcentaje*100.0)) + " %"
            if porcentaje >= 1.0{
                alertaCarga.dismiss(animated: true, completion: nil)
            }
        }
        let btnOk = UIAlertAction(title: "Aceptar", style: .default, handler: nil)
        alertaCarga.addAction(btnOk)
        alertaCarga.view.addSubview(progresoCarga)
        present(alertaCarga, animated: true, completion: nil)*/
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        imageView.image = image
        imageView.backgroundColor = UIColor.clear
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let senderDict = sender as? [String: Any]{
            let siguienteVC = segue.destination as! ElegirUsuarioViewController
            siguienteVC.imagenURL = senderDict["urlImagen"] as? String ?? ""
            siguienteVC.audioURL = senderDict["urlAudio"] as? String ?? ""
            
            siguienteVC.descrip = descripcionTextField.text!
            siguienteVC.imagenID = imagenID
            
            siguienteVC.audioID = audioID
        }
    }
    
    func mostrarAlerta(titulo: String, mensaje: String, accion: String){
        let alerta = UIAlertController(title: titulo, message: mensaje, preferredStyle: .alert)
        let btnCANCELOK = UIAlertAction(title: accion, style: .default, handler: nil)
        alerta.addAction(btnCANCELOK)
        present(alerta, animated: true, completion: nil)
    }
    
    @IBOutlet weak var btnGrabar: UIButton!
    @IBOutlet weak var btnPlay: UIButton!
    @IBOutlet weak var txtNombreaudio: UITextField!

    @IBAction func grabar(_ sender: Any) {
        if grabarAudio!.isRecording{
                   grabarAudio?.stop()
                  
                    
                   btnGrabar.setTitle("GRABAR", for: .normal)
                    btnPlay.isEnabled = true
            elegirContactoBoton.isEnabled = true
                }else{
                   grabarAudio?.record()
                   btnGrabar.setTitle("DETENER", for: .normal)
                    btnPlay.isEnabled = false
                }
    }
     
    @IBAction func play(_ sender: Any) {
        do{
                   try reproducirAudio = AVAudioPlayer(contentsOf: audioURL!)
                   reproducirAudio!.play()
                   print("Reproduciendo")
                }catch{}
    }
    
    func configurarGrabacion(){
           do{
               let session = AVAudioSession.sharedInstance()
               try session.setCategory(AVAudioSession.Category.playAndRecord, mode:AVAudioSession.Mode.default, options: [])
               try session.overrideOutputAudioPort(.speaker)
               try session.setActive(true)


               let basePath:String = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask,true).first!
               let pathComponents = [basePath,"audio.m4a"]
               audioURL = NSURL.fileURL(withPathComponents: pathComponents)!


               print("*****************")
               print(audioURL!)
               print("*****************")


               var settings:[String:AnyObject] = [:]
               settings[AVFormatIDKey] = Int(kAudioFormatMPEG4AAC) as AnyObject?
               settings[AVSampleRateKey] = 44100.0 as AnyObject?
               settings[AVNumberOfChannelsKey] = 2 as AnyObject?


               grabarAudio = try AVAudioRecorder(url:audioURL!, settings: settings)
               grabarAudio!.prepareToRecord()
           }catch let error as NSError{
               print(error)
           }
        }
    /*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
