package entities;

import flixel.FlxSprite;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import iso.Grid;
import iso.IsoSprite;

class FloatingCube extends IsoSprite {
	public function new(X:Float, Y:Float) {
		gridWidth = 1;
		gridLength = 1;
		z = 0 * Grid.CELL_SIZE;
		gridHeight = 1;

		super(X, Y);
		color = FlxColor.MAGENTA;

		sprite = new FlxSprite(AssetPaths.Block_5x5x10_floating__png);
		sprite.offset.set(10, 20);

		FlxTween.tween(this, {z: 2 * Grid.CELL_SIZE}, {
			type: FlxTweenType.PINGPONG,
			ease: FlxEase.sineInOut
		});
	}
}
