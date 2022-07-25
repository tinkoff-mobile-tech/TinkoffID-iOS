# TinkoffID
## Содержание
* [Предварительные этапы](#Предварительные-этапы)
* [Установка](#Установка)
    * [Swift Package Manager](#Swift-Package-Manager)
    * [Cocoapods](#Cocoapods)
* [Требования к приложению](#Требования-к-приложению)
* [Структура публичной части SDK](#Структура-публичной-части-SDK)
    * [ITinkoffID](#ITinkoffID)
    * [TinkoffAuthError](#TinkoffAuthError)
* [Получение ITinkoffID](#Получение-ITinkoffID)
* [Авторизация](#Авторизация)
    * [Перед началом](#Перед-началом)
    * [Выполнение авторизации](#Выполнение-авторизации)
    * [Продолжение авторизации](#Продолжение-авторизации)
    * [Обновление авторизационных данных](#Обновление-авторизационных-данных)
    * [Отзыв авторизационных данных](#Отзыв-авторизационных-данных)
    * [Структура TinkoffTokenPayload](#Структура-TinkoffTokenPayload)
    * [Хранение Refresh Token](#Хранение-Refresh-Token)
* [UI](#UI)
* [Отладка без приложения Тинькофф](#Отладка-без-приложения-Тинькофф)
    * [Настройка приложения](#Настройка-приложения)
    * [Получение реализации ITinkoffID для отладки](#Получение-реализации-ITinkoffID-для-отладки)
    * [Приложение для отладки](#Приложение-для-отладки)
* [Пример приложения](#Пример-приложения)
    * [AppDelegate](#AppDelegate)
    * [AuthViewController](#AuthViewController)
* [Поддержка](#Поддержка)
* [Разработчики](#Разработчики)

## Предварительные этапы
Для начала работы с Tinkoff ID в качестве партнера заполните заявку на подключение на [данной странице](https://www.tinkoff.ru/business/open-api/). После рассмотрения вашей заявки вы получите по электронной почте `client_id` и пароль. Подробная инструкция доступна в [документации](https://business.tinkoff.ru/openapi/docs/#section/Partnerskij-scenarij).

## Установка

### Swift Package Manager
`TinkoffID` поддерживает Swift Package Manager. Инструкцию по настройке SPM для вашего проекта можно найти [здесь](https://developer.apple.com/documentation/xcode/adding_package_dependencies_to_your_app).
После настройки проекта просто добавьте ссылку на репозиторий как зависимость:

```
https://github.com/tinkoff-mobile-tech/TinkoffID-iOS
```

### Cocoapods
Для установки `TinkoffID` с помощью [CocoaPods](https://cocoapods.org) необходимо добавить следующую строчку в ваш `Podfile`:

```ruby
pod 'TinkoffID'
```

Затем выполните команду `pod install` в директории проекта.

## Требования к приложению

Для работы SDK необходимо следующее:

+ iOS 10 и выше
+ Зарегистрированный идентификатор авторизуемого приложения (`client_id`)
+ Зарегистрированная авторизуемым приложением [URL схема](https://developer.apple.com/documentation/uikit/inter-process_communication/allowing_apps_and_websites_to_link_to_your_content/defining_a_custom_url_scheme_for_your_app), которая будет использоваться для возврата в приложение после авторизации
+ Добавленная запись в `plist`, позволяющая Вашему приложению переходить в приложение Тинькофф:

```
<key>LSApplicationQueriesSchemes</key>
<array>
    <string>tinkoffbank</string>
</array>
```

## Структура публичной части SDK

### ITinkoffID
Авторизацией занимается объект, реализующий протокол `ITinkoffID`. В свою очередь, протокол `ITinkoffID` является композицией следующих протоколов:

+ `ITinkoffAuthInitiator` - инициатор начала процесса авторизации
+ `ITinkoffAuthCallbackHandler` - обработчик возврата в приложение из приложения Тинькофф
+ `ITinkoffCredentialsRefresher` - объект, умеющий обновлять `Credentials` по их `Refresh token`
+ `ITinkoffSignOutInitiator` - инициатор отзыва авторизационных данных

В зависимости от архитектуры приложения можно использовать непосредственно`ITinkoffID` или каждый подпротокол отдельно в требуемой части системы.

### TinkoffAuthError
`TinkoffAuthError` типа `enum` описывает возможные ошибки авторизации

| Значение                     | Описание                                                      |
| ---------------------------- |---------------------------------------------------------------|
| `failedToLaunchApp`          | Не удалось запустить приложение Тинькофф                      |
| `cancelledByUser`            | Авторизация отменена пользователем после перехода в Тинькофф  |
| `unavailable`                | Авторизация сторонних приложений недоступна для пользователя  |
| `failedToObtainToken`	       | Не удалось завершить авторизацию после возврата из приложения |
| `failedToRefreshCredentials` | Не удалось обновить токены                                    |

При получении ошибки рекомендуется предложить пользователю попробовать позже.

## Получение ITinkoffID

SDK поставляет публичную абстракцию `ITinkoffIDFactory` и публичный класс `TinkoffIDFactory`, реализующий её и служащий для сборки и предоставления объекта, реализующего `ITinkoffID`. 

```swift
// Идентификатор приложения
let clientId = "someClient"
// URL обратного вызова, необходимый для возврата в приложение
let callbackUrl = "myapp://authorized"

// Инициализация фабрики ITinkoffID
let factory = TinkoffIDFactory(clientId: clientId,
                               callbackUrl: callbackUrl)
// Получение ITinkoffID
let tinkoffId = factory.build()
```

После получения `ITinkoffID`, приложение может начинать авторизацию.

## Авторизация

### Перед началом

`ITinkoffAuthInitiator` может предоставить информацию о возможности выполнения авторизации с помощью флага `isTinkoffAuthAvailable`. Поднятый флаг означает, что у пользователя установлено приложение Тинькофф, через которое можно осуществить вход. При вызове метода `startTinkoffAuth` с поднятным флагом будет осуществлен переход в заданное приложение для инициализации авторизации, в случае если флаг опущен, пользователь будет перенаправлен на страницу этого приложения в App Store.

### Выполнение авторизации

Для начала авторизации необходимо вызвать метод `startTinkoffAuth` объекта `ITinkoffAuthInitiator`:

```swift
tinkoffId.startTinkoffAuth { result in
    do {
        let payload = try result.get()
        
        print("Access token obtained: \(payload.accessToken)"
    } catch {
        print(error)
    }
}
```

Вызов этого метода приведет к перенаправлению пользователя в приложение Тинькофф для подтверждения авторизации приложения.

### Продолжение авторизации

После подтверждения авторизации пользователем будет произведен возврат в авторизуемое приложение для завершения авторизации. Обратный переход будет осуществлен с помощью URL обратного вызова, предоставленным приложением. Задача приложения на этом этапе в том, чтобы передать полученный `AppDelegate` URL в метод `handleCallbackUrl` объекта `ITinkoffAuthCallbackHandler`:

```swift
func application(_ app: UIApplication,
                 open url: URL,
                 options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
    return tinkoffId.handleCallbackUrl(url)
}
```

SDK обработает переданные в URL параметры завершит авторизацию, передав объект `Result<TinkoffTokenPayload, TinkoffAuthError>` в блок, определенный при вызове `startTinkoffAuth()`.

### Обновление авторизационных данных

Время от времени приложению необходимо получать актуальный объект `TinkoffTokenPayload` (например, когда срок жизни предыдущего истек).

Для этого необходимо вызвать метод `obtainTokenPayload` объекта `ITinkoffCredentialsRefresher` как показано ниже:

```swift
let credentials: TinkoffTokenPayload = ...

tinkoffId.obtainTokenPayload(using: credentials.refreshToken) { result in
    do {
        let newCredentials: TinkoffTokenPayload = try result.get()
    } catch {
        print(error)
    }
}
```

### Отзыв авторизационных данных

Иногда может возникнуть ситуация когда полученные авторизационные данные более не нужны. Например, при выходе смене или отключении аккаунта пользователя в авторизованном приложении. В таком случае, приложению необходимо выполнить отзыв авторизационных данных с помощью `ITinkoffSignOutInitiator`:

```swift
let credentials: TinkoffTokenPayload = ...

tinkoffId.signOut(with: credentials.accessToken, tokenTypeHint: .access, completion: { result in
    do {
        _ = try result.get()
        
        print("Signed out")
    } catch {
        print(error)
    }
})
```

### Структура TinkoffTokenPayload

В результате успешной авторизации приложение получает объект `Credentials`, содержащий следующие свойства:

+ `accessToken` - токен для обращения к API Тинькофф
+ `refreshToken` - токен, необходимый для получения нового `accessToken`. Может отсутствовать в случае если пользователь запретил авторизуемому приложению доступ в любое время
+ `idToken` - идентификатор пользователя в формате JWT
+ `expirationTimeout` - время, через которое `accessToken` станет неактуальным и нужно будет получить новый с помощью `refreshToken`

### Хранение Refresh Token

При получении `TinkoffTokenPayload` и наличии у него поля `refreshToken` имеет смысл сохранить значение этого поля чтобы иметь возможность запросить новый `accessToken`, когда прежний станет неактивным. Рекомендуемый способ хранения токена - [Keychain Services](https://developer.apple.com/documentation/security/keychain_services)

## UI
SDK поставляет два варианта фирменных кнопок входа через Тинькофф. 
Первый вариант - стандартная прямоугольная кнопка с текстом, с возможностью задать текст, радиус скругления и шрифт. Так же можно выбрать один из трех вариантов цветового стиля и размера. Есть возможность добавить дополнительный текст для привлечения клиентов.
Второй вариант - компактная кнопка без текста, так же можно выбрать один из трех цветовых стилей. 
```swift
override func viewDidLoad() {
    super.viewDidLoad()
    
    // Создание стандартной кнопки
    let button = TinkoffIDButtonBuilder.build()
    
    // Добавление обработчика нажатия
    button.addTarget(self, action: #selector(signInButtonTapped), for: .touchUpInside)
    
    // Добавление в иерархию
    view.addSubview(button)
    
    // Отступ кнопки от краёв
    let padding: CGFloat = 16
    
    // Расположение кнопки на экране
    button.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
        button.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: padding),
        button.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -padding),
        button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -padding),
    ])
}
```

Обратите внимание: после получения кнопки необходимо расположить её на экране, а также добавить обработчик события нажатия. 
Для верстки рекомендуется использовать `AutoLayout` без указания высоты так как она задается с помощью `intrinsicContentSize`.

Более подробно ознакомиться с правилами размещения кнопки Вы можете [здесь](https://www.figma.com/file/Yj3o7yQotahvBxfIKhBmJc/Tinkoff-ID-guide).

## Отладка без приложения Тинькофф
В случаях когда необходима отладка интеграции `Tinkoff ID` без приложения Тинькофф или на симуляторе iOS, SDK предоставляет реализацию TinkoffID для отладки.

Её отличия от основной реализации:
* Вместо приложения Тинькофф переход происходит в специальное приложение, позволяющее выбрать сценарий авторизации
* Не происходит запросов к серверам Тинькофф

### Настройка приложения
Для того, чтобы разрешить приложению переход в приложение для отладки, необходимо в `plist` файл вашего приложения добавить следующее:

```
<key>LSApplicationQueriesSchemes</key>
<array>
    <string>tinkoffiddebug</string>
</array>
```

Далее необходимо установить приложение `TinkoffID Debug` на устройство или симулятор. Проект приложения находится [здесь](https://github.com/tinkoff-mobile-tech/TinkoffID-iOS/tree/master/TinkoffID%20Debug).

ℹ️ Реализация SDK для отладки использует тот же интерфейс `ITinkoffID`, что и стандартная реализация, поэтому при соблюдении принципа инверсии зависимостей вы можете внедрить её без изменения кода своего приложения. Также `ITinkoffIDFactory` представляет собой абстрактную фабрику, что позволяет при соблюдении того же принципа внедрять и её вместо внедрения уже собранного объекта `ITinkoffID`.

### Получение реализации `ITinkoffID` для отладки
Теперь, когда ваше приложение настроено и приложение-отладчик установлено, можно собрать реализацию `ITinkoffID` для отладки. Сделать это можно следующим образом:

```swift
// Ссылка по которой будет осуществлен возврат в приложение
let callbackUrl: String = ""

// Конфигурация для отладки
let configuration = DebugConfiguration(
    canRefreshTokens: true, // Если флаг `canRefreshTokens` поднят, то обновление токенов будет завершаться без ошибки
    canLogout: true // Если флаг `canLogout` поднят, выход из приложения будет завершаться без ошибки
)

// Фабрика, возвращающая реализацию ITinkoffID для отладки
let factory: ITinkoffIDFactory = DebugTinkoffIDFactory(
    callbackUrl: callbackUrl,
    configuration: configuration
)

// Реализация ITinkoffID для отладки
let debugTinkoffId: ITinkoffID = factory.build()
```

Далее вы можете использовать полученный объект, как обычный `ITinkoffID`.

### Приложение для отладки
После вызова метода `startTinkoffAuth` у реализации `ITinkoffID` для отладки вы попадете в отладочное приложение. После перехода вам будет представлен список возможных действий, а именно:
* `Вернуться и успешно завершить вход` - возвращает обратно в ваше приложение и успешно отдает токены-заглушки
* `Вернуться и не завершить вход` - возвращает обратно в ваше приложение и завершает вход с ошибкой получения токенов
* `Отменить вход` - возвращает обратно в ваше приложение и симулирует отмену входа пользователем
* `Симуляция недоступности входа` - возвращает обратно в приложение и симулирует недоступность `Tinkoff ID` для пользователя

## Пример приложения

SDK поставляется с примером приложения. Для запуска примера склонируйте репозиторий, выполните команду `pod install` в папке Example, откройте сгенерированный `.xcworkspace`файл и запустите проект.

Приложение включает в себя `AppDelegate` и `AuthViewController`.

### AppDelegate

`AppDelegate` создает `AuthViewController` и устанавливает его в качестве корневого контроллера окна приложения. При запуске приложения создается фабрика `ITinkoffIDFactory`, собирающая `ITinkoffID` в методе `applicationDidFinishLaunching` и передающая его в качестве параметров при инициализации `AuthViewController`.

⚠️ Обратите внимание! В `AppDelegate.swift` определена структура `Constant`, одним из полей которой является `clientId` типа  `String`. Для тестирования авторизации необходимо заменить её содержимое `client_id`, полученным при регистрации в Tinkoff ID.

### AuthViewController

`AuthViewController` инициируется ссылками на объекты, реализующими `ITinkoffAuthInitiator`, `ITinkoffCredentialsRefresher` и `ITinkoffSignOutInitiator` соответственно.

В текущей реализации все эти ссылки указывают на один и тот же экземпляр объекта `TinkoffID`, реализующий интерфейс `ITinkoffID`. Такой подход был выбран для демонстрации возможности использования подинтерфейсов `ITinkoffID` в той или иной части системы. Пользователь SDK вправе сам решать использовать ли ему единый интерфейс `ITinkoffID` или необходимый подинтерфейс в зависимости от архитектуры приложения. 

Подробнее с подинтерфесами `ITinkoffID` можно ознакомиться в разделе `Структура публичной части SDK`.

После загрузки `view` контроллер добавляет на него кнопку входа через Тинькофф, по нажатию на которую будет инициирована авторизация.

## Поддержка
Сообщать об ошибках и запрашивать новый функционал можно в разделе [Issues](https://github.com/tinkoff-mobile-tech/TinkoffID-iOS/issues)
Почта для обращений - `tinkoff_id@tinkoff.ru`

## Разработчики
* Дмитрий Оверчук - `d.overchuk@tinkoff.ru`
* Камиль Бакаев - `k.bakaev@tinkoff.ru`
* Вадим Жиликов - `v.zhilinkov@tinkoff.ru`
