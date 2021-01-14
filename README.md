# TinkoffID

`TinkoffID` - SDK для авторизации пользователей iOS приложений с помощью аккаунта Тинькофф.

## Установка

TinkoffID доступен через [CocoaPods](https://cocoapods.org). Для установки просто добавьте следующую строчку в ваш `Podfile`:

```ruby
pod 'TinkoffID'
```

Затем выполните команду `pod install` в директории проекта.

## Требования к приложению

Для работы SDK необходимо следующее:

+ iOS 10 и выше
+ Зарегистрированный идентификатор авторизуемого приложения (`client_id`)
+ Зарегистрированная авторизуемым приложением [URL схема](https://developer.apple.com/documentation/uikit/inter-process_communication/allowing_apps_and_websites_to_link_to_your_content/defining_a_custom_url_scheme_for_your_app), которая будет использоваться для возврата в приложение после авторизации

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

SDK поставляет публичный класс `TinkoffIDBuilder`, служащий для сборки и предоставления объекта, реализующего `ITinkoffID`. 

```swift
// Идентификатор приложения
let clientId = "someClient"
// URL обратного вызова, необходимый для возврата в приложение
let callbackUrl = "myapp://authorized"
// Приложение, с помощью которого будет осуществлена авторизация
let targetApp = TinkoffApp.bank

// Инициализация фабрики
let builder = TinkoffIDBuilder(clientId: clientId,
			       callbackUrl: callbackUrl,
                               app: targetApp)
// Получение ITinkoffID
let tinkoffId = builder.buildSignInEngine()
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
        
tinkoffId.signOut(accessToken: credentials.accessToken) { result in
    do {
        _ = try result.get()
        
        print("Signed out")
    } catch {
        print(error)
    }
}
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
SDK поставляет фирменную кнопку входа через Тинькофф. Кнопка представлена в двух стилях: `.default` (высотой 56 точек) и `.compact` (40 точек).
Для получения экземпляра кнопки необходимо использовать статический метод `build` класса `TinkoffIDButtonBuilder`:

```swift
let button: UIControl = TinkoffIDButtonBuilder.build(.default)
```

Обратите внимание: после получения кнопки необходимо расположить её на экране, а также добавить обработчик события нажатия. 
Для верстки рекомендуется использовать `AutoLayout` без указания высоты так как она задается с помощью `intrinsicContentSize`.

## Пример приложения

SDK поставляется с примером приложения. Для запуска примера склонируйте репозиторий, выполните команду `pod install` в папке Example, откройте сгенерированный `.xcworkspace`файл и запустите проект.

Приложение включает в себя `AppDelegate` и `AuthViewController`.

### AppDelegate

`AppDelegate` создает `AuthViewController` и устанавливает его в качестве корневого контроллера окна приложения. При запуске приложения создается `TinkoffIDBuilder`, собирающий `ITinkoffID` в методе `applicationDidFinishLaunching` и передающий его в качестве параметров при инициализации `AuthViewController`.

⚠️ Обратите внимание! В `AppDelegate.swift` определена структура `Constant`, одним из полей которой является `clientId` типа  `String`. Для тестирования авторизации необходимо заменить её содержимое `client_id`, полученным при регистрации в `Tinkoff ID`.

### AuthViewController

`AuthViewController` инициируется ссылками на объекты, реализующими `ITinkoffAuthInitiator`, `ITinkoffCredentialsRefresher` и `ITinkoffSignOutInitiator` соответственно.

В текущей реализации все эти ссылки указывают на один и тот же экземпляр объекта `TinkoffID`, реализующий интерфейс `ITinkoffID`. Такой подход был выбран для демонстрации возможности использования подинтерфейсов `ITinkoffID` в той или иной части системы. Пользователь SDK вправе сам решать использовать ли ему единый интерфейс `ITinkoffID` или необходимый подинтерфейс в зависимости от архитектуры приложения. 

Подробнее с подинтерфесами `ITinkoffID` можно ознакомиться в разделе `Структура публичной части SDK`.

После загрузки `view` контроллер добавляет на него кнопку входа через Тинькофф, по нажатию на которую будет инициирована авторизация.

## Поддержка
Сообщать об ошибках и запрашивать новый функционал можно в разделе [Issues](https://github.com/tinkoff-mobile-tech/TinkoffID-iOS/issues)

## Автор
Дмитрий Оверчук, d.overchuk@tinkoff.ru

## Лицензия

TinkoffID доступен по лицении MIT. Для получения большей информации обратитесь к файлу LICENSE.
