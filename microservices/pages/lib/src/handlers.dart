part of pages;

class HandlersMixin {
  Pages _pages;

  prepareEventsHandlers() async {
    _pages = this;

    _pages.on('NeedPageDescription', (Map data) async {
      String pageDescription =
          await _pages.getPageDescription(path: data['page']['path']);

      _pages.dispatchEvent('DescriptionForPageReady', {
        'PageDescription': pageDescription,
        'ClientIdentificator': data['ClientIdentificator']
      });
    });

    _pages.on('NeedDetailsOfPage', (Map data) {});

    _pages.on('PageMustBeSaved', (Map data) {
      print(data);
    });
  }
}
