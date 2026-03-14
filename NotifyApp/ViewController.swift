import UIKit
import UserNotifications

class ViewController: UIViewController {

    // MARK: - UI Elements
    private let containerView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    private let iconLabel: UILabel = {
        let l = UILabel()
        l.text = "🔔"
        l.font = .systemFont(ofSize: 72)
        l.textAlignment = .center
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private let titleLabel: UILabel = {
        let l = UILabel()
        l.text = "Notification Demo"
        l.font = .systemFont(ofSize: 28, weight: .bold)
        l.textColor = .label
        l.textAlignment = .center
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private let statusLabel: UILabel = {
        let l = UILabel()
        l.text = "Запрашиваем разрешение..."
        l.font = .systemFont(ofSize: 16, weight: .regular)
        l.textColor = .secondaryLabel
        l.textAlignment = .center
        l.numberOfLines = 0
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private let countdownLabel: UILabel = {
        let l = UILabel()
        l.text = ""
        l.font = .monospacedDigitSystemFont(ofSize: 56, weight: .thin)
        l.textColor = .systemBlue
        l.textAlignment = .center
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private let scheduleButton: UIButton = {
        let b = UIButton(type: .system)
        b.setTitle("Запустить снова", for: .normal)
        b.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        b.backgroundColor = .systemBlue
        b.setTitleColor(.white, for: .normal)
        b.layer.cornerRadius = 14
        b.translatesAutoresizingMaskIntoConstraints = false
        b.isHidden = true
        return b
    }()

    private var countdownTimer: Timer?
    private var secondsLeft = 5

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        requestPermissionAndSchedule()
    }

    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = .systemBackground

        view.addSubview(containerView)
        containerView.addSubview(iconLabel)
        containerView.addSubview(titleLabel)
        containerView.addSubview(statusLabel)
        containerView.addSubview(countdownLabel)
        containerView.addSubview(scheduleButton)

        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),

            iconLabel.topAnchor.constraint(equalTo: containerView.topAnchor),
            iconLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),

            titleLabel.topAnchor.constraint(equalTo: iconLabel.bottomAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),

            statusLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            statusLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            statusLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),

            countdownLabel.topAnchor.constraint(equalTo: statusLabel.bottomAnchor, constant: 32),
            countdownLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),

            scheduleButton.topAnchor.constraint(equalTo: countdownLabel.bottomAnchor, constant: 32),
            scheduleButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            scheduleButton.widthAnchor.constraint(equalToConstant: 220),
            scheduleButton.heightAnchor.constraint(equalToConstant: 52),
            scheduleButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
        ])

        scheduleButton.addTarget(self, action: #selector(scheduleButtonTapped), for: .touchUpInside)
    }

    // MARK: - Notifications
    private func requestPermissionAndSchedule() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { [weak self] granted, error in
            DispatchQueue.main.async {
                if granted {
                    self?.statusLabel.text = "Разрешение получено ✅\nУведомление придёт через:"
                    self?.scheduleNotification()
                    self?.startCountdown()
                } else {
                    self?.statusLabel.text = "Разрешение отклонено ❌\nВключите уведомления в Настройках"
                    self?.countdownLabel.text = ""
                }
            }
        }
    }

    private func scheduleNotification() {
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()

        let content = UNMutableNotificationContent()
        content.title = "Привет от NotifyApp! 👋"
        content.body = "Прошло 5 секунд с момента запуска приложения."
        content.sound = .default
        content.badge = 1

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let request = UNNotificationRequest(identifier: "launch_notification", content: content, trigger: trigger)

        center.add(request) { error in
            if let error = error {
                print("Ошибка планирования уведомления: \(error)")
            }
        }
    }

    private func startCountdown() {
        secondsLeft = 5
        countdownLabel.text = "\(secondsLeft)"
        scheduleButton.isHidden = true

        countdownTimer?.invalidate()
        countdownTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] timer in
            guard let self = self else { return }
            self.secondsLeft -= 1

            if self.secondsLeft > 0 {
                self.countdownLabel.text = "\(self.secondsLeft)"
                UIView.animate(withDuration: 0.15, animations: {
                    self.countdownLabel.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
                }) { _ in
                    UIView.animate(withDuration: 0.15) {
                        self.countdownLabel.transform = .identity
                    }
                }
            } else {
                timer.invalidate()
                self.countdownLabel.text = "🔔"
                self.statusLabel.text = "Уведомление отправлено!"
                self.scheduleButton.isHidden = false
            }
        }
    }

    @objc private func scheduleButtonTapped() {
        statusLabel.text = "Уведомление придёт через:"
        scheduleNotification()
        startCountdown()
    }
}
