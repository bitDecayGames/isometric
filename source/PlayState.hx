package;

import bitdecay.flixel.debug.DebugDraw;
import debug.Debug;
import debug.DebugLayers;
import entities.Blade;
import entities.Cube;
import entities.ExtraLongX;
import entities.FloatingCube;
import entities.LongX;
import entities.LongY;
import entities.SquareShadow;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxGroup;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import flixel.util.FlxSort;
import iso.Grid;
import iso.IsoSprite;
import iso.Overlap;
import topo.Tophographic.Topographic;

class PlayState extends FlxState {
	var cube:IsoSprite;
	var blade:IsoSprite;
	var longY:IsoSprite;
	var longX:IsoSprite;
	var floater:IsoSprite;
	var shadow:IsoSprite;
	var extraLongX:IsoSprite;

	var graph:Topographic;
	var collidables = new FlxTypedGroup<FlxObject>();

	var mouseModeIso = false;

	override public function create() {
		super.create();

		bgColor = FlxColor.GRAY.getDarkened(.5);
		camera.pixelPerfectRender = true;

		#if FLX_DEBUG
		FlxG.camera.width = Std.int(FlxG.camera.width / 2);
		Debug.dbgCam = new FlxCamera(Std.int(camera.x + camera.width), 0, camera.width, camera.height, camera.zoom);
		Debug.dbgCam.bgColor = FlxColor.RED.getDarkened(0.6);
		FlxG.cameras.add(Debug.dbgCam, false);
		#end

		cube = new Cube(10, 10);
		blade = new Blade(30, 25);
		longY = new LongY(10, 40);
		longX = new LongX(40, 10);
		extraLongX = new ExtraLongX(50, 50);
		floater = new FloatingCube(60, 60);
		shadow = new SquareShadow(floater);
		add(shadow);

		// blade.immovable = true;
		// longY.immovable = true;
		// longX.immovable = true;
		// floater.immovable = true;

		graph = new Topographic([]);
		add(graph);
		graph.add(cube);
		graph.add(blade);
		graph.add(longY);
		graph.add(longX);
		graph.add(extraLongX);
		graph.add(floater);
		graph.rebuild();

		collidables.add(cube);
		collidables.add(blade);
		collidables.add(longY);
		collidables.add(longX);
		collidables.add(extraLongX);
		collidables.add(floater);

		camera.scroll.set(-FlxG.camera.width / 2, -10);
	}

	var mTmp = FlxPoint.get();
	var mIsoStart = FlxPoint.get();
	var mIsoEnd = FlxPoint.get();
	var mCartStart = FlxPoint.get();
	var mCartEnd = FlxPoint.get();

	override public function update(elapsed:Float) {
		Grid.drawGrid(5, 5);

		cube.debugDraw(1, FlxColor.GREEN);
		extraLongX.debugDraw(1, FlxColor.GREEN.getLightened());
		blade.debugDraw(2, FlxColor.RED);
		longY.debugDraw(3, FlxColor.YELLOW);
		longX.debugDraw(4, FlxColor.BLUE);
		floater.debugDraw(5, FlxColor.MAGENTA);

		var rawPos = FlxG.mouse.getScreenPosition();
		var mPos = FlxG.mouse.getPosition();
		Grid.isoToGrid(mPos.x, mPos.y, mTmp);
		FlxG.watch.addQuick("raw mouse Position: ", rawPos);

		if (FlxG.mouse.pressed) {
			if (rawPos.x < FlxG.width / 2) {
				mouseModeIso = true;
				FlxG.watch.addQuick("Mouse grid pixel: ", mTmp);
			} else {
				mouseModeIso = false;
				FlxG.watch.addQuick("Mouse grid pixel: ", FlxG.mouse.getPositionInCameraView(Debug.dbgCam, mTmp));
			}
			if (FlxG.keys.pressed.ONE) {
				cube.setPosition(mTmp.x, mTmp.y);
			} else if (FlxG.keys.pressed.TWO) {
				blade.setPosition(mTmp.x, mTmp.y);
			} else if (FlxG.keys.pressed.THREE) {
				longY.setPosition(mTmp.x, mTmp.y);
			} else if (FlxG.keys.pressed.FOUR) {
				longX.setPosition(mTmp.x, mTmp.y);
			} else if (FlxG.keys.pressed.FIVE) {
				floater.setPosition(mTmp.x, mTmp.y);
			} else if (FlxG.keys.pressed.SIX) {
				extraLongX.setPosition(mTmp.x, mTmp.y);
			}
		}

		mouseDebugDraw();

		if (FlxG.keys.pressed.W) {
			cube.y -= 30 * elapsed;
		}
		if (FlxG.keys.pressed.S) {
			cube.y += 30 * elapsed;
		}
		if (FlxG.keys.pressed.A) {
			cube.x -= 30 * elapsed;
		}
		if (FlxG.keys.pressed.D) {
			cube.x += 30 * elapsed;
		}

		// if (FlxG.keys.pressed.R) {
		graph.rebuild();
		// }

		graph.drawDebug();

		FlxG.overlap(collidables, collidables, null, Overlap.isoCollide);
		// FlxG.collide(collidables, collidables);

		super.update(elapsed);
	}

	function mouseDebugDraw() {
		if (FlxG.keys.justPressed.C) {
			mIsoStart.set();
			mIsoEnd.set();
			mCartStart.set();
			mCartEnd.set();
		}

		if (FlxG.mouse.justPressedMiddle) {
			mCartStart.copyFrom(mTmp);
			Grid.gridToIso(mTmp.x, mTmp.y, mIsoStart);
		}

		if (FlxG.mouse.pressedMiddle) {
			mCartEnd.copyFrom(mTmp);
			Grid.gridToIso(mTmp.x, mTmp.y, mIsoEnd);
		}

		if (mIsoStart.length > 0 && mIsoEnd.length > 0) {
			DebugDraw.ME.drawWorldLine(mIsoStart.x, mIsoStart.y, mIsoEnd.x, mIsoEnd.y, null, FlxColor.PINK);
			DebugDraw.ME.drawWorldLine(Debug.dbgCam, mCartStart.x, mCartStart.y, mCartEnd.x, mCartEnd.y, null, FlxColor.PINK);
			FlxG.watch.addQuick("Line Length (Abs): ", Std.int(mCartStart.distanceTo(mCartEnd) * 100) / 100.0);
			FlxG.watch.addQuick("Line Length (Cells): ", Std.int(mCartStart.distanceTo(mCartEnd) / Grid.CELL_SIZE * 10) / 10.0);
		}

		var start = FlxPoint.get();
		var end = FlxPoint.get();
		Grid.gridToIso(mTmp.x, -100, start);
		Grid.gridToIso(mTmp.x, 100, end);
		DebugDraw.ME.drawWorldLine(start.x, start.y, end.x, end.y, null, FlxColor.WHITE);

		Grid.gridToIso(-100, mTmp.y, start);
		Grid.gridToIso(100, mTmp.y, end);
		DebugDraw.ME.drawWorldLine(start.x, start.y, end.x, end.y, null, FlxColor.WHITE);
	}

	function isoSort(order:Int, a:IsoSprite, b:IsoSprite):Int {
		if (Overlap.doSpritesOverlapInIsoSpace(a, b)) {
			if (Overlap.isSpriteInFront(a, b)) {
				return 1;
			} else if (Overlap.isSpriteInFront(b, a)) {
				return -1;
			} else {
				return 0;
			}
		} else {
			// TODO: Is this necessary? We may only care about sorting elements if there is overlap
			// But we also might make things overall more efficient if we keep things sorted always
			var tmpA = Grid.gridToIso(a.x, a.y);
			var tmpB = Grid.gridToIso(b.x, b.y);
			if (tmpA.y < tmpB.y) {
				return -1;
			} else {
				return 1;
			}
		}
		return 0;
	}
}
