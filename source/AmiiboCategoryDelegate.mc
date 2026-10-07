// Project   : Garmin-MonkeyC-Fenix8-Solar-51mm
// Author    : AzzureSkyy
// Watermark : AzzureSkyy
// Source    : https://github.com/AzzureSkyy/Garmin-MonkeyC-Fenix8-Solar-51mm
// Copyright : (c) 2026 AzzureSkyy. All rights reserved. See LICENSE.
import Toybox.WatchUi;
import Toybox.Lang;

//! Input delegate for the top-level Amiibo category menu. Selecting a
//! category loads that category's items (once) and pushes its list.
class AmiiboCategoryDelegate extends WatchUi.Menu2InputDelegate {

	function initialize() {
		Menu2InputDelegate.initialize();
	}

	function onSelect(item) {
		var categoryIndex = item.getId() as Number;
		var items = AmiiboData.getItems(categoryIndex);
		WatchUi.pushView(new AmiiboItemMenu(categoryIndex, items), new AmiiboItemDelegate(items), WatchUi.SLIDE_UP);
	}

	function onBack() {
		WatchUi.popView(WatchUi.SLIDE_DOWN);
	}
}
// AzzureSkyy
