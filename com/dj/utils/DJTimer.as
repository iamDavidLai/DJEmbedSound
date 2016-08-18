package com.dj.utils{

	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	/**
	 * @author 	David Lai & Jost Kuan
	 * @version 	1.1.0
	 * @remark 	one line code, use Timer easily
	 * 
	 * @created 	2012.03
	 * @updated 	2013.06.13
	 * 
	 * 
	 * HOW TO USE:
	 * 	var myTimer:DJTimer = new Timer(myTimerHandler, params, null, null, 1000, 6);
	 * 	
	 * 	function myTimerHandler(params:*):void{
	 * 		//
	 * 		// DO SOMETHING
	 * 		//
	 * 	}
	 */
	
	
	public class DJTimer extends Timer {
		
		private var timerMethod:Function;
		private var timerCompleteMethod:Function;
		private var timerValue:*;
		private var timerCompleteValue:*;
		
		
		
		public function DJTimer(_timerMethod:Function, _timerValue:*, _completeMethod:Function, _timerCompleteValue:*, _delay:Number, _repeatCount:int = 0 ) {
			
			super(_delay, _repeatCount);								//sec,count								//repearCount為0,計時器會無限重複			
			this.timerMethod = _timerMethod;							//timer Function Name
			this.timerCompleteMethod = _completeMethod;			//timerComplete Function Name
			this.timerValue = _timerValue;
			this.timerCompleteValue = _timerCompleteValue;
			
			//trace("startTimer!!!");
			
			if (this.timerMethod == null) 
			{																									// only timerComplete
				this.addEventListener(TimerEvent.TIMER_COMPLETE, completeHandler);
			}
			else if (this.timerCompleteMethod == null) 
			{																									// only timer
				this.addEventListener(TimerEvent.TIMER, timerHandler);
			}
			else 
			{																									// timer & timerComplete
				this.addEventListener(TimerEvent.TIMER, timerHandler);
				this.addEventListener(TimerEvent.TIMER_COMPLETE, completeHandler);
			}
			this.start();
			return;
			
		}
		
		//
		//	HOW TO USE:
		//  myDJTimer.removeDJTimerListener();
		//
		//  IMPORTANT! 	If there isn't use removeDJTimerListener method, it probably cause error.
		//
		/**	手動移除DJTimer事件偵聽 - 2012.09.20	**/
		public function removeDJTimerListener():void{
			if( this.timerMethod != null || this.timerCompleteMethod != null){					//2013.06.13  add remove TIMER_COMPLETE EventListener
				this.stop();
				this.removeEventListener(TimerEvent.TIMER, timerHandler);
				this.removeEventListener(TimerEvent.TIMER_COMPLETE, completeHandler);
				trace("已移除DJTimer的事件偵聽");
			}else{
				throw new Error("喂~你根本沒設TimerEvent的處理函式呀!! ");
			}
		}
			
		private function timerHandler(event:TimerEvent):void{
			if (this.timerValue == null)
			{
				try
				{														
					this.timerMethod();															// When use The Timer that Class has destroyed, it will occur Error, 因為該Class已不存在,沒有對應的函式可執行 
				}
				catch (e:Error)
				{
					trace("DJTimerError: " + e);
				}
			}
			else
			{
				try
				{
					this.timerMethod(this.timerValue);
				}
				catch (e:Error)
				{
					trace("DJTimerValueError: " + e);
				}
			}
			return;
		}

		private function completeHandler(event:TimerEvent):void {										// trace("complete?")
			if (this.timerMethod == null)
			{
				this.removeEventListener(TimerEvent.TIMER_COMPLETE,completeHandler);
			}
			else
			{
				this.removeEventListener(TimerEvent.TIMER,timerHandler);
				this.removeEventListener(TimerEvent.TIMER_COMPLETE,completeHandler);
			}
			this.reset();
			
			if (this.timerCompleteValue == null)
			{
				try
				{
					this.timerCompleteMethod();
				}
				catch (e)
				{
					trace("DJTimerCompleteError: " + e);
				}
			}
			else
			{
				try
				{
					this.timerCompleteMethod(this.timerCompleteValue);
				}
				catch (e)
				{
					trace("DJTimerCompleteValueError: " + e);
					//trace(e.message);
				}
			}
			return;
		}
		
	}
}