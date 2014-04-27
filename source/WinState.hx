package ;
import flixel.FlxG;
import flixel.FlxState;
import flixel.input.keyboard.FlxKey;
import flixel.text.FlxText;
import flixel.tile.FlxTilemap;

/**
 * ...
 * @author Masadow
 */
class WinState extends FlxState
{
	private var seconds : Int;

	public function new(seconds : Int = 0)
	{
		super();
		this.seconds = seconds;
	}

	override public function create():Void
	{
		super.create();

		//Make the level
		var lvl : String = openfl.Assets.getText("data/level1.pyxel");

		var lines : Array<String> = lvl.split("\n");

		var underground = "";
		var current_layer = -1;
		for (line in lines)
		{
			if (line.length == 0)
				continue ;
			if (StringTools.startsWith(line, "layer 0"))
				current_layer = 0;
			else if (StringTools.startsWith(line, "layer 1"))
				break ;
			else if (current_layer == 0)
				underground += line + "\n";
		}
		
		var tmap = new FlxTilemap();
		tmap.loadMap(underground, "images/ld29.png", 32, 32);

		add(tmap);

		var txt = new FlxText(0, 250, 640, "YOU WIN !", 48);
		txt.alignment = "center";
		add(txt);

		txt = new FlxText(0, 310, 640, "You spent " + seconds + " seconds moving around.", 20);
		txt.alignment = "center";
		add(txt);

		txt = new FlxText(0, 500, 640, "Press any key to start again.", 20);
		txt.alignment = "center";
		add(txt);
		
	}
	
	override public function update():Void 
	{
		super.update();

		if (FlxG.keys.justPressed.ANY)
		{
			FlxG.switchState(new PlayState());
		}
	}
}
