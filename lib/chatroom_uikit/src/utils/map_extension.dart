extension PutWithoutNull on Map<String, dynamic> {
  void putIfNotNull(String key, dynamic value) {
    if (value != null) {
      this[key] = value;
    }
  }
}
