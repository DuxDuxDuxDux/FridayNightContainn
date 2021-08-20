package;

import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.utils.Assets;


#if windows
import Discord.DiscordClient;
#end

using StringTools;

class CreditState extends MusicBeatState
{

	var scoreText:FlxText;
	var diffText:FlxText;
	var lerpScore:Int = 0;
	var intendedScore:Int = 0;

	private var grpSongs:FlxTypedGroup<Alphabet>;
	private var curPlaying:Bool = false;

	private var iconArray:Array<CreditIcon> = [];
	private var grpLabels:FlxTypedGroup<Alphabet>;

	var thePeople:Array<String> = [
		'etrodis',
        'stuckmarkz',
        'ax901',
        'magmablood',
        'dux',
        'hosytaa',
        'critva',
        'kh',
        'worldendwonder',
        'p.r'
	];
	var theLabels:Array<String> = [
		'the creator guy',
        'cool artist',
        'one of the epic musicians',
        'another music man',
        'coder person man',
        'another coder, but charter',
        'voice acterer',
        'road to 700 artists',
        'another art man',
        'last artist for now'
	];
	var theLinks:Array<String> = [
		''
	];
	override function create()
	{
		 #if windows
		 // Updating Discord Rich Presence
		 DiscordClient.changePresence("In the Credits Menu", null);
		 #end

		var isDebug:Bool = false;

		#if debug
		isDebug = true;
		#end
		FlxG.mouse.visible = true;
		
		var bgthingy:String = 'menu/menuBGBlue';
		var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image(bgthingy));
		add(bg);

		grpSongs = new FlxTypedGroup<Alphabet>();
		add(grpSongs);
		/*grpLabels = new FlxTypedGroup<Alphabet>();
		add(grpLabels);*/
		for (i in 0...thePeople.length)
		{
			var theText = thePeople[i];
			var songText:Alphabet = new Alphabet(0, (150 * i) + 100, theText, true, false, true);
			songText.x += 300;
			grpSongs.add(songText);

			var elBallso:Alphabet = new Alphabet(-20, (150 * i) + 40, theLabels[i], true, false, true);
			elBallso.x += 310;
			elBallso.scale.set(0.5, 0.5);
			grpSongs.add(elBallso);

			var icon:CreditIcon = new CreditIcon(i, theLinks[i]);
			icon.elSprite = songText;

			// using a FlxGroup is too much fuss!
			iconArray.push(icon);
			add(icon);
		}

		super.create();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (controls.BACK)
		{
			FlxG.switchState(new MainMenuState());
		}

		if (FlxG.mouse.wheel < 0) {
			if (grpSongs.members[grpSongs.length - 1].y > 600) {
				for (i in grpSongs) {
					i.y += FlxG.mouse.wheel * 30;
				}
			}
		}
		if (FlxG.mouse.wheel > 0) {
			if (grpSongs.members[0].y < 100) {
				for (i in grpSongs) {
					i.y += FlxG.mouse.wheel * 30;
				}
			}
		}
		for (i in iconArray) {
			if (FlxG.mouse.overlaps(i)) {
				i.scale.set(1, 1);
				if (FlxG.mouse.justPressed) {
					#if linux
					Sys.command('/usr/bin/xdg-open', [i.link, "&"]);
					#else
					FlxG.openURL(i.link);
					#end
				}
			} else {
				i.scale.set(0.9, 0.9);
			}
		}
	}
}

class CreditIcon extends FlxSprite
{
	public var link:String;
	public var elSprite:FlxSprite;
	public function new(num:Int, link:String)
	{
		this.link = link;
		super();
		loadGraphic(Paths.image('shitassCedits'), true, 150, 150);

		antialiasing = true;
		animation.add('balls', [num], 0, false);

		scrollFactor.set();
		animation.play('balls');
	}
	override function update(balls:Float) {
		if (elSprite != null) {
			x = elSprite.x - 200;
			y = elSprite.y - 75;
		}
		super.update(balls);
	}
	
}