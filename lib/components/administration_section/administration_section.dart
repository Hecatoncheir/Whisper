@HtmlImport('administration_section_theme.html')
@HtmlImport('administration_section.html')
library administration_section;

import 'package:polymer/polymer.dart';
import 'package:web_components/web_components.dart';

@PolymerRegister('administration-section')
class AdministrationSection extends PolymerElement {
  AdministrationSection.created() : super.created();

  attached() {
    print('attached');
  }
}
