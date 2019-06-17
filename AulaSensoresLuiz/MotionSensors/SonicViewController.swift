//
//  SonicViewController.swift
//  MotionSensors
//
//  Created by Luiz Henrique Monteiro de Carvalho on 17/06/19.
//  Copyright © 2019 Bruno Omella Mainieri. All rights reserved.
//

import UIKit
import CoreMotion
import AVFoundation

class SonicViewController: UIViewController {
    
    @IBOutlet weak var SonicIMG: UIImageView!
    @IBOutlet weak var sonicLabel: UILabel!
    var audio = AVAudioPlayer()
    
    var countimg = 1
    var countlabel = 0
    var labels:[String] = ["O SONIC TA PRESO MANO. OLHA ESSA CORRENTE BROTHER.","VIRA UM POUCO MAIS O APARELHO MEU QUERIDO.","O SONIC TA BRABO E RÁPIDO. GOTTA GO FAST."]
    
    
    
    var referenceAttitude:CMAttitude?
    let motion = CMMotionManager()

    override func viewDidLoad() {
        
        sonicLabel.text = labels[countlabel]
        SonicIMG.image = UIImage(named: "sonic\(countimg).png") //----/"bla\().png"
        super.viewDidLoad()
        startDeviceMotion()
        
        let path = Bundle.main.path(forResource: "GreenHill", ofType: "mp3")!
        let url = URL(fileURLWithPath: path)
        do{
            audio = try AVAudioPlayer(contentsOf: url)
            audio.play()
            audio.numberOfLoops = -1
        }
        catch{
            print(error)
        }
        
    }
    
        
        
        
        func startDeviceMotion() {
            if motion.isDeviceMotionAvailable {
                //Frequencia de atualização dos sensores definida em segundos - no caso, 60 vezes por segundo
                self.motion.deviceMotionUpdateInterval = 1.0 / 30.0
                self.motion.showsDeviceMovementDisplay = true
                //A partir da chamada desta função, o objeto motion passa a conter valores atualizados dos sensores; o parâmetro representa a referência para cálculo de orientação do dispositivo
                self.motion.startDeviceMotionUpdates(using: .xMagneticNorthZVertical)
                
                //Um Timer é configurado para executar um bloco de código 60 vezes por segundo - a mesma frequência das atualizações dos dados de sensores. Neste bloco manipulamos as informações mais recentes para atualizar a interface.
                var timer = Timer(fire: Date(), interval: (1.0 / 30.0), repeats: true,
                                  block: { (timer) in
                                    if let data = self.motion.deviceMotion {
                                        var relativeAttitude = data.attitude
                                        if let ref = self.referenceAttitude{
                                            //Esta função faz a orientação do dispositivo ser calculado com relação à orientação de referência passada
                                            relativeAttitude.multiply(byInverseOf: ref)
                                        }
                                        
                                        //let x = relativeAttitude.pitch
                                        let y = relativeAttitude.roll
                                        //let z = relativeAttitude.yaw
                                        
                                        if (y >= 0 && y<=0.20) {
                                            self.SonicIMG.image = UIImage(named: "sonic1.png")
                                            self.sonicLabel.text = self.labels[self.countlabel]
                                            self.countlabel = 0
                                        }
                                        else if (y > 0.20 && y <= 0.65) {
                                            self.SonicIMG.image = UIImage(named: "sonicdir\(self.countimg).png")
                                            self.countimg += 1
                                            if self.countimg >= 8 {
                                                self.countimg = 2
                                                
                                            }
                                            
                                            self.countlabel = 1
                                            self.sonicLabel.text = self.labels[self.countlabel]
                                            
                                            
                                            
                                        }
                                        else if (y > 0.65 && y <= 2) {
                                            self.SonicIMG.image = UIImage(named: "sonicdir\(self.countimg).png")
                                            self.countimg += 1
                                            if self.countimg >= 12 {
                                                self.countimg = 9
                                            }
                                            
                                            self.countlabel = 2
                                            self.sonicLabel.text = self.labels[self.countlabel]
                                            
                                        }
                                        
                                        
                                        //----------------------------
                                        else if (y >= -0.20 && y < 0) {
                                            self.SonicIMG.image = UIImage(named: "sonic1.png")
                                            self.sonicLabel.text = self.labels[self.countlabel]
                                            self.countlabel = 0
                                        }
                                            
                                        else if (y >= -0.65 && y < -0.20) {
                                            self.SonicIMG.image = UIImage(named: "sonicesq\(self.countimg).png")
                                            self.countimg += 1
                                            if self.countimg >= 8 {
                                                self.countimg = 2
                                                
                                            }
                                            
                                            self.countlabel = 1
                                            self.sonicLabel.text = self.labels[self.countlabel]
                                            
                                            
                                        }
                                        else if (y >= -2 && y < -0.65) {
                                            self.SonicIMG.image = UIImage(named: "sonicesq\(self.countimg).png")
                                            self.countimg += 1
                                            if self.countimg >= 12 {
                                                self.countimg = 9
                                            }
                                            
                                            self.countlabel = 2
                                            self.sonicLabel.text = self.labels[self.countlabel]
                                            
                                            
                                        }
                                        
                                        
                                        
                                        let gravity = data.gravity
                                        //Um pouco de matemágica para rotacionar o background de acordo com a orientação do dispositivo - neste caso, usando o vetor da gravidade para este cálculo
                                        
                                    }
                })
                
                RunLoop.current.add(timer, forMode: RunLoop.Mode.default)
            }
        }
        
        //Ao tocar na tela, a orientação atual do dispositivo passa a ser considerada a de referência com relação à qual os dados serão calculados
        override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            if let att = motion.deviceMotion?.attitude {
                referenceAttitude = att
            }
        }
        
        
        
        
    }
    


        // Do any additional setup after loading the view.
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


