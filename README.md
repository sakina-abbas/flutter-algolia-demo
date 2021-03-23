# algolia_test

A simple Flutter application that demonstrates how Algolia can be integrated and used for advanced searching.

## Getting Started

Create a free account on [Algolia](https://www.algolia.com/)

Create an index called 'users' in Algolia

Copy the Application Id and Search-only API Key from Algolia > API Keys
and paste them in
lib > services > algolia.dart

Write & deploy your own cloud functions to sync your Firestore data with Algolia
i.e. when your desired data is updated in Firestore, these updates should be reflected in Algolia too.

You can also use Providers or any other state management techniques.
This project uses the simple setState to make the code easier to understand for everyone, including developers who are just starting with Flutter.



- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
