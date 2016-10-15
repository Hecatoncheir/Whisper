part of pages;

class HandlersMixin {
  Pages _pages;

  prepareEventsHandlers() async {
    _pages = this;

    _pages.on('PageMustBeSaved', (Map data) async {
      Page page = new Page()..fromMap(data['Page']);

      Map details = {
        'Page': await _pages.savePage(page: page),
        'ClientIdentificator': data['ClientIdentificator']
      };
      _pages.dispatchEvent('NewPageAdded', details);
    });

    _pages.on('PageMustBeUpdated', (Map data) async {
      Map details = {
        'Page': await _pages.updatePage(page: data['Page']),
        'ClientIdentificator': data['ClientIdentificator']
      };
      _pages.dispatchEvent('PageUpdated', details);
    });

    _pages.on('NeedPageDetails', (Map data) async {
      String pagePath = data['Page']['path'];

      Map details = {'ClientIdentificator': data['ClientIdentificator']};

      if (pagePath.isNotEmpty) {
        details['Page'] = await _pages.getPageByPath(path: pagePath);
      }

      _pages.dispatchEvent('PageDetailsReady', details);
    });
  }
}
