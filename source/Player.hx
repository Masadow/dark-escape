package ;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.tile.FlxTilemap;

/**
 * ...
 * @author Masadow
 */
class Player extends FlxSprite
{
	
	private var map : FlxTilemap;
	public var justMoved : Bool;

	public function new(map : FlxTilemap) 
	{
		super(4, 4);
		makeGraphic(8, 8);

		this.map = map;
		justMoved = true;
	}

	private function moveTo(newx : Float, newy : Float)
	{
		//Check all corners for collision
		if (newx < 0 || newy < 0 || newx + 8 > 640 || newy + 8 > 640
			|| map.getTile(Std.int(newx / 32), Std.int(newy / 32)) == Tiles.WALL
			|| map.getTile(Std.int((newx + 8) / 32), Std.int((newy + 8) / 32)) == Tiles.WALL
			|| map.getTile(Std.int((newx + 8) / 32), Std.int(newy / 32)) == Tiles.WALL
			|| map.getTile(Std.int(newx / 32), Std.int((newy + 8) / 32)) == Tiles.WALL)
			return ;
		x = newx;
		y = newy;
		justMoved = true;
	}
	
	override public function update():Void 
	{
		super.update();

		justMoved = false;
		var speed = FlxG.elapsed * 100;
		if (FlxG.keys.pressed.DOWN || FlxG.keys.pressed.S)
			moveTo(x, y + speed);
		if (FlxG.keys.pressed.UP || FlxG.keys.pressed.W)
			moveTo(x, y - speed);
		if (FlxG.keys.pressed.LEFT || FlxG.keys.pressed.A)
			moveTo(x - speed, y);
		if (FlxG.keys.pressed.RIGHT || FlxG.keys.pressed.D)
			moveTo(x + speed, y);
		
	}

}