import 'dart:async';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' hide Account;
import 'package:flutter/foundation.dart';

mixin AppwriteDatabaseDataSource {
  Realtime get realtime;

  Databases get databases;

  @protected
  Stream<Document> watchDocument(
    String databaseId,
    String collectionId,
    String documentId, {
    List<String> additionalChannels = const [],
  }) {
    late final StreamController<Document> streamController;
    late final RealtimeSubscription subscription;

    // Close controller and subscription when not needed
    streamController = StreamController(
      onCancel: () {
        subscription.close();
        streamController.close();
      },
    );

    getDocument(databaseId, collectionId, documentId)
        .then((value) => streamController.add(value))
        .catchError(
          (e, s) => streamController.addError(e, s),
        );

    subscription = realtime.subscribe(
      [
        'databases.$databaseId.collections.$collectionId.documents.$documentId',
        ...additionalChannels,
      ],
    );
    subscription.stream.listen(
      (event) async {
        try {
          if (streamController.isClosed) {
            return;
          }
          streamController.add(
            await getDocument(
              databaseId,
              collectionId,
              documentId,
            ),
          );
        } on AppwriteException catch (e, s) {
          streamController.addError(e, s);
        }
      },
      onError: (e, s) => streamController.addError(e, s),
    );

    return streamController.stream;
  }

  @protected
  Stream<DocumentList> watchCollection(String databaseId, String collectionId,
      [List<String> queries = const []]) {
    late final StreamController<DocumentList> streamController;
    late final RealtimeSubscription subscription;

    // Close controller and subscription when not needed
    streamController = StreamController(
      onCancel: () {
        subscription.close();
        streamController.close();
      },
    );

    getCollection(databaseId, collectionId, queries)
        .then((value) => streamController.add(value))
        .catchError(
          (e, s) => streamController.addError(e, s),
        );

    subscription = realtime.subscribe(
        ['databases.$databaseId.collections.$collectionId.documents']);
    subscription.stream.listen(
      (event) async {
        try {
          if (streamController.isClosed) {
            return;
          }
          streamController.add(
            await getCollection(
              databaseId,
              collectionId,
              queries,
            ),
          );
        } on AppwriteException catch (e, s) {
          streamController.addError(e, s);
        }
      },
      onError: (e, s) => streamController.addError(e, s),
    );

    return streamController.stream;
  }

  @protected
  Future<DocumentList> getCollection(
    String databaseId,
    String collectionId, [
    List<String> queries = const [],
  ]) {
    return databases.listDocuments(
      databaseId: databaseId,
      collectionId: collectionId,
      queries: queries,
    );
  }

  @protected
  Future<Document> getDocument(
    String databaseId,
    String collectionId,
    String documentId,
  ) {
    return databases.getDocument(
      databaseId: databaseId,
      collectionId: collectionId,
      documentId: documentId,
    );
  }
}
