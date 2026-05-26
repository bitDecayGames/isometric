package iso;

import flixel.math.FlxPoint;

interface IsoSortable {
	// these give the footprint of the block
	public function get_gridXmin():Float;
	public function get_gridXmax():Float;
	public function get_gridYmin():Float;
	public function get_gridYmax():Float;
	public function get_gridZmin():Float;
	public function get_gridZmax():Float;

	// these give the screenspace occupied by the block
	public function get_isoXmin():Float;
	public function get_isoXmax():Float;
	public function get_isoYmin():Float;
	public function get_isoYmax():Float;
	public function get_hMin():Float;
	public function get_hMax():Float;

	public function update(elapsed:Float):Void;
	public function draw():Void;
	public function centerPoint(?p:FlxPoint):FlxPoint;
}
