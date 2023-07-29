package;

import bitdecay.flixel.debug.DebugDraw;
import debug.Debug;
import debug.DebugLayers;
import entities.Blade;
import entities.Cube;
import entities.Long;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import flixel.util.FlxSort;
import iso.Grid;
import iso.IsoSprite;

class PlayState extends FlxState {
	var cube:IsoSprite;
	var blade:IsoSprite;
	var long:IsoSprite;

	var sortOrder = new FlxTypedGroup<IsoSprite>();

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
		long = new Long(10, 40);

		blade.immovable = true;
		long.immovable = true;

		sortOrder.add(cube);
		sortOrder.add(blade);
		sortOrder.add(long);
		add(sortOrder);

		camera.scroll.set(-FlxG.camera.width / 2, -10);
	}

	var mTmp = FlxPoint.get();

	var xAxis = Grid.gridToIso(100, 0);
	var yAxis = Grid.gridToIso(0, 100);

	override public function update(elapsed:Float) {
		super.update(elapsed);

		Grid.drawGrid(5, 5);

		cube.debugDraw(1, FlxColor.GREEN);
		blade.debugDraw(2, FlxColor.RED);
		long.debugDraw(3, FlxColor.YELLOW);

		var mPos = FlxG.mouse.getPosition();

		FlxG.watch.addQuick("Mouse grid pixel: ", Grid.isoToGrid(mPos.x, mPos.y, mTmp));

		var start = FlxPoint.get();
		var end = FlxPoint.get();
		Grid.gridToIso(mTmp.x, 0, start);
		Grid.gridToIso(mTmp.x, 50, end);
		DebugDraw.ME.drawWorldLine(start.x, start.y, end.x, end.y, null, FlxColor.BLUE);

		Grid.gridToIso(0, mTmp.y, start);
		Grid.gridToIso(50, mTmp.y, end);
		DebugDraw.ME.drawWorldLine(start.x, start.y, end.x, end.y, null, FlxColor.BLUE);

		if (FlxG.mouse.pressed) {
			if (FlxG.keys.pressed.ONE) {
				cube.setPosition(mTmp.x, mTmp.y);
			}
			else if (FlxG.keys.pressed.TWO) {
				blade.setPosition(mTmp.x, mTmp.y);
			}
			else if (FlxG.keys.pressed.THREE) {
				long.setPosition(mTmp.x, mTmp.y);
			}
		}

		// sortOrder.sort(isoSort);

		if (FlxG.keys.pressed.W) {
			cube.y -= 30 * elapsed;
		}
		else if (FlxG.keys.pressed.S) {
			cube.y += 30 * elapsed;
		}
		else if (FlxG.keys.pressed.A) {
			cube.x -= 30 * elapsed;
		}
		else if (FlxG.keys.pressed.D) {
			cube.x += 30 * elapsed;
		}

		FlxG.collide(sortOrder, sortOrder);

		if (doSpritesOverlapInIsoSpace(long, cube)) {
			if (isSpriteInFront(long, cube)) {
				sortOrder.remove(long, true);
				sortOrder.add(long);
			}
			else {
				sortOrder.remove(cube, true);
				sortOrder.add(cube);
			}
		}

		if (doSpritesOverlapInIsoSpace(cube, blade)) {
			if (isSpriteInFront(cube, blade)) {
				sortOrder.remove(cube, true);
				sortOrder.add(cube);
			}
			else {
				sortOrder.remove(blade, true);
				sortOrder.add(blade);
			}
		}

		if (doSpritesOverlapInIsoSpace(blade, long)) {
			if (isSpriteInFront(blade, long)) {
				sortOrder.remove(blade, true);
				sortOrder.add(blade);
			}
			else {
				sortOrder.remove(long, true);
				sortOrder.add(long);
			}
		}
	}

	function isoSort(order:Int, a:IsoSprite, b:IsoSprite):Int {
		if (doSpritesOverlapInIsoSpace(a, b)) {
			if (isSpriteInFront(a, b)) {
				return 1;
			}
			else if (isSpriteInFront(b, a)) {
				return -1;
			}
			else {
				return 0;
			}
		}
		else {
			// TODO: Is this necessary? We may only care about sorting elements if there is overlap
			// But we also might make things overall more efficient if we keep things sorted always
			var tmpA = Grid.gridToIso(a.x, a.y);
			var tmpB = Grid.gridToIso(b.x, b.y);
			if (tmpA.y < tmpB.y) {
				return -1;
			}
			else {
				return 1;
			}
		}
		return 0;
	}

	// returns true if blocks overlap on all 3 axes in iso projection space
	function doSpritesOverlapInIsoSpace(a:IsoSprite, b:IsoSprite):Bool {
		var aXMin = a.isoXmin;
		var aXMax = a.isoXmax;
		var aYMin = a.isoYmin;
		var aYMax = a.isoYmax;
		var aHMin = a.hMin;
		var aHMax = a.hMax;

		var bXMin = b.isoXmin;
		var bXMax = b.isoXmax;
		var bYMin = b.isoYmin;
		var bYMax = b.isoYmax;
		var bHMin = b.hMin;
		var bHMax = b.hMax;

		var xOverlap = !(aXMin >= bXMax || bXMin >= aXMax);
		var yOverlap = !(aYMin >= bYMax || bYMin >= aYMax);
		var zOverlap = !(aHMin >= bHMax || bHMin >= aHMax);

		return xOverlap && yOverlap && zOverlap;

		// Hexagons overlap if and only if all axis regions overlap.
		// return ( // test if x regions intersect.
		// 	!(a.gridXmin >= b.gridXmax || b.gridXmin >= a.gridXmax) && // test if y regions intersect.
		// 	!(a.gridYmin >= b.gridYmax || b.gridYmin >= a.gridYmax) && // test if h regions intersect.
		// 	!(a.hMin >= b.hMax || b.hMin >= a.hMax));
	}

	function isSpriteInFront(a:IsoSprite, b:IsoSprite) {
		// test for intersection x-axis
		// (larger x value is in front)
		var aGXMin = a.gridXmin;
		var bGXMax = b.gridXmax;
		if (a.gridXmin >= b.gridXmax) {
			return true;
		}
		else if (b.gridXmin >= a.gridXmax) {
			return false;
		}

		// test for intersection y-axis
		// (larger2 y value is in front)
		if (a.gridYmin >= b.gridYmax) {
			return true;
		}
		else if (b.gridYmin >= a.gridYmax) {
			return false;
		}

		// // test for intersection z-axis
		// // (higher z value is in front)
		// if (a.gridZmin >= b.gridZmax)
		// {
		// 	return true;
		// }
		// else if (b.gridZmin >= a.gridZmax)
		// {
		// 	return false;
		// }

		// default response
		return false;
	}
}
