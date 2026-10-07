// Project   : Garmin-MonkeyC-Fenix8-Solar-51mm
// Author    : AzzureSkyy
// Watermark : AzzureSkyy
// Source    : https://github.com/AzzureSkyy/Garmin-MonkeyC-Fenix8-Solar-51mm
// Copyright : (c) 2026 AzzureSkyy. All rights reserved. See LICENSE.
import Toybox.Lang;
import Toybox.WatchUi;

//! Amiibo dataset. Category names stay in code; each category's item list
//! lives in a JSON resource (resources/jsondata/catNN.json) and is only
//! loaded into memory when that category is opened. Each item is
//! [name, tagUid, amiiboId].
module AmiiboData {

	const CATEGORY_NAMES as Array<String> = [
		"Animal Crossing Amiibo",
		"BoxBoy! Amiibo",
		"Chibi-Robo! Amiibo",
		"Dark Souls Amiibo",
		"Detective Pikachu Amiibo",
		"Diablo Amiibo",
		"Donkey Kong Bananza Amiibo",
		"Fire Emblem Amiibo",
		"Jikkyou Powerful Pro Baseball Amiibo Cards",
		"Kellogs Amiibo",
		"Kirby Amiibo",
		"Mario Sports Superstars Amiibo",
		"Mega Man Amiibo",
		"Metroid Amiibo",
		"Monster Hunter Amiibo",
		"My Mario Amiibo",
		"Pikmin Amiibo",
		"Pokkén Tournament Amiibo",
		"Power Pros Amiibo",
		"PowerUpBands",
		"Pragmata Amiibo",
		"Resident Evil Amiibo",
		"Shovel Knight Amiibo",
		"Skylanders Amiibo",
		"Splatoon Amiibo",
		"Street Fighter Amiibo",
		"Super Mario Amiibo",
		"Super Nintendo World Power-Up Bands",
		"Super Smash Bros Amiibo",
		"The Legend of Zelda Amiibo",
		"Xenoblade Chronicles",
		"Xenoblade Chronicles Amiibo",
		"Yoshi’s Wooly World Amiibo",
		"Yu-Gi-Oh! Amiibo"
	];

	function getItems(categoryIndex as Number) as Array<Array<String> > {
		var res = [
			Rez.JsonData.Cat0,
			Rez.JsonData.Cat1,
			Rez.JsonData.Cat2,
			Rez.JsonData.Cat3,
			Rez.JsonData.Cat4,
			Rez.JsonData.Cat5,
			Rez.JsonData.Cat6,
			Rez.JsonData.Cat7,
			Rez.JsonData.Cat8,
			Rez.JsonData.Cat9,
			Rez.JsonData.Cat10,
			Rez.JsonData.Cat11,
			Rez.JsonData.Cat12,
			Rez.JsonData.Cat13,
			Rez.JsonData.Cat14,
			Rez.JsonData.Cat15,
			Rez.JsonData.Cat16,
			Rez.JsonData.Cat17,
			Rez.JsonData.Cat18,
			Rez.JsonData.Cat19,
			Rez.JsonData.Cat20,
			Rez.JsonData.Cat21,
			Rez.JsonData.Cat22,
			Rez.JsonData.Cat23,
			Rez.JsonData.Cat24,
			Rez.JsonData.Cat25,
			Rez.JsonData.Cat26,
			Rez.JsonData.Cat27,
			Rez.JsonData.Cat28,
			Rez.JsonData.Cat29,
			Rez.JsonData.Cat30,
			Rez.JsonData.Cat31,
			Rez.JsonData.Cat32,
			Rez.JsonData.Cat33
		];
		return WatchUi.loadResource(res[categoryIndex]) as Array<Array<String> >;
	}
}
// AzzureSkyy
