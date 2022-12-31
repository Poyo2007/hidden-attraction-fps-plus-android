package;

import flixel.FlxG;
import flixel.FlxSubState;
#if mobile
import mobile.flixel.FlxVirtualPad;
import flixel.FlxCamera;
import flixel.input.actions.FlxActionInput;
import flixel.util.FlxDestroyUtil;
#end

class MusicBeatSubstate extends FlxSubState
{
	public function new()
	{
		super();
	}

	private var lastBeat:Float = 0;
	private var lastStep:Float = 0;

	private var totalBeats:Int = 0;
	private var totalSteps:Int = 0;

	private var curStep:Int = 0;
	private var curBeat:Int = 0;
	private var controls(get, never):Controls;

	inline function get_controls():Controls
		return PlayerSettings.player1.controls;

	#if mobile
	var virtualPad:FlxVirtualPad;
	var trackedInputsVirtualPad:Array<FlxActionInput> = [];

	public function addVirtualPad(DPad:FlxDPadMode, Action:FlxActionMode)
	{
		if (virtualPad != null)
			removeVirtualPad();

		virtualPad = new FlxVirtualPad(DPad, Action);
		add(virtualPad);

		controls.setVirtualPad(virtualPad, DPad, Action);
		trackedInputsVirtualPad = controls.trackedInputs;
		controls.trackedInputs = [];
	}

	public function removeVirtualPad()
	{
		if (trackedInputsVirtualPad.length > 0)
			controls.removeVirtualControlsInput(trackedInputsVirtualPad);

		if (virtualPad != null)
			remove(virtualPad);
	}

	public function addVirtualPadCamera(DefaultDrawTarget:Bool = true)
	{
		if (virtualPad != null)
		{
			var camControls:FlxCamera = new FlxCamera();
			FlxG.cameras.add(camControls, DefaultDrawTarget);
			camControls.bgColor.alpha = 0;
			virtualPad.cameras = [camControls];
		}
	}
	#end

	override function destroy()
	{
		#if mobile
		if (trackedInputsVirtualPad.length > 0)
			controls.removeVirtualControlsInput(trackedInputsVirtualPad);
		#end

		super.destroy();

		#if mobile
		if (virtualPad != null)
			virtualPad = FlxDestroyUtil.destroy(virtualPad);
		#end
	}

	override function create()
	{
		super.create();
	}

	override function update(elapsed:Float)
	{
		everyStep();

		updateCurStep();
		curBeat = Math.round(curStep / 4);

		super.update(elapsed);
	}

	/**
	 * CHECKS EVERY FRAME
	 */
	private function everyStep():Void
	{
		if (Conductor.songPosition > lastStep + Conductor.stepCrochet - Conductor.safeZoneOffset
			|| Conductor.songPosition < lastStep + Conductor.safeZoneOffset)
		{
			if (Conductor.songPosition > lastStep + Conductor.stepCrochet)
			{
				stepHit();
			}
		}
	}

	private function updateCurStep():Void
	{
		curStep = Math.floor(Conductor.songPosition / Conductor.stepCrochet);
	}

	public function stepHit():Void
	{
		totalSteps += 1;
		lastStep += Conductor.stepCrochet;

		if (totalSteps % 4 == 0)
			beatHit();
	}

	public function beatHit():Void
	{
		lastBeat += Conductor.crochet;
		totalBeats += 1;
	}
}
