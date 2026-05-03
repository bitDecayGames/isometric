package iso.topo;

// import bitdecay.flixel.debug.DebugDraw;
import debug.DebugLayers;
import flixel.FlxBasic;
import flixel.FlxG;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import flixel.util.FlxSort;
import iso.Grid;
import iso.IsoSortable;
import iso.IsoSprite;
import iso.Overlap;

class Topographic extends FlxBasic {
	public var objects:Array<IsoSortable> = [];

	var nodePool:Array<TNode> = [];

	public var rootNodes:Array<TNode> = [];
	public var allNodes:Array<TNode> = [];

	public function new() {
		super();
	}

	public function add(o:IsoSprite) {
		objects.push(o);
		rootNodes.push(new TNode(o));
	}

	override function update(elapsed:Float) {
		super.update(elapsed);
		for (o in objects) {
			o.update(elapsed);
		}
		rootNodes.sort((rn1, rn2) -> {
			return rn1.children.length - rn2.children.length;
		});
	}

	override function draw() {
		super.draw();
		for (root in rootNodes) {
			root.draw();
		}
	}

	public function drawDebug() {
		for (root in rootNodes) {
			drawGraphBranch(root, root.color);
		}
	}

	private function drawGraphBranch(n:TNode, color:FlxColor = FlxColor.ORANGE, size:Float = 3) {
		if (n.children.length == 0) {
			return;
		}

		var p = n.object.centerPoint();
		Grid.gridToIso(p.x, p.y, p);
		// DebugDraw.ME.drawWorldCircle(p.x, p.y, size, DebugLayers.GRAPH, color);

		var t = FlxPoint.get();
		for (c in n.children) {
			c.object.centerPoint(t);
			Grid.gridToIso(t.x, t.y, t);
			// DebugDraw.ME.drawWorldLine(p.x, p.y, t.x, t.y, DebugLayers.GRAPH, color);

			// var arrowHead = FlxPoint.get().copyFrom(t).subtractPoint(p).rightNormal().pivotDegrees(t, 45).addPoint(t);
			var arrowHead = FlxPoint.get()
				.copyFrom(t)
				.subtractPoint(p)
				.rotateByDegrees(165)
				.normalize()
				.scale(3)
				.addPoint(t);

			drawGraphBranch(c, color.getDarkened(.1), Math.max(0, size - 0.5));
			// draw last so it is on top of the children circles
			// DebugDraw.ME.drawWorldLine(t.x, t.y, arrowHead.x, arrowHead.y, DebugLayers.GRAPH, FlxColor.WHITE);
		}
	}

	var outerNode:TNode = null;
	var innerNode:TNode = null;
	var visitMap:Map<TNode, Array<TNode>> = [];

	public function rebuild() {
		var useIndex = 0;

		// TODO: change this so we aren't allocating every rebuild
		rootNodes = [];
		allNodes = [];

		for (i in 0...objects.length) {
			useIndex++;
			if (nodePool.length < useIndex) {
				nodePool.push(new TNode());
			}
			nodePool[i].reset(objects[i]);
		}

		// build all of our knowledge of parents and children.
		// This may create multiple small graphs as only some objects
		// are overlapping
		for (i in 0...useIndex) {
			outerNode = nodePool[i];
			for (k in 0...useIndex) {
				if (i == k) {
					continue;
				}
				innerNode = nodePool[k];

				if (Overlap.doSpritesOverlapInIsoSpace(outerNode.object, innerNode.object)) {
					if (Overlap.isInFront(innerNode.object, outerNode.object)) {
						outerNode.linkChild(innerNode);
					}
				}
			}
		}

		for (i in 0...useIndex) {
			if (nodePool[i].parents.length == 0) {
				visitMap.clear();
				cutCycles(null, nodePool[i], visitMap);
				trimConnections(nodePool[i]);
				rootNodes.push(nodePool[i]);
			}
		}
	}

	function trimConnections(root:TNode) {
		// TODO: This should be done with a queue for efficiency
		var fringe:Array<TNode> = [root];
		var lastParent:Map<TNode, TNode> = [];

		var focus:TNode = null;
		while (fringe.length > 0) {
			focus = fringe.splice(0, 1)[0];
			if (lastParent.exists(focus)) {
				// we got here some other way, remove the shorter render path
				lastParent[focus].children.remove(focus);
			}

			for (c in focus.children) {
				fringe.push(c); // TODO: We need to add a path here of how we got to c
			}
		}
	}

	// cutCycles basically returns true or false if the connection to this node should be cut from the tree
	function cutCycles(parent:TNode, node:TNode, visited:Map<TNode, Array<TNode>>):Bool {
		if (!visited.exists(node)) {
			visited.set(node, []);
		}

		if (visited[node].contains(parent)) {
			// only cut cycle if we've visited this node from this parent
			return true;
		}

		visited[node].push(parent);

		var i = 0;
		while (i < node.children.length) {
			if (cutCycles(node, node.children[i], visited)) {
				trace("CYCLE CUT BRUH");
				node.children.remove(node.children[i]);
			} else {
				i++;
			}
		}

		return false;
	}
}

class TNode {
	public var color:FlxColor;
	public var visited = false;
	public var parents:Array<TNode> = [];
	public var children:Array<TNode> = [];
	public var object:IsoSortable = null;

	private static var colors = [
		for (i in 0...5) {
			FlxColor.fromHSL(FlxG.random.int(0, 360), FlxG.random.float(.5, 1), FlxG.random.float(.4, .8));
		}
	];
	public static var index = 0;

	public function new(o:IsoSortable = null) {
		object = o;
		parents = [];
		children = [];

		// for debugging. Likely should put this behind a compilation flag
		index = index % colors.length;
		color = colors[index++];
	}

	public function reset(o:IsoSortable):TNode {
		visited = false;
		parents.resize(0); // TODO: This could bel cleaned up to avoid allocation
		children.resize(0); // TODO: This could bel cleaned up to avoid allocation
		object = o;

		return this;
	}

	public function draw() {
		// Need to traverse this graph more intelligently
		// to avoid drawing things multiple times
		object.draw();
		for (c in children) {
			c.draw();
		}
	}

	public function linkChild(n:TNode) {
		children.push(n);
		n.parents.push(this);
	}
}
