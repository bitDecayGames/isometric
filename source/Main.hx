package;

import bitdecay.flixel.debug.DebugDraw;
import debug.DebugLayers;
import flixel.FlxG;
import flixel.FlxGame;
import openfl.display.Sprite;

class Main extends Sprite {
	public function new() {
		super();
		var width = Std.int(640 / 4);
		var height = Std.int(480 / 4);

		#if !FLX_NO_DEBUG
		// FlxG.resizeWindow(width * 6, height * 3);
		width *= 2;
		#end

		addChild(new FlxGame(width, height, PlayState));

		FlxG.autoPause = false;
		#if FLX_DEBUG
		FlxG.debugger.visible = true;
		#end
		DebugDraw.init(Type.allEnums(DebugLayers));
	}
}
