package entities;

import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import iso.IsoSprite;

class SquareShadow extends IsoSprite {
	var track:FlxObject;

	public function new(track:FlxObject) {
		this.track = track;

		gridWidth = 1;
		gridLength = 1;
		gridHeight = 0;

		super();
		color = FlxColor.GRAY;

		sprite = new FlxSprite(AssetPaths.squareShadow__png);
		sprite.offset.set(10, 10);
	}

	override function update(elapsed:Float) {
		super.update(elapsed);

		x = track.x;
		y = track.y;
	}
}
