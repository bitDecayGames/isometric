package iso;

#if isodebug
import debug.Debug;
import debug.DebugLayers;
#end
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;

class IsoSprite extends FlxSprite implements IsoSortable {
	public var sprite:FlxSprite;

	public var z:Float = 0;

	// an adjustment modifier when computing
	// grid size to ensure rendering is nice.
	// Objects are shrunk by this amount on
	// all sides.
	public static inline var adjust = 1;

	// size of the block
	public var gridWidth:Float;
	public var gridLength:Float;
	public var gridHeight:Float;

	public function new(X:Float = 0, Y:Float = 0) {
		super(X, Y);

		// It is critical that your grid size matches well with your `sprite` graphic so collisions feel correct
		makeGraphic(Math.ceil(gridWidth * Grid.CELL_SIZE), Math.ceil(gridLength * Grid.CELL_SIZE));

		#if isodebug
		if (Debug.dbgCam != null) {
			camera = Debug.dbgCam;
		}
		#end
	}

	override function draw() {
		// Only draw 2d representation in debug
		#if FLX_DEBUG
		super.draw();
		#end

		// iso renders based on the bottom left corner
		var tmp = Grid.gridToIso(x + width - z, y + height - z);
		sprite.setPosition(tmp.x, tmp.y);
		tmp.put();
		var dbgDraw = FlxG.debugger.drawDebug;
		FlxG.debugger.drawDebug = false;
		sprite.draw();
		FlxG.debugger.drawDebug = dbgDraw;
	}

	public function get_gridXmin():Float {
		return x + adjust;
	}

	public function get_gridXmax():Float {
		return x + (gridWidth * Grid.CELL_SIZE) - adjust;
	}

	public function get_gridYmin():Float {
		return y + adjust;
	}

	public function get_gridYmax():Float {
		return y + (gridLength * Grid.CELL_SIZE) - adjust;
	}

	public function get_gridZmin():Float {
		return z + adjust;
	}

	public function get_gridZmax():Float {
		return z + gridHeight * Grid.CELL_SIZE - adjust;
	}

	public function get_isoXmin():Float {
		return x - gridHeight * Grid.CELL_SIZE - z;
	}

	public function get_isoXmax():Float {
		return x + gridWidth * Grid.CELL_SIZE - z;
	}

	public function get_isoYmin():Float {
		return y - gridHeight * Grid.CELL_SIZE - z;
	}

	public function get_isoYmax():Float {
		return y + gridLength * Grid.CELL_SIZE - z;
	}

	public function get_hMin():Float {
		return Grid.gridToIso(x, y + gridLength * Grid.CELL_SIZE).x;
	}

	public function get_hMax():Float {
		return Grid.gridToIso(x + gridWidth * Grid.CELL_SIZE, y).x;
	}

	public function debugDraw(i:Int, color:FlxColor) {
		#if isodebug
		var start = FlxPoint.get();
		var end = FlxPoint.get();
		Grid.gridToIso(gridXmin, -i, start);
		Grid.gridToIso(gridXmax, -i, end);
		DS.get(DebugDraw).drawWorldLine(start.x, start.y, end.x, end.y, DebugLayers.GRID_SPACE, color);

		Grid.gridToIso(-i, gridYmin, start);
		Grid.gridToIso(-i, gridYmax, end);
		DS.get(DebugDraw).drawWorldLine(start.x, start.y, end.x, end.y, DebugLayers.GRID_SPACE, color);

		Grid.gridToIso(isoXmin, -i, start);
		Grid.gridToIso(isoXmax, -i, end);
		DS.get(DebugDraw).drawWorldLine(start.x, start.y, end.x, end.y, DebugLayers.ISO_SPACE, color);

		Grid.gridToIso(-i, isoYmin, start);
		Grid.gridToIso(-i, isoYmax, end);
		DS.get(DebugDraw).drawWorldLine(start.x, start.y, end.x, end.y, DebugLayers.ISO_SPACE, color);

		start.put();
		end.put();

		DS.get(DebugDraw).drawWorldLine(hMin, -i, hMax, -i, null, color);
		#end
	}

	public function centerPoint(?p:FlxPoint) {
		if (p == null) {
			p = FlxPoint.get();
		}
		return p.set(get_isoXmin() + ((get_isoXmax() - get_isoXmin()) / 2), get_isoYmin() + ((get_isoYmax() - get_isoYmin()) / 2));
	}
}
