package entities;

import flixel.FlxSprite;
import flixel.util.FlxColor;
import iso.Grid;
import iso.IsoSprite;

class Blade extends IsoSprite {
	public function new(X:Float, Y:Float) {
		gridWidth = .5;
		gridLength = 1.3;
		gridHeight = 2;

		super(X, Y);
		color = FlxColor.RED;

		sprite = new FlxSprite(AssetPaths.Block_3x7x10__png);
		sprite.offset.set(6, 28);
	}
}
