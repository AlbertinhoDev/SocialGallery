import UIKit

final class MainTableViewCell: UITableViewCell {

    private var currentPerson: TableCellModel?
    var onLikeButtonTapped: ((TableCellModel) -> Void)?
    
    private lazy var commonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 8
        stackView.axis = .horizontal
        stackView.alignment = .top
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private lazy var leftStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 8
        stackView.alignment = .leading
        stackView.axis = .vertical
        return stackView
    }()
    
    private lazy var rightStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 8
        stackView.alignment = .center
        stackView.axis = .vertical
        return stackView
    }()
    
    private lazy var imagePersonView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .black
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 8
        imageView.backgroundColor = .clear
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var likeButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didTapLikeButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var mainTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.numberOfLines = .zero
        return label
    }()
    
    private lazy var mainBodyLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.numberOfLines = 2
        label.numberOfLines = .zero
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    @objc private func didTapLikeButton() {
        guard let like = currentPerson else { return }
        onLikeButtonTapped?(like)
    }
    
    func configureCell(with model: TableCellModel) {
        imagePersonView.image = model.image
        mainTitleLabel.text = model.title
        mainBodyLabel.text = model.body
        if model.like == false {
            likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
            likeButton.tintColor = UIColor.black
        } else {
            likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            likeButton.tintColor = .red
        }
        currentPerson = model
    }
    
    private func setupCell() {
        backgroundColor = .clear
        contentView.addSubview(commonStackView)
        
        commonStackView.addArrangedSubview(leftStackView)
        commonStackView.addArrangedSubview(rightStackView)
        
        leftStackView.addArrangedSubview(mainTitleLabel)
        leftStackView.addArrangedSubview(mainBodyLabel)
        
        rightStackView.addArrangedSubview(imagePersonView)
        rightStackView.addArrangedSubview(likeButton)
        
        NSLayoutConstraint.activate([
            commonStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            commonStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            commonStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            commonStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            imagePersonView.widthAnchor.constraint(equalToConstant: 150),
            imagePersonView.heightAnchor.constraint(equalToConstant: 200),
            
            likeButton.widthAnchor.constraint(equalToConstant: 30),
            likeButton.heightAnchor.constraint(equalToConstant: 24),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

