package 
{
	import com.bit101.components.Label;
	import com.bit101.components.PushButton;
	import com.dj.media.DJEmbedSound;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author David Lai
	 */
	
	public class Main extends Sprite	{
		
		private var mySp:Sprite;
		private var count:int;
		private var label:Label;
		
		
		
		public function Main() {
			this.init();
		}
		
		private function init():void {
			
			this.mySp = new Sprite();
			this.addChild(this.mySp);
			this.mySp.x = 75;
			this.mySp.y = 75;
			
			//
			// MUSIC
			//
			this.createButton(0, 0, "playMusic1", this.playMusic1);
			this.createButton(0, 50, "playMusic2", this.playMusic2);
			this.createButton(0, 100, "musicOff", this.musicOff);
			this.createButton(0, 150, "musicOn", this.musicOn);
			this.createButton(0, 200, "stopMusic", this.stopMusic);
			
			//
			// EFFECT
			//
			this.createButton(150, 0, "playEffect1", this.playEffect1);
			this.createButton(150, 50, "playEffect2", this.playEffect2);
			this.createButton(150, 100, "effectCompleteFun", this.effectCompleteFun);
			this.label = new Label(this.btnSP, 200, 150, String(count));
			this.createButton(150, 200, "stopEffect", this.stopEffect);
			
			
			//
			// EFFECTS
			//
			this.createButton(300, 0, "playEffects1", this.playEffects1);
			this.createButton(300, 50, "playEffects2", this.playEffects2);
			this.createButton(300, 100, "stopEffects", this.stopEffects);
			
			
			//
			// STOP ALL SOUND
			//
			this.createButton(300, 250, "stopAllSound", this.stopAllSound);
		}
		
		
		private function createButton(x:Number, y:Number, label:String, handler:Function):void {
			var pushBtn:PushButton = new PushButton(this.mySp, x, y, label, handler);
		}
		
		//
		// MUSIC
		//
		//private function playMusic():void {					// ArgumentError: Error #1063: Argument count mismatch on Main/playMusic(). Expected 0, got 1.
		private function playMusic1(e:MouseEvent):void {	
			DJEmbedSound.playMusic(new Music_pop);
		}
		
		private function playMusic2(e:MouseEvent):void {	
			DJEmbedSound.playMusic(new Music_menu);
		}
		
		private function musicOn(e:MouseEvent):void {
			DJEmbedSound.musicOn();
		}
		
		private function musicOff(e:MouseEvent):void {
			DJEmbedSound.musicOff();
		}
		
		private function stopMusic(e:MouseEvent):void {
			DJEmbedSound.stopMusic();
		}
		
		
		//
		// EFFECT
		//
		private function playEffect1(e:MouseEvent):void {
			DJEmbedSound.playEffect(new Effect_boyVoice);
		}
		
		private function playEffect2(e:MouseEvent):void {
			DJEmbedSound.playEffect(new Effect_ding);
		}
		
		private function effectCompleteFun(e:MouseEvent):void {
			DJEmbedSound.playEffect(new Effect_ding);													// PLAY EFFECT
			DJEmbedSound.addEffectCompleteFun( this.onSoundEffectComplete	);				// ADD LISTENER
		}
		
		//
		// get event object
		//
		private function onSoundEffectComplete(e:Event):void {
			//trace(e)
			this.count ++;
			this.label.text = String(this.count);
			DJEmbedSound.removeEffectCompleteFun();
		}
		
		private function stopEffect(e:MouseEvent):void {
			DJEmbedSound.stopEffect();
		}
		
		
		
		
		//
		// EFFECTS
		//
		private function playEffects1(e:MouseEvent):void {
			DJEmbedSound.playEffects(new Effects_bounce);
		}
		
		private function playEffects2(e:MouseEvent):void {
			DJEmbedSound.playEffects(new Effects_chu);
		}
		
		private function stopEffects(e:MouseEvent):void {
			DJEmbedSound.stopEffects();							// It is only can stop the recent Effects.
		}
		
		
		
		
		
		//
		// STOP ALL SOUND
		//
		private function stopAllSound(e:MouseEvent):void {
			DJEmbedSound.stopAllSound();
			DJEmbedSound.mo
		}


	}
	
}