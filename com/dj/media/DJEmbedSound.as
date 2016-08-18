package com.dj.media
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.media.ID3Info;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundMixer;
	import flash.media.SoundTransform;
	
	import com.dj.utils.DJTimer;
	import caurina.transitions.Tweener;
	import caurina.transitions.properties.SoundShortcuts;
	
	/**
	 * @author 	David Lai & Jost Kuan
	 * @version 	1.3.0
	 * @remark 	(TC) 播放Flash IDE Library 內嵌聲音, 必須要先將聲音檔賦予類別名稱
	 * @remark 	(EN) Using the Sound with library in Animate (Flash). 
	 * 
	 * @created	2014/05/16
	 * @updated 	2016/08/16
	 * 
	 * Definition
	 * Music	   - BGM, endless loop, there is only one BGM at the same time.
	 * Effect   - Voice(Human) or Sound of effects, play time is short, only one sound at the same time.
	 * Effects  - Sound of effects often. It alows many sound object(fleeting) playing at the same time. No loop.
	 * 
	 * 
	 * HOW TO USE :
	 * DJEmbedSound.playMusic(new SoundObj);
	 * DJEmbedSound.playEffect(new SoundObj, 1500, 3);
	 * 
	 * 
	 * ◎ 新增musicOn()、musicOff() (是靜音而非關閉)。 必須在背景音已播放的前提下，才可以使用。
	 * 	先使用musicOn()不會有作用，因音量volume 早就是1.0；正常情況下若要先淡入背景音，就必須 playMusic(), musinOff(), musicOn() 這樣的順序來執行。
	 * 
	 * ◎ stopEffect()  if has EventListener, remove listener.		2016/08/16
	 * 
	 * 
	 * 若要使用內嵌聲音，必須在 ActionScript 中參考該聲音的類別名稱。
	 * 例如，下列程式碼一開始會建立自動產生之 DrumSound 類別的新實體：
	 * var drum:DrumSound = new DrumSound(); 
	 * var channel:SoundChannel = drum.play();
	 */
	 
	 
	public class DJEmbedSound extends EventDispatcher 	{
		
		public static const EFFECT_COMPLETE:String = "effectComplete";				// EventType: add listener Effect complete
		private static var _dispatcher:EventDispatcher;
		
		private static var musicSound:Sound;
		private static var musicChannel:SoundChannel;
		
		private static var effectSound:Sound;
		private static var effectChannel:SoundChannel;
		
		private static var effectsSound:Sound;
		private static var effectsChannel:SoundChannel;
		
		private static var effectEvtFun:Function;					// 
		
		
		
		public function DJEmbedSound() {		}		
		
		//
		// Music - BGM, endless loop, there is only one BGM at the same time.
		//
		/* 比較長的背景音樂(無限循環)。如果背景音樂要用到delay，播第二首時會先停止第一首，經過delay時間後才會開始播放。 */
		public static function playMusic(_snd:Sound, _delay:Number = 0):void {
		/**	//trace(DJEmbedSound.musicSound);					// null
			//trace(_snd);														// [object Music_menu]			
			//trace(_snd.length);											// 32105.03401360544				
			//trace(_snd.id3);												// [object ID3Info]
			//trace(_snd.url);													// null
			//trace("==========================");
			//var id3:ID3Info = _snd.id3
			//trace(id3.album);				//trace(id3.artist);
			//trace(id3.comment);			//trace(id3.genre);
			//trace(id3.songName);			//trace(id3.track);
			//trace(id3.year);				// 以上ID3Info有可能全部都是null 		**/
			
			if (DJEmbedSound.musicSound == null) {
				DJEmbedSound.musicSound = _snd;																						// trace("第1次傳入");
			}else {
				//trace("==============================");																	// trace("第2次之後傳入");
				// trace("SND.length: " + DJEmbedSound.musicSound.length);														// trace("_snd.length: " + _snd.length);
				if (DJEmbedSound.musicSound.length == _snd.length) {															// ★要用一定會存在的Sound物件與傳入參數的Sound物件比對
					//trace("相同的聲音物件，不須重複、從頭播放");		
					return;
				}
				DJEmbedSound.stopMusic();																									// 播放不同的聲音，原本的要先停掉再重新指定
				DJEmbedSound.musicSound = _snd;
			}
			
			// 設定delay，在上方需先判斷是否為同一物件(若是則沒有執行delay的必要)，再看是否要執行delay函式。 
			if (_delay != 0) {																													// trace("DELAY: " + _delay);
				new DJTimer(null, null, onMusicDelay, _snd, _delay, 1 );
			}else {
				DJEmbedSound.musicChannel = DJEmbedSound.musicSound.play(0, 999999999);								//trace(DJEmbedSound.musicSound);
			}
			// Sound.play() 方法會產生新的 SoundChannel 物件，以便播放聲音。
			// 這個方法會傳回 SoundChannel 物件，您可以存取此物件，以停止聲音並監視音量。
			// 若要控制音量、左右相位和平衡，請存取指定給聲道的 SoundTransform 物件。
			// 若要控制聲音播放&暫停，須先將Sound物件指定給SoundChannel物件，才能使用聲道的 stop() 方法暫停聲音，因Sound物件沒有stop()方法。	
			
		}
		
		private static function onMusicDelay(_snd:Sound):void {
			DJEmbedSound.musicSound = _snd;
			DJEmbedSound.musicChannel = DJEmbedSound.musicSound.play(0, 999999999);
		}
		
		//
		// BGM - Fade in
		//
		public static function musicOn(_time:Number = 3.0, _volume:Number = 1.0):void {
			SoundShortcuts.init();
			Tweener.addTween(DJEmbedSound.musicChannel, {time:_time, _sound_volume:_volume});
		}
		
		//
		// BGM - Fade out
		//		
		public static function musicOff(_time:Number = 3.0, _volume:Number = 0.0):void {
			SoundShortcuts.init();
			Tweener.addTween(DJEmbedSound.musicChannel, {time:_time, _sound_volume:_volume});
		}
		
		//
		// STOP BGM
		//
		public static function stopMusic(_isFadeOut:Boolean = false):void {
			if (DJEmbedSound.musicChannel != null) {
				DJEmbedSound.musicChannel.stop();
				DJEmbedSound.musicChannel = null;
				DJEmbedSound.musicSound = null;												// 播放A, 避免停止A後, 若再次播放A, 會陷入不播放的情形
			}
		}
		
		
		
		
		
		//
		// Effect - Voice(Human) or Sound of effects, play time is short, only one sound at the same time.
		//				
		/*	同時間只會有一種音效的Effect, 開放loops參數 (ex:說話聲音) 。 
		 * 	音效Effect & Effects 沒有判斷重複播放的需求。 理由1: 不論是人聲或效果音通常都只會有播放一次的情形。  理由2: 通常播放音效的時間不長，很快就結束。
		 * 	要留意，如果在某段時間(ex:_delay:2000)，在此時間內連續執行一個有延遲另一則無的Effect，會導致聲音重疊 (Music與Effect都一樣)		 * */
		public static function playEffect(_snd:Sound, _delay:Number = 0, _loops:int = 0):void {
			if (DJEmbedSound.effectSound == null) {
				DJEmbedSound.effectSound = _snd;
			}else {																					 				
				//if (DJEmbedSound.effectSound.length == _snd.length) {
					//return;(X)	//Different than BGM, Effect usually plays many times 
					// 這裡若比照Music，會導致無法再次播放相同的聲音物件。 因為Music是只執行一次無限播放，但Effect則是播放1~n次。
				//}
				//	trace("先stop再play");
				DJEmbedSound.stopEffect();
				DJEmbedSound.effectSound = _snd;
			}
			
			if (_delay != 0) {																							// 將Sound物件與loop次數塞入Object
				var obj:Object = { snd:_snd, loops:_loops };													// trace(obj.snd, obj.loops)								
				new DJTimer(null, null, onEffectDelay, obj, _delay, 1);										// trace("delayValue: " + _delay);
			}else {																											// trace("play Effect");
				DJEmbedSound.effectChannel = DJEmbedSound.effectSound.play(0, _loops);
				DJEmbedSound.effectChannel.addEventListener(Event.SOUND_COMPLETE, onEffectComplete);
			}
		}
		
		private static function onEffectDelay(_obj:Object):void {
			//trace("播放Effect Delay");							//trace("delay: " + _obj.snd, _obj.loops);				//trace(DJEmbedSound.effectSound.length);				//trace(_obj.snd.length);
			DJEmbedSound.effectSound = _obj.snd;
			DJEmbedSound.effectChannel = DJEmbedSound.effectSound.play(0, _obj.loops);
			DJEmbedSound.effectChannel.addEventListener(Event.SOUND_COMPLETE, onEffectComplete);
		}
		
		public static function get dispatcher():EventDispatcher {
			DJEmbedSound._dispatcher = (DJEmbedSound._dispatcher == null)?	new EventDispatcher:	DJEmbedSound._dispatcher;
			return DJEmbedSound._dispatcher;
		}
		
		private static function onEffectComplete(e:Event):void {
			//trace("dispatch DJEmbedSound.EFFECT_COMPLETE");
			DJEmbedSound.effectChannel.removeEventListener(Event.SOUND_COMPLETE, onEffectComplete);
			DJEmbedSound.dispatcher.dispatchEvent(new Event(DJEmbedSound.EFFECT_COMPLETE));
			//new DJEmbedSound().						
			// 按下「.」後就會知道，還是得要將其實體化才能取用其屬性or方法，只有這樣才能使用dispatchEvent方法(或是透過EventDispatcher的實體)
		}
		
		//
		// 加入-偵聽EFFECT_COMPLETE處理函式
		//
		public static function addEffectCompleteFun(_method:Function):void {
			DJEmbedSound.effectEvtFun = _method;
			DJEmbedSound.dispatcher.addEventListener(DJEmbedSound.EFFECT_COMPLETE, DJEmbedSound.effectEvtFun);
		}
		
		//
		// 移除-偵聽EFFECT_COMPLETE處理函式
		//
		public static function removeEffectCompleteFun():void {	
			try {
				DJEmbedSound.dispatcher.removeEventListener(DJEmbedSound.EFFECT_COMPLETE, DJEmbedSound.effectEvtFun);
			}catch (e:Error) {
				throw new Error("移除偵聽的參數不能為null, try catch拋出: " + e);
			}
			DJEmbedSound.effectEvtFun = null;
		}
		
		public static function stopEffect():void {
			if (DJEmbedSound.effectChannel != null) {
				DJEmbedSound.effectChannel.stop();
				DJEmbedSound.effectChannel = null;								// Effect & Effects 不一定要像Music一樣將Sound = null, 視情況觀察
				
				if (DJEmbedSound.dispatcher.hasEventListener(DJEmbedSound.EFFECT_COMPLETE)) {
					DJEmbedSound.removeEffectCompleteFun();
				}
				
			}	
		}
		
		
		
		
		
		//
		// Effects - Sound of effects often. It alows many sound object(fleeting) playing at the same time. No loop.
		//
		/*	同時間允許多種音效的Effects(稍縱即逝), Effects 沒有設定loops, 多種音效混雜還要loop未免是個災難  */
		public static function playEffects(_snd:Sound, _delay:Number = 0):void {
			if (_delay != 0) {
				new DJTimer(null, null, onEffectsDelay, _snd, _delay, 1);
			}else {
				DJEmbedSound.effectsSound = _snd;
				DJEmbedSound.effectsChannel = DJEmbedSound.effectsSound.play();
			}
		}
		
		private static function onEffectsDelay(_snd:Sound):void {
			DJEmbedSound.effectsSound = _snd;
			DJEmbedSound.effectsChannel = DJEmbedSound.effectsSound.play();
		}
		
		/**	只能停止最近一個播放的Effects, 因為DJEmbedSound.effectsChannel:SoundChannel 已被最近一個Effects取代	**/
		public static function stopEffects():void {
			if (DJEmbedSound.effectsChannel != null) {
				DJEmbedSound.effectsChannel.stop();
				DJEmbedSound.effectsChannel = null;
			}	
		}
		
		
		
		
		
		public static function stopAllSound():void {
			SoundMixer.stopAll();
			DJEmbedSound.musicSound = null;			// 清空, 否則若再度播放之前的背景音樂, 會被認定已經傳入musicSound而無法順利執行
		}
		
		
	}
}