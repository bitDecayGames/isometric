package;

class Blade extends Block
{
	public function new(X:Float, Y:Float)
	{
		super(X, Y);
		loadGraphic(AssetPaths.Block_3x7x10__png);
		offset.set(6, 28);
		// setSize(10, 10);
		gridWidth = .6;
		gridLength = 1.4;
		gridHeight = 2;
	}
}
