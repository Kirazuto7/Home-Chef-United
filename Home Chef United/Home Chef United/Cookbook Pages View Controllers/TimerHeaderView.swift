//
//  TimerView.swift
//  Home Chef United
//
//  Created by Jordan Sukhnandan on 4/25/23.
//

import UIKit
import AudioToolbox

// SOURCE: - https://www.hackingwithswift.com/articles/117/the-ultimate-guide-to-timer
class TimerHeaderView: UIView {
    
    lazy var timerImageView: UIImageView = {
        let timerImageView = UIImageView()
        timerImageView.image = UIImage(systemName: "alarm")
        timerImageView.tintColor = UIColor.link
        timerImageView.isUserInteractionEnabled = true
        timerImageView.translatesAutoresizingMaskIntoConstraints = false
        return timerImageView
    }()
    
    lazy var timerTextField: UITextField = {
        let timerTextField = UITextField()
        timerTextField.translatesAutoresizingMaskIntoConstraints = false
        timerTextField.text = "00:00"
        timerTextField.isUserInteractionEnabled = true
        timerTextField.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        timerTextField.textColor = UIColor.link
        timerTextField.borderStyle = .roundedRect
        return timerTextField
    }()
    
    lazy var startPauseButton: UIButton = {
       let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.imageView?.contentMode = .scaleAspectFill
        button.setBackgroundImage(UIImage(systemName: "play.fill"), for: .normal)
        button.tintColor = UIColor.link
        button.isUserInteractionEnabled = true
        return button
    }()
    
    lazy var stopButton: UIButton = {
       let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "stop.fill"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = UIColor.link
        button.isUserInteractionEnabled = true
        return button
    }()
    
    lazy var timerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .equalCentering
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.addArrangedSubview(timerImageView)
        stackView.addArrangedSubview(timerTextField)
        stackView.addArrangedSubview(startPauseButton)
        stackView.addArrangedSubview(stopButton)
        
        return stackView
    }()
    
    lazy var headerView: UIView = {
        let headerView = UIView()
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.backgroundColor = appBackgroundColor
        headerView.addSubview(timerStackView)
        return headerView
    }()
    
    lazy var timerData: [[Int]] = {
        var timerData = [[Int]]()
        var hours = [Int]()
        var minutes = [Int]()
        var seconds = [Int]()
        
        for i in 0...59 {
            minutes.append(i)
            seconds.append(i)
            
            if i <= 23 {
                hours.append(i)
            }
        }
        
        timerData.append(hours)
        timerData.append(minutes)
        timerData.append(seconds)
        return timerData
    }()
    
    let timerPickerView = UIPickerView()
    var selectedHour = 0
    var selectedMinute = 0
    var selectedSecond = 0
    var isPaused: Bool = true // Used to verify when the timer is running and paused, initially timer isn't running until start is pressed
    var totalTime = 0 // Total time in seconds
    var timer = Timer()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        backgroundColor = .white
        addSubview(headerView)
        setupLayoutConstraints()
        timerPickerView.delegate = self
        timerPickerView.dataSource = self
        setupTimerTextField()
        setupActions()
    }
    
    private func setupLayoutConstraints() {
        NSLayoutConstraint.activate([
            timerImageView.heightAnchor.constraint(equalToConstant: 40),
            timerImageView.widthAnchor.constraint(equalToConstant: 40),
            timerImageView.leadingAnchor.constraint(equalTo: timerStackView.leadingAnchor, constant: 16),
            
            startPauseButton.heightAnchor.constraint(equalToConstant: 25),
            startPauseButton.widthAnchor.constraint(equalToConstant: 25),
            stopButton.heightAnchor.constraint(equalToConstant: 25),
            stopButton.widthAnchor.constraint(equalToConstant: 25),
            stopButton.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -16),
            
            timerStackView.topAnchor.constraint(equalTo: headerView.topAnchor),
            timerStackView.bottomAnchor.constraint(equalTo: headerView.bottomAnchor),
            timerStackView.leadingAnchor.constraint(equalTo: headerView.leadingAnchor),
            timerStackView.trailingAnchor.constraint(equalTo: headerView.trailingAnchor),
            
            headerView.topAnchor.constraint(equalTo: topAnchor),
            headerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            headerView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
    override class var requiresConstraintBasedLayout: Bool {
        return true
    }
    
    private func setupTimerTextField() {
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.sizeToFit()
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancel))
        let spacerButton = UIBarButtonItem(systemItem: .flexibleSpace)
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(setTimerTextField))
        toolBar.setItems([cancelButton, spacerButton, doneButton], animated: true)
        timerTextField.inputView = timerPickerView
        timerTextField.inputAccessoryView = toolBar
    }
    
    private func setupActions() {
        startPauseButton.addTarget(self, action: #selector(startPauseTimer), for: .touchUpInside)
        stopButton.addTarget(self, action: #selector(stopTimer), for: .touchUpInside)
    }
    
    @objc func startPauseTimer() {
        guard totalTime > 0 else {
            return
        }
        
        timerTextField.isUserInteractionEnabled = false
        timerTextField.borderStyle = .none
        
        if isPaused {
            runTimer()
            startPauseButton.setBackgroundImage(UIImage(systemName: "pause.fill"), for: .normal)
            isPaused = false
            timerImageView.tintColor = UIColor.red
        }
        else {
            timer.invalidate()
            startPauseButton.setBackgroundImage(UIImage(systemName: "play.fill"), for: .normal)
            isPaused = true
            timerImageView.tintColor = UIColor.link
        }
    }
    
    @objc func stopTimer() {
        timer.invalidate()
        isPaused = true
        startPauseButton.setBackgroundImage(UIImage(systemName: "play.fill"), for: .normal)
        totalTime = 0
        timerTextField.text = totalTime.secondsToTimeString()
        timerTextField.isUserInteractionEnabled = true
        timerTextField.borderStyle = .roundedRect
        timerTextField.textColor = UIColor.link
        timerImageView.tintColor = UIColor.link
    }
    
    @objc func setTimerTextField() {
        totalTime = selectedHour.hoursToSeconds() + selectedMinute.minutesToSeconds() + selectedSecond
        timerTextField.text = totalTime.secondsToTimeString()
        timerTextField.resignFirstResponder()
    }
    
    @objc func cancel() {
        timerTextField.resignFirstResponder()
    }
    
    func runTimer() {
        timer = Timer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        RunLoop.current.add(timer, forMode: .common)
    }
    
    // Called every second and will update the totalTime as well as text field label
    @objc func updateTimer() {
        if totalTime < 1 {
            timer.invalidate()
        }
        else {
            totalTime -= 1 // Decrement the current time
            timerTextField.text = totalTime.secondsToTimeString()
        }
        
        if totalTime < 60 && totalTime > 0 {
            timerTextField.textColor = .red
        }
        
        // SOURCE: - https://stackoverflow.com/questions/26455880/how-to-make-iphone-vibrate-using-swift
        // Reset when timer is up
        if totalTime == 0 {
            timerImageView.shakeAnimation(durationOf: 0.07, repeatNumTimes: 20)
            AudioServicesPlayAlertSoundWithCompletion(SystemSoundID(kSystemSoundID_Vibrate), nil)
            isPaused = true
            startPauseButton.setBackgroundImage(UIImage(systemName: "play.fill"), for: .normal)
            
            afterDelay(4) {
                self.timerImageView.tintColor = UIColor.link
                self.timerTextField.borderStyle = .roundedRect
                self.timerTextField.isUserInteractionEnabled = true
                self.timerTextField.textColor = UIColor.link
            }
        }
    }
    
    
}

extension TimerHeaderView: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return timerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return timerData[component].count
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return "\(timerData[component][row]) hours"
        }
    
        else if component == 1 {
            return "\(timerData[component][row]) mins"
        }
        else if component == 2 {
            return "\(timerData[component][row]) secs"
        }
        return ""
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
            selectedHour = timerData[component][row]
        }
        else if component == 1 {
            selectedMinute = timerData[component][row]
        }
        else if component == 2 {
            selectedSecond = timerData[component][row]
        }
    }
}
