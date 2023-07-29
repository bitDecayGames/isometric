package;

class Cube extends Block
{
	public function new(X:Float, Y:Float)
	{
		super(X, Y);
		loadGraphic(AssetPaths.Block_5x5x10__png);
		offset.set(10, 20);
		// setSize(10, 10);
		gridWidth = 1;
		gridLength = 1;
		gridHeight = 1;
	}
}
