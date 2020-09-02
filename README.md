Little Tarot Journal
====================

A tarot reading app. Users can draw tarot cards, take notes and questions, all of
this journal will be encrypted and stored securely on Arweave's network.

On Permaweb: [Little Tarot Journal](https://arweave.net/UoZ7W6EqXR3vS24h3YyCfy0I30-PXLXtsXaOWoY7blE)

Getting Started
---------------

This project is a Flutter web application, using [CDDelta/arweave-dart](https://github.com/CDDelta/arweave-dart) to interact with
Arweave’s network.

Note: arweave-dart depend on pointycastle v2 from git, so it may not fully compatible with some libs depend on pointycastle v1 from hosted (eg. jose, crypto_key, ...).

A few resources to get you started: 

- [Web support for Flutter](https://flutter.dev/web)

- [Arweave-js](https://github.com/ArweaveTeam/arweave-js)
- [CDDelta/arweave-dart](https://github.com/CDDelta/arweave-dart)



Run & build this project:

```
$ flutter run -d chrome
```

```
$ flutter build web
```

