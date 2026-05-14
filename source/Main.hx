package;

#if isodebug
import bitdecay.flixel.debug.DebugSuite;
import iso.debug.DebugLayers;
#end
import flixel.FlxG;
import flixel.FlxGame;
import iso.debug.DebugLayers;
import macros.EnumAbstract;
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

		addChild(new FlxGame(width, height, PlayState, 60, 60, true));

		FlxG.autoPause = false;
		#if FLX_DEBUG
		FlxG.debugger.visible = true;
		#end

		#if isodebug
		DS.init(new DebugDraw(EnumAbstract.list(DebugLayers)));
		#end
	}
}
