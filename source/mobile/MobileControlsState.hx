package mobile;

import config.ConfigMenu;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.transition.FlxTransitionableState;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxSpriteGroup;
import flixel.input.touch.FlxTouch;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxSave;
import mobile.flixel.FlxButton;
import mobile.flixel.FlxHitbox;
import mobile.flixel.FlxVirtualPad;
import openfl.utils.Assets;
import transition.data.*;

class MobileControlsState extends MusicBeatState
{
	private final controlsItems:Array<String> = ['Pad-Right', 'Pad-Left', 'Pad-Custom', 'Pad-Duo', 'Hitbox', 'Keyboard'];

	private var vpad:FlxVirtualPad;
	private var hitbox:FlxHitbox;
	private var upPosition:FlxText;
	private var downPosition:FlxText;
	private var leftPosition:FlxText;
	private var rightPosition:FlxText;
	private var grpControls:FlxText;
	private var funitext:FlxText;
	private var leftArrow:FlxSprite;
	private var rightArrow:FlxSprite;
	private var curSelected:Int = 0;
	private var buttonBinded:Bool = false;
	private var bindButton:FlxButton;
	private var resetButton:FlxButton;

	override function create()
	{
		for (i in 0...controlsItems.length)
			if (controlsItems[i] == MobileControls.mode)
				curSelected = i;

		var bg:FlxSprite = new FlxSprite(-80).loadGraphic(Paths.image('menuDesat'));
		bg.scrollFactor.x = 0;
		bg.scrollFactor.y = 0;
		bg.setGraphicSize(Std.int(bg.width * 1.18));
		bg.updateHitbox();
		bg.screenCenter();
		bg.antialiasing = true;
		bg.color = 0xFF9766BE;
		add(bg);

		var exitButton:FlxButton = new FlxButton(FlxG.width - 200, 50, 'Exit', function()
		{
			MobileControls.mode = controlsItems[Math.floor(curSelected)];

			if (controlsItems[Math.floor(curSelected)] == 'Pad-Custom')
				MobileControls.customVirtualPad = vpad;

			ConfigMenu.startSong = false;
			switchState(new ConfigMenu());
		});
		exitButton.setGraphicSize(Std.int(exitButton.width) * 3);
		exitButton.label.setFormat(Assets.getFont('assets/mobile/menu/vcr.ttf').fontName, 21, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE,
			FlxColor.BLACK, true);
		exitButton.color = FlxColor.LIME;
		add(exitButton);

		resetButton = new FlxButton(exitButton.x, exitButton.y + 100, 'Reset', function()
		{
			if (controlsItems[Math.floor(curSelected)] == 'Pad-Custom' && resetButton.visible) // being sure about something
			{
				MobileControls.customVirtualPad = new FlxVirtualPad(RIGHT_FULL, NONE);
				reloadMobileControls('Pad-Custom');
			}
		});
		resetButton.setGraphicSize(Std.int(resetButton.width) * 3);
		resetButton.label.setFormat(Assets.getFont('assets/mobile/menu/vcr.ttf').fontName, 21, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE,
			FlxColor.BLACK, true);
		resetButton.color = FlxColor.RED;
		resetButton.visible = false;
		add(resetButton);

		funitext = new FlxText(0, 0, 0, 'No Android Controls!', 32);
		funitext.setFormat(Assets.getFont('assets/mobile/menu/vcr.ttf').fontName, 32, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK,
			true);
		funitext.borderSize = 3;
		funitext.borderQuality = 1;
		funitext.screenCenter();
		funitext.visible = false;
		add(funitext);

		grpControls = new FlxText(0, 100, 0, '', 32);
		grpControls.setFormat(Assets.getFont('assets/mobile/menu/vcr.ttf').fontName, 32, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK,
			true);
		grpControls.borderSize = 3;
		grpControls.borderQuality = 1;
		grpControls.screenCenter(X);
		add(grpControls);

		leftArrow = new FlxSprite(grpControls.x - 60, grpControls.y - 25);
		leftArrow.frames = FlxAtlasFrames.fromSparrow(Assets.getBitmapData('assets/mobile/menu/arrows.png'), Assets.getText('assets/mobile/menu/arrows.xml'));
		leftArrow.animation.addByPrefix('idle', 'arrow left');
		leftArrow.animation.play('idle');
		add(leftArrow);

		rightArrow = new FlxSprite(grpControls.x + grpControls.width + 10, grpControls.y - 25);
		rightArrow.frames = FlxAtlasFrames.fromSparrow(Assets.getBitmapData('assets/mobile/menu/arrows.png'), Assets.getText('assets/mobile/menu/arrows.xml'));
		rightArrow.animation.addByPrefix('idle', 'arrow right');
		rightArrow.animation.play('idle');
		add(rightArrow);

		rightPosition = new FlxText(10, FlxG.height - 24, 0, '', 16);
		rightPosition.setFormat(Assets.getFont('assets/mobile/menu/vcr.ttf').fontName, 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK,
			true);
		rightPosition.borderSize = 3;
		rightPosition.borderQuality = 1;
		add(rightPosition);

		leftPosition = new FlxText(10, FlxG.height - 44, 0, '', 16);
		leftPosition.setFormat(Assets.getFont('assets/mobile/menu/vcr.ttf').fontName, 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK,
			true);
		leftPosition.borderSize = 3;
		leftPosition.borderQuality = 1;
		add(leftPosition);

		downPosition = new FlxText(10, FlxG.height - 64, 0, '', 16);
		downPosition.setFormat(Assets.getFont('assets/mobile/menu/vcr.ttf').fontName, 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK,
			true);
		downPosition.borderSize = 3;
		downPosition.borderQuality = 1;
		add(downPosition);

		upPosition = new FlxText(10, FlxG.height - 84, 0, '', 16);
		upPosition.setFormat(Assets.getFont('assets/mobile/menu/vcr.ttf').fontName, 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK,
			true);
		upPosition.borderSize = 3;
		upPosition.borderQuality = 1;
		add(upPosition);

		changeSelection();

		customTransIn = new WeirdBounceIn(0.6);
		customTransOut = new WeirdBounceOut(0.6);

		super.create();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		for (touch in FlxG.touches.list)
		{
			if (touch.overlaps(leftArrow) && touch.justPressed)
				changeSelection(-1);
			else if (touch.overlaps(rightArrow) && touch.justPressed)
				changeSelection(1);

			if (controlsItems[Math.floor(curSelected)] == 'Pad-Custom')
			{
				if (buttonBinded)
				{
					if (touch.justReleased)
					{
						bindButton = null;
						buttonBinded = false;
					}
					else
						moveButton(touch, bindButton);
				}
				else
				{
					if (vpad.buttonUp.justPressed)
						moveButton(touch, vpad.buttonUp);
					else if (vpad.buttonDown.justPressed)
						moveButton(touch, vpad.buttonDown);
					else if (vpad.buttonRight.justPressed)
						moveButton(touch, vpad.buttonRight);
					else if (vpad.buttonLeft.justPressed)
						moveButton(touch, vpad.buttonLeft);
				}
			}
		}

		if (vpad != null && controlsItems[Math.floor(curSelected)] == 'Pad-Custom')
		{
			if (vpad.buttonUp != null)
				upPosition.text = 'Button Up X:' + vpad.buttonUp.x + ' Y:' + vpad.buttonUp.y;

			if (vpad.buttonDown != null)
				downPosition.text = 'Button Down X:' + vpad.buttonDown.x + ' Y:' + vpad.buttonDown.y;

			if (vpad.buttonLeft != null)
				leftPosition.text = 'Button Left X:' + vpad.buttonLeft.x + ' Y:' + vpad.buttonLeft.y;

			if (vpad.buttonRight != null)
				rightPosition.text = 'Button Right X:' + vpad.buttonRight.x + ' Y:' + vpad.buttonRight.y;
		}
	}

	private function changeSelection(change:Int = 0):Void
	{
		curSelected += change;

		if (curSelected < 0)
			curSelected = controlsItems.length - 1;
		else if (curSelected >= controlsItems.length)
			curSelected = 0;

		grpControls.text = controlsItems[Math.floor(curSelected)];
		grpControls.screenCenter(X);

		leftArrow.x = grpControls.x - 60;
		rightArrow.x = grpControls.x + grpControls.width + 10;

		var daChoice:String = controlsItems[Math.floor(curSelected)];

		reloadMobileControls(daChoice);

		funitext.visible = daChoice == 'Keyboard';
		resetButton.visible = daChoice == 'Pad-Custom';
		upPosition.visible = daChoice == 'Pad-Custom';
		downPosition.visible = daChoice == 'Pad-Custom';
		leftPosition.visible = daChoice == 'Pad-Custom';
		rightPosition.visible = daChoice == 'Pad-Custom';
	}

	private function moveButton(touch:FlxTouch, button:FlxButton):Void
	{
		bindButton = button;
		bindButton.x = touch.x - Std.int(bindButton.width / 2);
		bindButton.y = touch.y - Std.int(bindButton.height / 2);

		if (!buttonBinded)
			buttonBinded = true;
	}

	private function reloadMobileControls(daChoice:String):Void
	{
		switch (daChoice)
		{
			case 'Pad-Right':
				removeControls();
				vpad = new FlxVirtualPad(RIGHT_FULL, NONE);
				add(vpad);
			case 'Pad-Left':
				removeControls();
				vpad = new FlxVirtualPad(LEFT_FULL, NONE);
				add(vpad);
			case 'Pad-Custom':
				removeControls();
				vpad = MobileControls.customVirtualPad;
				add(vpad);
			case 'Pad-Duo':
				removeControls();
				vpad = new FlxVirtualPad(BOTH_FULL, NONE);
				add(vpad);
			case 'Hitbox':
				removeControls();
				hitbox = new FlxHitbox();
				add(hitbox);
			default:
				removeControls();
		}

		if (vpad != null)
			vpad.visible = (daChoice != 'Hitbox' && daChoice != 'Keyboard');

		if (hitbox != null)
			hitbox.visible = (daChoice == 'Hitbox');
	}

	private function removeControls():Void
	{
		if (vpad != null)
			remove(vpad);

		if (hitbox != null)
			remove(hitbox);
	}
}
