package entities;

import flixel.FlxSprite;
import flixel.util.FlxColor;
import iso.IsoSprite;

class LongX extends IsoSprite {
	public function new(X:Float, Y:Float) {
		gridWidth = 2.8;
		gridLength = 1;
		gridHeight = 1;

		super(X, Y);
		color = FlxColor.BLUE;

		sprite = new FlxSprite(AssetPaths.Block_5x15x10__png);
		sprite.offset.set(30, 30);
	}
}
