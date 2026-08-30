class BusinessScope {
  final String businessId;

  const BusinessScope(this.businessId);

  bool get isDefaultBusiness => businessId == 'business_1';

  String collectionPath(String collectionName) {
    if (isDefaultBusiness) {
      return collectionName;
    }
    return 'businesses/$businessId/$collectionName';
  }
}
