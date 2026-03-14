# NotifyApp 🔔

iOS приложение на Swift, которое отправляет уведомление со звуком **через 5 секунд** после запуска.

## Что делает приложение

- При запуске запрашивает разрешение на уведомления
- Показывает обратный отсчёт 5→1
- Отправляет локальное уведомление со звуком
- Уведомление показывается **даже когда приложение открыто** (foreground)
- Кнопка "Запустить снова" для повторного тестирования

---

## Сборка через GitHub Actions (без Mac)

### Шаг 1 — Загрузите проект на GitHub

```bash
git init
git add .
git commit -m "Initial commit"
git branch -M main
git remote add origin https://github.com/ВАШ_ЛОГИН/NotifyApp.git
git push -u origin main
```

### Шаг 2 — Дождитесь сборки

После пуша GitHub Actions автоматически запустит сборку.  
Статус: **Actions** → **Build iOS IPA**

Время сборки: ~5-10 минут.

### Шаг 3 — Скачайте IPA

В GitHub перейдите: **Actions** → выберите последний запуск → **Artifacts** → **NotifyApp-IPA**

---

## Установка IPA на iPhone (без Mac)

> ⚠️ IPA собрана без подписи Apple Developer. Выберите один из способов:

### Способ 1: AltStore (рекомендуется, бесплатно)
1. Установите [AltStore](https://altstore.io/) на Windows/Mac
2. Подключите iPhone по USB
3. Установите AltStore на iPhone через iTunes
4. Откройте AltStore → "+" → выберите NotifyApp.ipa

### Способ 2: Sideloadly (Windows/Mac, бесплатно)
1. Скачайте [Sideloadly](https://sideloadly.io/)
2. Подключите iPhone по USB
3. Перетащите IPA в Sideloadly
4. Введите Apple ID (бесплатный)
5. Нажмите "Start"

### Способ 3: TrollStore (только для iOS 14-16.6.1 на некоторых устройствах)
Без пересборки каждые 7 дней!  
[Инструкция на GitHub](https://github.com/opa334/TrollStore)

---

## Если у вас есть Apple Developer аккаунт ($99/год)

Раскомментируйте шаг в `.github/workflows/build-ios.yml` и добавьте в **GitHub Secrets**:

| Secret | Описание |
|--------|----------|
| `BUILD_CERTIFICATE_BASE64` | p12 сертификат в base64 |
| `P12_PASSWORD` | Пароль от p12 |
| `BUILD_PROVISION_PROFILE_BASE64` | Provisioning profile в base64 |
| `KEYCHAIN_PASSWORD` | Любой пароль для keychain |

---

## Структура проекта

```
NotifyApp/
├── .github/
│   └── workflows/
│       └── build-ios.yml       # GitHub Actions сборка
├── NotifyApp.xcodeproj/
│   └── project.pbxproj         # Xcode project
├── NotifyApp/
│   ├── AppDelegate.swift        # Делегат + UNUserNotificationCenter
│   ├── SceneDelegate.swift      # Сцена
│   ├── ViewController.swift     # UI + логика уведомлений
│   └── Info.plist              # Конфигурация приложения
├── ExportOptions.plist          # Параметры экспорта IPA
└── README.md
```
