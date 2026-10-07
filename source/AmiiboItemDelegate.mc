// Project   : Garmin-MonkeyC-Fenix8-Solar-51mm
// Author    : AzzureSkyy
// Watermark : AzzureSkyy
// Source    : https://github.com/AzzureSkyy/Garmin-MonkeyC-Fenix8-Solar-51mm
// Copyright : (c) 2026 AzzureSkyy. All rights reserved. See LICENSE.
import Toybox.WatchUi;
import Toybox.System;
import Toybox.Lang;

//! Input delegate for a single Amiibo category's item list. Selecting an
//! item shows its Identifier / tag UID; back returns to categories.
class AmiiboItemDelegate extends WatchUi.Menu2InputDelegate {

	private var _items as Array<Array<String> >;

	function initialize(items as Array<Array<String> >) {
		Menu2InputDelegate.initialize();
		_items = items;
	}

	function onSelect(item) {
		var entry = _items[item.getId() as Number];
		var message = entry[0]
			+ "\nIdentifier: " + entry[2]
			+ "\nTag UID: " + entry[1];
		System.println(message);
		WatchUi.pushView(new WatchUi.Confirmation(message), new AmiiboItemInfoDelegate(), WatchUi.SLIDE_UP);
	}

	function onBack() {
		WatchUi.popView(WatchUi.SLIDE_DOWN);
	}
}

//! Dismisses the item info confirmation dialog back to the item list.
class AmiiboItemInfoDelegate extends WatchUi.ConfirmationDelegate {

	function initialize() {
		ConfirmationDelegate.initialize();
	}

	function onResponse(response) {
		return true;
	}
}
// AzzureSkyy
