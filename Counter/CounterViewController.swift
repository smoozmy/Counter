//
//  ViewController.swift
//  Counter
//
//  Created by Александр Крапивин on 16.03.2024.
//

import UIKit

class CounterViewController: UIViewController {
    
    // MARK: - UI and Lyfe Cycle
    
    private var counter = 0
    
    private lazy var mainStackView: UIStackView = {
        let element = UIStackView()
        element.axis = .vertical
        element.alignment = .fill
        element.distribution = .fill
        element.spacing = 20
        
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var logoImageView: UIImageView = {
        let element = UIImageView()
        element.image = UIImage(named: "logo")
        element.contentMode = .scaleAspectFit
        
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var counterLabel: UILabel = {
        let element = UILabel()
        element.text = "\(counter)"
        element.textAlignment = .center
        element.font = .systemFont(ofSize: 72)
        element.textColor = .black
        
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var historyTextView: UITextView = {
        let element = UITextView()
        element.isEditable = false
        element.layer.cornerRadius = 15
        element.font = .systemFont(ofSize: 18)
        element.textColor = .darkGray
        
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var buttonsStackView: UIStackView = {
        let element = UIStackView()
        element.axis = .horizontal
        element.alignment = .fill
        element.distribution = .fillEqually
        element.spacing = 40
        
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var plusButton: UIButton = {
        let element = UIButton(type: .system)
        element.setTitle("+", for: .normal)
        element.titleLabel?.font = .systemFont(ofSize: 36)
        element.tintColor = .white
        element.layer.cornerRadius = 15
        element.backgroundColor = UIColor(named: "plusButton")
        element.addTarget(self, action: #selector(plusButtonTapped), for: .touchUpInside)
        
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var minusButton: UIButton = {
        let element = UIButton(type: .system)
        element.setTitle("-", for: .normal)
        element.titleLabel?.font = .systemFont(ofSize: 36)
        element.tintColor = .white
        element.layer.cornerRadius = 15
        element.backgroundColor = UIColor(named: "minusButton")
        element.addTarget(self, action: #selector(minusButtonTapped), for: .touchUpInside) // Добавление функции при нажатии
        
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var zeroButton: UIButton = {
        let element = UIButton(type: .system)
        element.setTitle("Сброс", for: .normal)
        element.titleLabel?.font = .systemFont(ofSize: 18)
        element.tintColor = .white
        element.layer.cornerRadius = 15
        element.backgroundColor = UIColor(named: "zeroButton")
        element.addTarget(self, action: #selector(zeroButtonTapped), for: .touchUpInside) // Добавление функции при нажатии
        
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setView()
        setupConstraints()
        
        view.backgroundColor = UIColor(named: "backgroundColor")
        updateHistoryTextView(with: "История изменений:\n")
        
    }
    
    private func setView() {
        view.addSubview(mainStackView)
        mainStackView.addArrangedSubview(logoImageView)
        mainStackView.addArrangedSubview(counterLabel)
        mainStackView.addArrangedSubview(historyTextView)
        mainStackView.addArrangedSubview(buttonsStackView)
        buttonsStackView.addArrangedSubview(minusButton)
        buttonsStackView.addArrangedSubview(plusButton)
        mainStackView.addArrangedSubview(zeroButton)
    }
}


// MARK: - Counter actions and update history

extension CounterViewController {
    
    private func updateHistoryTextView(with text: String) {
        if let currentText = historyTextView.text, currentText.isEmpty {
            historyTextView.text = text
        } else {
            historyTextView.text += "\n\(text)"
        }
    }
    
    private func scrollDown() {
        let range = NSMakeRange(historyTextView.text.count - 1, 0)
        historyTextView.scrollRangeToVisible(range)
    }
    
    @objc private func plusButtonTapped() {
        counter += 1
        let event = "\(getCurrentDateTime()): значение изменено на +1"
        updateHistory(with: event)
        updateCounterLabel()
        scrollDown()
    }
    
    @objc private func minusButtonTapped() {
        if counter > 0 {
            counter -= 1
            let event = "\(getCurrentDateTime()): значение изменено на -1"
            updateHistory(with: event)
            updateCounterLabel()
        } else {
            let event = "\(getCurrentDateTime()): попытка уменьшить значение счетчика ниже 0"
            updateHistory(with: event)
        }
        scrollDown()
    }
    
    @objc private func zeroButtonTapped() {
        counter = 0
        let event = "\(getCurrentDateTime()): значение сброшено"
        updateHistory(with: event)
        updateCounterLabel()
        scrollDown()
    }
    
    private func updateCounterLabel() {
        counterLabel.text = "\(counter)"
    }
    
    private func updateHistory(with event: String) {
        let currentText = historyTextView.text ?? ""
        historyTextView.text = "\(currentText)\n\(event)"
    }
    
    private func getCurrentDateTime() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        return formatter.string(from: Date())
    }
}


// MARK: - Setup constraints

extension CounterViewController {
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -80),
            mainStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            mainStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            counterLabel.heightAnchor.constraint(equalTo: historyTextView.heightAnchor),
            
            buttonsStackView.heightAnchor.constraint(equalToConstant: 70),
            zeroButton.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
}

