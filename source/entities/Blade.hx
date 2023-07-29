package entities;

import flixel.FlxSprite;
import iso.Grid;
import iso.IsoSprite;

class Blade extends IsoSprite {
	public function new(X:Float, Y:Float) {
		gridWidth = .6;
		gridLength = 1.4;
		gridMaxHeight = 2;

		super(X, Y);

		sprite = new FlxSprite(AssetPaths.Block_3x7x10__png);
		sprite.offset.set(6, 28);
	}
}
