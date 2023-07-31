package entities;

import flixel.FlxSprite;
import flixel.util.FlxColor;
import iso.IsoSprite;

class LongY extends IsoSprite {
	public function new(X:Float, Y:Float) {
		gridWidth = 1;
		gridLength = 2.3;
		gridHeight = 1;

		super(X, Y);
		color = FlxColor.YELLOW;

		sprite = new FlxSprite(AssetPaths.Block_5x10x10__png);
		sprite.offset.set(10, 27);
	}
}
