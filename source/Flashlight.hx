package ;
import flash.display.BitmapData;
import flash.display.BitmapDataChannel;
import flash.filters.BitmapFilter;
import flash.geom.Point;
import flash.geom.Rectangle;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.input.mouse.FlxMouse;
import flixel.tile.FlxTilemap;
import flixel.util.FlxAngle;
import flixel.util.FlxColor;
import flixel.util.FlxPoint;
import flixel.util.FlxSpriteUtil;

/**
 * ...
 * @author Masadow
 */
class Flashlight extends FlxSprite
{
	var map : FlxTilemap;
	var player : Player;
	var lastTargetX : Float;
	var lastTargetY : Float;
	
	var power = 100;
	var visionAngle = Math.PI / 6;
	var halfVisionAngle : Float;
	var rays = 100;
	var step : Float;
	
	var cosTable : Array<Float> = new Array<Float>();
	var sinTable : Array<Float> = new Array<Float>();

	var light : FlxSprite;

	public function new(map : FlxTilemap, player : Player)
	{
		super();
		makeGraphic(640, 640, FlxColor.BLACK);
		
		light = new FlxSprite();
		light.makeGraphic(640, 640, 0x00FFFFFF);
		
		this.map = map;
		this.player = player;
		
		step = visionAngle / (rays - 1);
		halfVisionAngle = visionAngle / 2;
		
		//Calculate all angles
		var angle = -halfVisionAngle;
		for (i in 0...rays)
		{
			cosTable.push(Math.cos(angle));
			sinTable.push(Math.sin(angle));
			angle += step;
		}
	}

	override public function update():Void 
	{
		super.update();

		var origin = FlxPoint.get(player.x + 4, player.y + 4);

		if (FlxG.mouse.x != origin.x || FlxG.mouse.y != origin.y)
		{
			FlxSpriteUtil.fill(this, FlxColor.BLACK);
			FlxSpriteUtil.fill(light, 0xFF0000FF);

			var rotated = FlxPoint.get();
			var vertices = new Array<FlxPoint>();
			vertices.push(origin);
			for (i in 0...rays)
			{
				rotated.x = (FlxG.mouse.x - origin.x) * cosTable[i] - (FlxG.mouse.y - origin.y) * sinTable[i] + origin.x;
				rotated.y = (FlxG.mouse.x - origin.x) * sinTable[i] + (FlxG.mouse.y - origin.y) * cosTable[i] + origin.y;
//				Bugged ?
//				rotated = FlxAngle.rotatePoint(FlxG.mouse.x, FlxG.mouse.y, origin.x, origin.y, FlxAngle.asDegrees(angle));
				var target = findBorder(origin, rotated);
				map.ray(origin, target, target, 10);
				vertices.push(target);
			}
			FlxSpriteUtil.drawPolygon(light, vertices, 0xFFFF0000, { color: 0xFFFF0000, thickness: 1 }, { color: 0xFFFF0000 } );
			pixels.copyChannel(light.pixels, new Rectangle(0, 0, width, height), new Point(), BitmapDataChannel.BLUE, BitmapDataChannel.ALPHA);
		}
		origin.destroy();
	}
	
	private function findBorder(origin : FlxPoint, mouse : FlxPoint) : FlxPoint
	{
		var result : FlxPoint = FlxPoint.get(mouse.x, mouse.y);

		var a = (mouse.y - origin.y)  / (mouse.x - origin.x);
		var b = mouse.y - a * mouse.x;

		//Project on Y first
		if (mouse.x > origin.x)
		{
			result.x = 639;
			result.y = result.x * a + b;
		}
		else if (mouse.x < origin.x)
		{
			result.x = 0;
			result.y = b;
		}
		else if (mouse.y > origin.y)
		{
			result.x = mouse.x;
			result.y = 639;
		}
		else
		{
			result.x = mouse.x;
			result.y = 0;
		}

		if (result.y > 639 || result.y < 0)
		{
			var a = (mouse.x - origin.x)  / (mouse.y - origin.y);
			var b = mouse.x - a * mouse.y;
			//Project on X then
			if (mouse.y > origin.y)
			{
				result.y = 639;
				result.x = result.y * a + b;
			}
			else if (mouse.y < origin.y)
			{
				result.y = 0;
				result.x = b;
			}
			else if (mouse.x > origin.x)
			{
				result.y = mouse.y;
				result.x = 639;
			}
			else
			{
				result.y = mouse.y;
				result.x = 0;
			}
		}

		return result;
	}
	
}