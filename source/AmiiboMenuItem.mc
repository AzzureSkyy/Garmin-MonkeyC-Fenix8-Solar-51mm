// Project   : Garmin-MonkeyC-Fenix8-Solar-51mm
// Author    : AzzureSkyy
// Watermark : AzzureSkyy
// Source    : https://github.com/AzzureSkyy/Garmin-MonkeyC-Fenix8-Solar-51mm
// Copyright : (c) 2026 AzzureSkyy. All rights reserved. See LICENSE.
import Toybox.Graphics;
import Toybox.WatchUi;

class AmiiboMenuItem extends WatchUi.CustomMenuItem {

	function initialize() {
		CustomMenuItem.initialize("amiibo_item", {});
	}

	function draw(dc) {
		var width = dc.getWidth();
		var height = dc.getHeight();

		dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_WHITE);
		dc.clear();

		var boxX = 12;
		var boxY = (height / 2) - 30;
		var boxWidth = width - 24;
		var boxHeight = 60;

		dc.setColor(Graphics.COLOR_RED, Graphics.COLOR_RED);
		dc.fillRectangle(boxX, boxY, boxWidth, boxHeight);

		dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_WHITE);
		dc.fillRectangle(boxX + 3, boxY + 3, boxWidth - 6, boxHeight - 6);

		dc.setColor(Graphics.COLOR_RED, Graphics.COLOR_RED);
		dc.fillCircle(boxX + 30, boxY + 30, 18);

		dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_WHITE);
		dc.fillCircle(boxX + 30, boxY + 30, 10);

		dc.setColor(Graphics.COLOR_RED, Graphics.COLOR_WHITE);
		dc.drawText(
			boxX + 58,
			boxY + 30,
			Graphics.FONT_MEDIUM,
			"Amiibo",
			Graphics.TEXT_JUSTIFY_LEFT
		);
	}
}
// AzzureSkyy
