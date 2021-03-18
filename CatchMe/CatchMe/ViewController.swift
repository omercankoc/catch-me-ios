import UIKit

class ViewController: UIViewController {
    
    var timer = Timer()
    var visibilityTimer = Timer()
    
    var time : Int = 60
    var score : Int = 0
    var highScore : Int = 0
    
    var points = [UIImageView]()

    @IBOutlet weak var labelTime: UILabel!
    @IBOutlet weak var labelScore: UILabel!
    @IBOutlet weak var labelHighScore: UILabel!
    
    @IBOutlet weak var point11: UIImageView!
    @IBOutlet weak var point12: UIImageView!
    @IBOutlet weak var point13: UIImageView!
    @IBOutlet weak var point21: UIImageView!
    @IBOutlet weak var point22: UIImageView!
    @IBOutlet weak var point23: UIImageView!
    @IBOutlet weak var point31: UIImageView!
    @IBOutlet weak var point32: UIImageView!
    @IBOutlet weak var point33: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        labelTime.text = String(time)
        labelScore.text = "Score : \(score)"
        
        // Hish Score degerini kontrol et.
        let storedHighScore = UserDefaults.standard.object(forKey: "highScore")
        if storedHighScore == nil{
            highScore = 0
            labelHighScore.text = "High Score : \(highScore)"
        }
        if let newScore = storedHighScore as? Int{
            highScore = newScore
            labelHighScore.text = "High Score : \(highScore)"
        }
        
        // Nesneyi tiklanabilir yap.
        point11.isUserInteractionEnabled = true
        point12.isUserInteractionEnabled = true
        point13.isUserInteractionEnabled = true
        point21.isUserInteractionEnabled = true
        point22.isUserInteractionEnabled = true
        point23.isUserInteractionEnabled = true
        point31.isUserInteractionEnabled = true
        point32.isUserInteractionEnabled = true
        point33.isUserInteractionEnabled = true
        
        
        // Nesneye tiklandiginda yapilacak operasyonu tanimla.
        let recognizer11 = UITapGestureRecognizer(target: self, action: #selector(increaseScore))
        let recognizer12 = UITapGestureRecognizer(target: self, action: #selector(increaseScore))
        let recognizer13 = UITapGestureRecognizer(target: self, action: #selector(increaseScore))
        let recognizer21 = UITapGestureRecognizer(target: self, action: #selector(increaseScore))
        let recognizer22 = UITapGestureRecognizer(target: self, action: #selector(increaseScore))
        let recognizer23 = UITapGestureRecognizer(target: self, action: #selector(increaseScore))
        let recognizer31 = UITapGestureRecognizer(target: self, action: #selector(increaseScore))
        let recognizer32 = UITapGestureRecognizer(target: self, action: #selector(increaseScore))
        let recognizer33 = UITapGestureRecognizer(target: self, action: #selector(increaseScore))
        
        // Tiklacak nesne ile tiklama operasyonunu bagla.
        point11.addGestureRecognizer(recognizer11)
        point12.addGestureRecognizer(recognizer12)
        point13.addGestureRecognizer(recognizer13)
        point21.addGestureRecognizer(recognizer21)
        point22.addGestureRecognizer(recognizer22)
        point23.addGestureRecognizer(recognizer23)
        point31.addGestureRecognizer(recognizer31)
        point32.addGestureRecognizer(recognizer32)
        point33.addGestureRecognizer(recognizer33)
        
        points = [point11,point12,point13,point21,point22,point23,point31,point32,point33]
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timeCounter), userInfo: nil, repeats: true)
        
        visibilityTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(visibilityPoints), userInfo: nil, repeats: true)
        
        visibilityPoints()
    }
    
    // Noktalari goster veya gizle.
    @objc func visibilityPoints(){
        for point in points{
            point.isHidden = true
        }
        
        // Noktalar dizisinin uzunlugu kadar rasgele sayi olustur.
        let random = Int(arc4random_uniform(UInt32(points.count - 1)))
        // Rasgele noktayi goster.
        points[random].isHidden = false
        
    }
    
    // Score Arttirma Fonksiyonu:
    @objc func increaseScore(){
        score += 1
        labelScore.text = "Score : \(score)"
    }
    
    // Geri Sayac Fonksiyonu:
    @objc func timeCounter(){
        time -= 1
        labelTime.text = String(time)
        
        if(time == 0){
            
            timer.invalidate()
            visibilityTimer.invalidate()
            
            for point in points{
                point.isHidden = true
            }
            
            // En yuksek skoru goster.
            if self.score > self.highScore {
                self.highScore = self.score
                labelHighScore.text = "High Score \(highScore)"
                UserDefaults.standard.set(self.highScore, forKey: "highScore")
            }
            
            // Alert tanimla.
            let alert = UIAlertController(title: "Time is Over!", message: "Do you want to play again?", preferredStyle: UIAlertController.Style.alert)
            // Devam edilmeyecek...
            let no = UIAlertAction(title: "No", style: UIAlertAction.Style.cancel, handler: nil)
            // Devam edilecek...
            let yes = UIAlertAction(title: "Yes", style: UIAlertAction.Style.default) { (UIAlertAction) in
                self.score  = 0
                self.labelScore.text = "Score \(self.score)"
                self.time = 60
                self.labelTime.text = String(self.time)
                self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.timeCounter), userInfo: nil, repeats: true)
                
                self.visibilityTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.visibilityPoints), userInfo: nil, repeats: true)
            }
            alert.addAction(no)
            alert.addAction(yes)
            self.present(alert, animated: true, completion: nil)
            
        }
    }

    // Yeniden baslat...
    @IBAction func restart(_ sender: Any) {
        score  = 0
        labelScore.text = "Score \(score)"
        time = 60
        labelTime.text = String(time)
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timeCounter), userInfo: nil, repeats: true)
        
        visibilityTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(visibilityPoints), userInfo: nil, repeats: true)
    }
    
    
    
}

