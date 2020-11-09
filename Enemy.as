package  {
	import flash.events.*;
	import flash.display.Stage;
	import flash.display.MovieClip;
	import flash.utils.Timer;
	
	public class Enemy extends MovieClip{
		// global variables go here
		static var shootTimer:Timer = new Timer(5000);
		public function Enemy() {
			//program initialization code goes here
			addEventListener(Event.ENTER_FRAME, loop);
			shootTimer.addEventListener(TimerEvent.TIMER, attackTimerRun);
			shootTimer.start();
		}
		//enemy shoots
		private function attackTimerRun(e:Event){
			if(this is Building && this.currentFrame == 5 && Main.endScreen.visible == false 
			   || this is Plane && Main.endScreen.visible == false){
			trace("shoot");
			var bullet:Bullet = new Bullet(this.x,this.y);
			bullet.x = this.x;
			bullet.y = this.y;
			stage.addChild(bullet);
			Main.bullets.push(bullet);
			shootTimer.start();
			}
		}
		private function loop(e:Event){
			//code that needs to update constantly goes here
		}
	}
}








