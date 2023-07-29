package;

import bitdecay.flixel.debug.DebugDraw;
import debug.DebugLayers;
import flixel.FlxG;
import flixel.FlxGame;
import openfl.display.Sprite;

class Main extends Sprite
{
	public function new()
	{
		super();
		addChild(new FlxGame(Std.int(640 / 4), Std.int(480 / 4), PlayState));

		FlxG.autoPause = false;
		DebugDraw.init(Type.allEnums(DebugLayers));
	}
}
