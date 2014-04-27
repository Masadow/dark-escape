package ;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.tile.FlxTilemap;
import openfl.Assets;

/**
 * ...
 * @author Masadow
 */
class Level extends FlxGroup
{
	public var player : Player;
	private var undergroundMap : FlxTilemap;
	private var elapsed : Float;

	public function new(n : Int) 
	{
		super();

		//Make the level
		var lvl : String = Assets.getText("data/level" + n + ".pyxel");

		var lines : Array<String> = lvl.split("\n");

		var underground = "";
		var surface = "";
		var current_layer = -1;
		for (line in lines)
		{
			if (line.length == 0)
				continue ;
			if (StringTools.startsWith(line, "layer 0"))
				current_layer = 0;
			else if (StringTools.startsWith(line, "layer 1"))
				current_layer = 1;
			else if (current_layer == 0)
				underground += line + "\n";
			else if (current_layer == 1)
				surface += line + "\n";
		}
		
		undergroundMap = new FlxTilemap();
		undergroundMap.loadMap(underground, "images/ld29.png", 32, 32);
		undergroundMap.setTileProperties(Tiles.WALL, FlxObject.ANY);
		undergroundMap.setTileProperties(Tiles.FLOOR, FlxObject.NONE);
		undergroundMap.setTileProperties(Tiles.WIN, FlxObject.NONE);

		var surfaceMap = new FlxTilemap();
		surfaceMap.loadMap(surface, "images/ld29.png", 32, 32);
		
		var content = new FlxGroup();


		player = new Player(undergroundMap);

		var flashlight = new Flashlight(undergroundMap, player);

		content.add(flashlight);
		content.add(player);
		
		add(undergroundMap); //Underground layer
		add(content); //Middle layer
		add(surfaceMap); //Surface layer
		
		elapsed = 0;
	}
	
	override public function update():Void 
	{
		super.update();
		
		var p = player.getMidpoint();
		
		elapsed += FlxG.elapsed;
		
		if (undergroundMap.getTile(Std.int(p.x / 32), Std.int(p.y / 32)) == Tiles.WIN)
		{
			FlxG.switchState(new WinState(Math.round(elapsed)));
		}
	}
	
}