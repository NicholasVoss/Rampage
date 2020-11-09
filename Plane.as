package  {
	import flash.events.*;
	import flash.display.Stage;
	import flash.display.MovieClip;
	
	public class Plane extends Enemy{
		// global variables go here
		private var speed = 5;
		public function Plane() {
			//program initialization code goes here
			addEventListener(Event.ENTER_FRAME, loop);
		}

		private function loop(e:Event){
			//code that needs to update constantly goes here
			this.x = this.x + speed;
			if (this.x >= 500 || this.x <= 50){
				speed = -speed;
				this.scaleX = -this.scaleX;			
				}
		}
	}
}








