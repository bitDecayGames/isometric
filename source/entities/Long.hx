package entities;

import flixel.FlxSprite;
import iso.IsoSprite;

class Long extends IsoSprite {
	public function new(X:Float, Y:Float) {
		gridWidth = 1;
		gridLength = 2.4;
		gridMaxHeight = 1;

		super(X, Y);
		sprite = new FlxSprite(AssetPaths.Block_5x10x10__png);
		sprite.offset.set(10, 27);
	}
}
