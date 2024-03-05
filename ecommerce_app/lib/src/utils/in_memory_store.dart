import 'package:rxdart/subjects.dart';

/// A generic in-memory store that holds a value of type [T].
class InMemoryStore<T> {
  InMemoryStore(T initial) : _subject = BehaviorSubject<T>.seeded(initial);

  final BehaviorSubject<T> _subject;

  /// A stream that emits the current value of the store whenever it changes.
  /// Do not forget to call [dispose] when you are done with the store.
  Stream<T> get stream => _subject.stream;

  /// The current value of the store.
  T get value => _subject.value;

  /// Sets the value of the store to [newValue].
  set value(T newValue) => _subject.add(newValue);

  /// Closes the store, releasing all resources. Do not forget to call this method!
  void dispose() => _subject.close();
}
