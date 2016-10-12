part of pages;

class HandlersMixin {
  Pages pages;

  prepareEventsHandlers() async {
    pages = this;

    pages.on('NeedPageDescription', (Map data) async {
      String pageDescription =
          await pages.getPageDescription(path: data['page']['path']);

      pages.dispatchEvent('DescriptionForPageReady', {
        'PageDescription': pageDescription,
        'ClientIdentificator': data['ClientIdentificator']
      });
    });
  }
}
