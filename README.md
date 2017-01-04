# cordova-plugin-firebase-dynamiclinks<br>[![NPM version][npm-version]][npm-url] [![NPM downloads][npm-downloads]][npm-url]
> Cordova plugin for [Firebase Invites](https://firebase.google.com/docs/invites/) and [Firebase Dynamic Links](https://firebase.google.com/docs/dynamic-links/)
 
## Installation

    cordova plugin add cordova-plugin-firebase-dynamiclinks --save --variable APP_DOMAIN="example.com" --variable APP_PATH="/"

Variables `APP_DOMAIN` and `APP_PATH` specify [App Indexing](https://firebase.google.com/docs/app-indexing/) domain root to enhance dynamic links SEO.

Go to firebase console and export `google-services.json` and `GoogleService-Info.plist`. Put those files into the root of your cordova app folder.

## Supported Platforms

- iOS
- Android

## Methods

### onDynamicLink(_callback_)
Registers callback that is triggered on each dynamic link click.
```js
window.cordova.plugins.firebase.dynamiclinks.onDynamicLink(function(data) {
    console.log("Dynamic link click with data: ", data);
});
```

### sendInvitation(_config_)
Display invitation dialog.
```js
window.cordova.plugins.firebase.dynamiclinks.sendInvitation({
    deepLink: deepLink,
    title: dialogTitle,
    message: dialogMessage,
    callToActionText: actionButtonText,
    iosClientID: iosClientID,
    androidClientID: androidClientID
});
```

[npm-url]: https://www.npmjs.com/package/cordova-plugin-firebase-dynamiclinks
[npm-version]: https://img.shields.io/npm/v/cordova-plugin-firebase-dynamiclinks.svg
[npm-downloads]: https://img.shields.io/npm/dt/cordova-plugin-firebase-dynamiclinks.svg

