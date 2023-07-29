package entities;

import flixel.FlxSprite;
import iso.IsoSprite;

class Cube extends IsoSprite {
	public function new(X:Float, Y:Float) {
		gridWidth = 1;
		gridLength = 1;
		gridMaxHeight = 1;

		super(X, Y);
		sprite = new FlxSprite(AssetPaths.Block_5x5x10__png);
		sprite.offset.set(10, 20);
	}
}
