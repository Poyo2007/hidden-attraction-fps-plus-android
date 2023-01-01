package;

import flixel.FlxG;
import flixel.FlxGame;
import openfl.display.Sprite;
import openfl.system.System;

class Main extends Sprite
{
	public static final framerate:Int = #if desktop 144 #else 60 #end;

	public static var novid:Bool = true;
	public static var flippymode:Bool = false;

	public function new()
	{
		super();

		SUtil.uncaughtErrorHandler();

		#if sys
		novid = Sys.args().contains("-novid");
		flippymode = Sys.args().contains("-flippymode");
		#end

		SUtil.checkPermissions();

		#if (flixel >= "5.0.0")
		addChild(new FlxGame(1280, 720, Startup, framerate, framerate, true));
		#else
		addChild(new FlxGame(1280, 720, Startup, 1, framerate, framerate, true));
		#end

		// The best way to add assets clearing without to add it to a state directly.
		FlxG.signals.preStateSwitch.add(function()
		{
			for (assets in ['graphics', 'sounds'])
				Paths.clearAssets(assets, false);
		});

		addChild(new Overlay(10, 3));

		trace("-=Args=-");
		trace("novid: " + novid);
		trace("flippymode: " + flippymode);
	}
}
