package entities;

import flixel.FlxSprite;
import flixel.util.FlxColor;
import iso.IsoSprite;

class ExtraLongX extends IsoSprite {
	public function new(X:Float, Y:Float) {
		gridWidth = 4.5;
		gridLength = 1;
		gridHeight = 1;

		super(X, Y);
		color = FlxColor.GREEN.getLightened();

		sprite = new FlxSprite(AssetPaths.Block_25x5x10__png);
		sprite.offset.set(50, 40);
	}
}
