//
//  ViewController.swift
//  FetchImagesTest
//
//  Created by Jung Hyun Kim on 2023/02/26.
//

import UIKit


class ViewController: UIViewController {
    
    @IBOutlet weak var imageOne: UIImageView!
    @IBOutlet weak var imageTwo: UIImageView!
    @IBOutlet weak var imageThree: UIImageView!
    @IBOutlet weak var imageFour: UIImageView!
    @IBOutlet weak var imageFive: UIImageView!
    
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    @IBOutlet weak var button4: UIButton!
    @IBOutlet weak var button5: UIButton!
    @IBOutlet weak var loadAllImagesButton: UIButton!
    
    let imageUrls = [
        "https://www.edsys.in/wp-content/uploads/0bb15fd89591ca05d13d4095227f65f1.jpg",
        "https://i.pinimg.com/736x/d5/53/92/d553920584b63dc1ae3bad1f5b3ccedd.jpg",
        "https://www.cartonionline.com/gif/CARTOON/hanna_e_barbera/scooby-doo/Scooby-doo_08.jpg",
        "https://easydrawingart.com/wp-content/uploads/2019/08/How-to-draw-a-cartoon-character-1.jpg",
        "https://i.pinimg.com/originals/c3/bd/27/c3bd278b8ec64126e0033e1437716616.png"
    ]
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        
    }
    
    func configUI() {
        [imageOne, imageTwo, imageThree, imageFour, imageFive].forEach {
            $0.image = UIImage(systemName: "photo")
        }
        let buttons = [button1, button2, button3, button4, button5, loadAllImagesButton]
        for button in buttons {
            button?.layer.cornerRadius = 5
        }
    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        let imageView: UIImageView
        let index: Int
        
        switch sender {
        case button1:
            imageView = imageOne
            index = 0
        case button2:
            imageView = imageTwo
            index = 1
        case button3:
            imageView = imageThree
            index = 2
        case button4:
            imageView = imageFour
            index = 3
        case button5:
            imageView = imageFive
            index = 4
        default:
            fatalError("Unknown Button")
        }
        
        imageView.load(urlString: imageUrls[index])
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            imageView.image = UIImage(systemName: "photo")
            imageView.contentMode = .scaleAspectFit
            imageView.clipsToBounds = true
        }
    }
    
    
    @IBAction func loadAllImagesButtonTapped(_ sender: UIButton) {
        
        [imageOne, imageTwo, imageThree, imageFour, imageFive].enumerated().forEach { index, imageView in
            imageView.load(urlString: imageUrls[index])
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [self] in
            [imageOne, imageTwo, imageThree, imageFour, imageFive].forEach {
                $0.image = UIImage(systemName: "photo")
            }
        }

    }
    
}



// MARK: Image Cache & Image Load
var imageCache = NSCache<AnyObject, AnyObject>()

extension UIImageView {
    func load(urlString: String) {
        if let image = imageCache.object(forKey: urlString as NSString) as? UIImage {
            self.image = image
            return
        }
        guard let url = URL(string: urlString) else { return }
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        imageCache.setObject(image, forKey: urlString as NSString)
                        self?.image = image
                    }
                }
            }
        }
    }
}
