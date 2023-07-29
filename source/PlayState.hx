package;

import bitdecay.flixel.debug.DebugDraw;
import bitdecay.flixel.sorting.ZSorting;
import debug.DebugLayers;
import flixel.FlxG;
import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import flixel.util.FlxSort;

class PlayState extends FlxState
{
	var cube:Block;
	var blade:Block;
	var long:Block;

	var sortOrder = new FlxTypedGroup<Block>();

	override public function create()
	{
		super.create();

		bgColor = FlxColor.GRAY.getDarkened(.5);
		camera.pixelPerfectRender = true;

		cube = new Cube(10, 10);
		blade = new Blade(30, 25);
		long = new Long(10, 40);

		// blade.immovable = true;
		// long.immovable = true;

		sortOrder.add(cube);
		sortOrder.add(blade);
		sortOrder.add(long);
		add(sortOrder);

		camera.scroll.set(-FlxG.width / 2, -10);
	}

	var mTmp = FlxPoint.get();

	var xAxis = Block.gridToIso(100, 0);
	var yAxis = Block.gridToIso(0, 100);

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		drawGrid(5, 5);

		cube.debugDraw(1, FlxColor.GREEN);
		blade.debugDraw(2, FlxColor.RED);
		long.debugDraw(3, FlxColor.YELLOW);

		var mPos = FlxG.mouse.getPosition();

		FlxG.watch.addQuick("Mouse grid pixel: ", Block.isoToGrid(mPos.x, mPos.y, mTmp));

		var start = FlxPoint.get();
		var end = FlxPoint.get();
		Block.gridToIso(mTmp.x, 0, start);
		Block.gridToIso(mTmp.x, 50, end);
		DebugDraw.ME.drawWorldLine(start.x, start.y, end.x, end.y, null, FlxColor.BLUE);

		Block.gridToIso(0, mTmp.y, start);
		Block.gridToIso(50, mTmp.y, end);
		DebugDraw.ME.drawWorldLine(start.x, start.y, end.x, end.y, null, FlxColor.BLUE);

		if (FlxG.mouse.pressed)
		{
			if (FlxG.keys.pressed.ONE)
			{
				cube.setPosition(mTmp.x, mTmp.y);
			}
			else if (FlxG.keys.pressed.TWO)
			{
				blade.setPosition(mTmp.x, mTmp.y);
			}
			else if (FlxG.keys.pressed.THREE)
			{
				long.setPosition(mTmp.x, mTmp.y);
			}
		}

		haxe.ds.ArraySort.sort(sortOrder.members, isoSort);
		// sortOrder.sort(isoSort);

		if (FlxG.keys.pressed.W)
		{
			cube.y -= 30 * elapsed;
		}
		else if (FlxG.keys.pressed.S)
		{
			cube.y += 30 * elapsed;
		}
		else if (FlxG.keys.pressed.A)
		{
			cube.x -= 30 * elapsed;
		}
		else if (FlxG.keys.pressed.D)
		{
			cube.x += 30 * elapsed;
		}

		// FlxG.collide(sortOrder, sortOrder);
	}

	function drawGrid(xs:Int, ys:Int)
	{
		DebugDraw.ME.drawWorldLine(0, 0, xAxis.x, xAxis.y, DebugLayers.GRID);
		DebugDraw.ME.drawWorldLine(0, 0, yAxis.x, yAxis.y, DebugLayers.GRID);

		var start = FlxPoint.get();
		var end = FlxPoint.get();
		for (i in 0...xs)
		{
			Block.gridToIso(i * Block.GRID_CELL_SIZE, 0, start);
			Block.gridToIso(i * Block.GRID_CELL_SIZE, 50, end);
			DebugDraw.ME.drawWorldLine(start.x, start.y, end.x, end.y, DebugLayers.GRID);
		}

		for (i in 0...ys)
		{
			Block.gridToIso(0, i * Block.GRID_CELL_SIZE, start);
			Block.gridToIso(50, i * Block.GRID_CELL_SIZE, end);
			DebugDraw.ME.drawWorldLine(start.x, start.y, end.x, end.y, DebugLayers.GRID);
		}

		start.put();
		end.put();
	}

	function isoSort(a:Block, b:Block):Int
	{
		if (doBlocksOverlap(a, b))
		{
			if (isBlockInFront(a, b))
			{
				return 1;
			}
			else if (isBlockInFront(b, a))
			{
				return -1;
			}
			else
			{
				return 0;
			}
		}
		else
		{
			// TODO: Is this necessary? We may only care about sorting elements if there is overlap
			// But we also might make things overall more efficient if we keep things sorted always
			var tmpA = Block.gridToIso(a.x, a.y);
			var tmpB = Block.gridToIso(b.x, b.y);
			if (tmpA.y < tmpB.y)
			{
				return -1;
			}
			else
			{
				return 1;
			}
		}
		return 0;
	}

	// returns true if blocks overlap on all 3 axes
	function doBlocksOverlap(a:Block, b:Block):Bool
	{
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

	function isBlockInFront(a:Block, b:Block)
	{
		// test for intersection x-axis
		// (larger x value is in front)
		if (a.gridXmin >= b.gridXmax)
		{
			return true;
		}
		else if (b.gridXmin >= a.gridXmax)
		{
			return false;
		}

		// test for intersection y-axis
		// (larger2 y value is in front)
		if (a.gridYmin >= b.gridYmax)
		{
			return true;
		}
		else if (b.gridYmin >= a.gridYmax)
		{
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
