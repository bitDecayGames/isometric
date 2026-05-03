package iso;

import flixel.FlxObject;

class Overlap {
	// returns true if blocks overlap on all 3 axes in iso projection space
	public static function doSpritesOverlapInIsoSpace(a:IsoSortable, b:IsoSortable):Bool {
		var aXMin = a.get_isoXmin();
		var aXMax = a.get_isoXmax();
		var aYMin = a.get_isoYmin();
		var aYMax = a.get_isoYmax();
		var aHMin = a.get_hMin();
		var aHMax = a.get_hMax();

		var bXMin = b.get_isoXmin();
		var bXMax = b.get_isoXmax();
		var bYMin = b.get_isoYmin();
		var bYMax = b.get_isoYmax();
		var bHMin = b.get_hMin();
		var bHMax = b.get_hMax();

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

	public static function isInFront(a:IsoSortable, b:IsoSortable) {
		// test for intersection x-axis
		// (larger x value is in front)
		var aGridXMin = a.get_gridXmin();
		var aGridXMax = a.get_gridXmax();
		var bGridXMin = b.get_gridXmin();
		var bGridXMax = b.get_gridXmax();
		if (aGridXMin >= bGridXMax) {
			return true;
		} else if (bGridXMin >= aGridXMax) {
			return false;
		}

		// test for intersection y-axis
		// (larger2 y value is in front)
		var aGridYMin = a.get_gridYmin();
		var aGridYMax = a.get_gridYmax();
		var bGridYMin = b.get_gridYmin();
		var bGridYMax = b.get_gridYmax();
		if (aGridYMin >= bGridYMin) {
			return true;
		} else if (bGridYMin >= aGridYMax) {
			return false;
		}

		// // test for intersection z-axis
		// // (higher z value is in front)

		// TODO: This doesn't seem to be operating correctly for the floating cube test.
		// This check should be triggering, but it is not
		var aGZMin = a.get_gridZmin();
		var aGZMax = a.get_gridZmax();
		var bGZMin = b.get_gridZmin();
		var bGZMax = b.get_gridZmax();
		if (aGZMin >= bGZMax) {
			return true;
		} else if (bGZMin >= aGZMax) {
			return false;
		}

		// default response
		return false;
	}

	public static function isoCollide(a:IsoSprite, b:IsoSprite):Bool {
		if (a.get_gridZmax() <= b.get_gridZmin() || b.get_gridZmax() <= a.get_gridZmin()) {
			// if they don't overlap on the z-axis, they don't collide
			return false;
		} else {
			var moved = FlxObject.separate(a, b);
			if (!moved) {
				// crushed?
			}
			return moved;
		}
	}
}
