package  {
	import flash.events.*;
	import flash.display.Stage;
	import flash.display.MovieClip;
	
	public class Bullet extends MovieClip{
		// global variables go here
		private var angle:Number = 0
		private var moveX:Number = 0
		private var moveY:Number = 0
		
		public function Bullet(startX:Number, startY:Number) {
			//targets player
			angle = Math.atan2(Player.playerY - startY, Player.playerX - startX);
			moveX = Math.cos(angle)*(3+Main.level);
			moveY = Math.sin(angle)*(3+Main.level);
			//program initialization code goes here
			addEventListener(Event.ENTER_FRAME, loop);
		}

		private function loop(e:Event){
			//code that needs to update constantly goes here
			//bullet moves
			this.x = this.x + moveX;
			this.y = this.y + moveY;
			
		}
	}
}








