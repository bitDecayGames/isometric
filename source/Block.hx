package;

import bitdecay.flixel.debug.DebugDraw;
import debug.DebugLayers;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;

class Block extends FlxSprite
{
	// pixels per grid space?
	public static final GRID_CELL_SIZE = 12;

	public static final TILE_WIDTH = 22;
	public static final TILE_HEIGHT = 11;

	// size of the block
	public var gridWidth:Float;
	public var gridLength:Float;
	public var gridHeight:Float;

	// these give the footprint of the block
	public var gridXmin(get, never):Float;
	public var gridXmax(get, never):Float;
	public var gridYmin(get, never):Float;
	public var gridYmax(get, never):Float;
	public var gridZmin(get, never):Float;
	public var gridZmax(get, never):Float;

	// these give the screenspace occupied by the block
	public var isoXmin(get, never):Float;
	public var isoXmax(get, never):Float;
	public var isoYmin(get, never):Float;
	public var isoYmax(get, never):Float;
	public var hMin(get, never):Float;
	public var hMax(get, never):Float;

	override function draw()
	{
		var saveX = x;
		var saveY = y;

		var tmp = gridToIso(x, y);
		x = tmp.x;
		y = tmp.y;
		tmp.put();

		// FlxG.debugger.drawDebug = false;
		super.draw();
		// FlxG.debugger.drawDebug = true;

		x = saveX;
		y = saveY;

		// drawDebug();
	}

	public static function gridToIso(x:Float, y:Float, ?p:FlxPoint):FlxPoint
	{
		if (p == null)
		{
			p = FlxPoint.get();
		}

		var isoX = (x - y) / GRID_CELL_SIZE * (TILE_WIDTH / 2);
		var isoY = (x + y) / GRID_CELL_SIZE * (TILE_HEIGHT / 2);

		p.set(isoX, isoY);
		return p;
	}

	public static function isoToGrid(x:Float, y:Float, ?p:FlxPoint):FlxPoint
	{
		if (p == null)
		{
			p = FlxPoint.get();
		}

		p.x = (y / Block.TILE_HEIGHT + x / Block.TILE_WIDTH) * Block.GRID_CELL_SIZE;
		p.y = (y / Block.TILE_HEIGHT - x / Block.TILE_WIDTH) * Block.GRID_CELL_SIZE;

		return p;
	}

	function get_gridXmin():Float
	{
		return x - (gridWidth * GRID_CELL_SIZE);
	}

	function get_gridXmax():Float
	{
		return x;
	}

	function get_gridYmin():Float
	{
		return y - (gridLength * GRID_CELL_SIZE);
	}

	function get_gridYmax():Float
	{
		return y;
	}

	function get_gridZmin():Float
	{
		return 0;
	}

	function get_gridZmax():Float
	{
		return gridHeight * GRID_CELL_SIZE;
	}

	function get_isoXmin():Float
	{
		return x - ((gridWidth + gridHeight) * GRID_CELL_SIZE);
	}

	function get_isoXmax():Float
	{
		return x;
	}

	function get_isoYmin():Float
	{
		return y - ((gridLength + gridHeight) * GRID_CELL_SIZE);
	}

	function get_isoYmax():Float
	{
		return y;
	}

	function get_hMin():Float
	{
		return gridToIso(x - gridWidth * GRID_CELL_SIZE, y).x;
	}

	function get_hMax():Float
	{
		return gridToIso(x, y - gridLength * GRID_CELL_SIZE).x;
	}

	public function debugDraw(i:Int, color:FlxColor)
	{
		var start = FlxPoint.get();
		var end = FlxPoint.get();
		gridToIso(gridXmin, -i, start);
		gridToIso(gridXmax, -i, end);
		DebugDraw.ME.drawWorldLine(start.x, start.y, end.x, end.y, DebugLayers.GRID_SPACE, color);

		gridToIso(-i, gridYmin, start);
		gridToIso(-i, gridYmax, end);
		DebugDraw.ME.drawWorldLine(start.x, start.y, end.x, end.y, DebugLayers.GRID_SPACE, color);

		gridToIso(isoXmin, -i, start);
		gridToIso(isoXmax, -i, end);
		DebugDraw.ME.drawWorldLine(start.x, start.y, end.x, end.y, DebugLayers.ISO_SPACE, color);

		gridToIso(-i, isoYmin, start);
		gridToIso(-i, isoYmax, end);
		DebugDraw.ME.drawWorldLine(start.x, start.y, end.x, end.y, DebugLayers.ISO_SPACE, color);

		start.put();
		end.put();

		DebugDraw.ME.drawWorldLine(hMin, -i, hMax, -i, null, color);
	}
}
