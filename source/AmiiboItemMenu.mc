// Project   : Garmin-MonkeyC-Fenix8-Solar-51mm
// Author    : AzzureSkyy
// Watermark : AzzureSkyy
// Source    : https://github.com/AzzureSkyy/Garmin-MonkeyC-Fenix8-Solar-51mm
// Copyright : (c) 2026 AzzureSkyy. All rights reserved. See LICENSE.
import Toybox.WatchUi;
import Toybox.Lang;

//! Scrollable native Menu2 listing every Amiibo name within a single
//! category. Items are text-only.
class AmiiboItemMenu extends WatchUi.Menu2 {

	function initialize(categoryIndex as Number, items as Array<Array<String> >) {
		Menu2.initialize({ :title => AmiiboData.CATEGORY_NAMES[categoryIndex] });

		for (var i = 0; i < items.size(); i += 1) {
			addItem(new WatchUi.MenuItem(items[i][0], null, i, null));
		}
	}
}
// AzzureSkyy
