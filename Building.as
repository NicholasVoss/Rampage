package  {
	import flash.events.*;
	import flash.display.Stage;
	import flash.display.MovieClip;
	import flash.utils.Timer;
	
	public class Building extends Enemy{
		// global variables go here
		static var difficulty:Number = 15 + Main.level;
		var blockType:Number =(Math.floor(Math.random()*(difficulty-1+1))+1);
		var extraLife:Boolean = false;
		var pointBonus:Boolean = false;
		//static var shootTimer:Timer = new Timer (5000);
		public function Building() {
			//program initialization code goes here
			this.stop();
			//selects type of block
			if (blockType >= 15){
				gotoAndStop(5);
			}
			if (blockType == 9){
				extraLife = true;
			}
			if (blockType == 8){
				pointBonus = true;
			}
			addEventListener(Event.ENTER_FRAME, loop);
		}

		private function loop(e:Event){
			//code that needs to update constantly goes here
		}
	}
}