package;

class Long extends Block
{
	public function new(X:Float, Y:Float)
	{
		super(X, Y);
		loadGraphic(AssetPaths.Block_5x10x10__png);
		offset.set(10, 27);
		// setSize(10, 24);
		gridWidth = 1;
		gridLength = 2.4;
		gridHeight = 1;
	}
}
