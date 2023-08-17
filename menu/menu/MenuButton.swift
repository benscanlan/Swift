import UIKit

class MenuButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupButton()
    }

    private func setupButton() {
        // Create gradient layer for the button background
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [UIColor.systemTeal.cgColor, UIColor.systemBlue.cgColor]
        gradientLayer.cornerRadius = layer.cornerRadius
        layer.insertSublayer(gradientLayer, at: 0)

        // Set other button properties (you can customize these as needed)
        setTitleColor(.white, for: .normal)
        titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        // Update the gradient layer frame to match the button's bounds
        layer.sublayers?.first?.frame = bounds
    }
}
