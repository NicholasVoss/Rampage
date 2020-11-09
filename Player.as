package  {
	import flash.events.*;
	import flash.display.Stage;
	import flash.display.MovieClip;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import flash.events.Event;
	
	public class Player extends MovieClip{
		// global variables go here
		private var up:Boolean = false;
		private var right:Boolean = false;
		private var left:Boolean = false;
		private var down:Boolean = false;
		private var space:Boolean = false;
		private var climb:Boolean = false;
		private var hit:Boolean = false;
		static var playerX:Number;
		static var playerY:Number;
		public function Player() {
			//program initialization code goes here
			addEventListener(Event.ENTER_FRAME, loop);
			addEventListener(Event.ADDED_TO_STAGE, addedToStage);
			this.stop();
		}
		private function addedToStage(e:Event){
			stage.addEventListener(KeyboardEvent.KEY_DOWN, pressKey);
			stage.addEventListener(KeyboardEvent.KEY_UP, releaseKey);
		}
		//detects key presses
		private function pressKey(event:KeyboardEvent):void{
			switch(event.keyCode)
			{
				case Keyboard.LEFT:
					left = true;
					break;
					
				case Keyboard.RIGHT:
					right = true;
					break;
					
				case Keyboard.UP:
					up = true;
					break;
					
				case Keyboard.DOWN:
					down = true;
					break;
					
				case Keyboard.SPACE:
					space = true;
					break;
		}
		}
		//detects when keys are released
		private function releaseKey(event:KeyboardEvent){
			switch(event.keyCode)
			{
				case Keyboard.LEFT:
					left = false;
					break;
					
				case Keyboard.RIGHT:
					right = false;
					break;
					
				case Keyboard.UP:
					up = false;
					break;
					
				case Keyboard.DOWN:
					down = false;
					break;
					
				case Keyboard.SPACE:
					space = false;
					hit = false;
					break;
		}
		}
		private function loop(e:Event){
			//code that needs to update constantly goes here
			playerX = this.x;
			playerY = this.y;
			//lets player turn around
			if (right == true && this.x <= 520 && space == false){
				this.x=this.x+5;
				if (this.scaleX == -1){
					this.scaleX = 1;
				}
			}
			if (left == true && this.x >= 30 && space == false){
				this.x=this.x-5;
				if (this.scaleX == 1){
					this.scaleX = -1;
				}
			}
			//starts climbing animation
			if (this.y <= 320 && this.y >= 55 && currentFrame <= 12 || currentFrame >= 18){
				gotoAndStop(13);
			}
			else if (this.y <= 320 && this.y>= 55 && currentFrame >= 13 && currentFrame <= 18 && left == true || right == true || up == true || down == true){
				gotoAndStop(currentFrame+1);
			}
			//starts walking animation
			else if (this.y >= 320 && currentFrame >= 12 ){
				gotoAndStop(0);
			}
			else if (this.y >= 320 && currentFrame <= 12 && left == true || right == true){
				gotoAndStop(currentFrame+1);
			}
			//starts walking animation on top of building
			if (right == true || left == true){
				if (this.currentFrame <= 11 && this.y >= 315 || this.currentFrame <= 11 && this.y <= 75){
				gotoAndStop(this.currentFrame + 1);
				}
				else if (this.currentFrame >=11 && this.y >= 315 || this.currentFrame >=11 && this.y <= 0){
					gotoAndStop(0);
				}	
			}
			//climb down
			if (down == true){
				if (this.y <= 325){
					for each(var building:Building in Main.buildings){
						if (this.hitTestObject(building)==true && space==false){
							climb = true;
						}
					}
					if (climb == true){
					climb = false;
					this.y = this.y +3;
					}
				}
			}
			//climb up
			if (up == true){
				for each(building in Main.buildings){
					if (this.hitTestObject(building)==true && this.y >= 0 && space==false){
						climb = true
					}
				}
				if (climb == true && this.x >= 125 && this.x <= 420){
					climb = false;
					this.y = this.y -3;
				}
			}
			//makes player fall after climbing off the side of the building
			if (this.y <= 325 && this.x <= 125 || this.y <= 325 && this.x >= 425 || Main.fall == true && this.y <= 325){
						this.y = this.y +10;
			}
			//player punches
			if (space == true){
				gotoAndStop(20);
				for each(building in Main.buildings){
					if (this.arm.hitTestObject(building)==true && hit == false && building.currentFrame <= 2){
						if (building.extraLife == false && building.pointBonus == false 
							|| building.extraLife == true && building.currentFrame < 2 
							|| building.pointBonus == true && building.currentFrame < 2){
							
							if (building.currentFrame <2){
								Main.score = Main.score +100;
							}
							else if (building.currentFrame == 2){
								Main.score = Main.score +400;
							}
							
							building.gotoAndStop(building.currentFrame+1);
							hit = true;
						}
						if (building.extraLife == true && building.currentFrame == 2 && hit == false){
							Main.score = Main.score +400;
							building.gotoAndStop(4);
							hit = true;
						}
						if (building.pointBonus == true && building.currentFrame == 2 && hit == false){
							Main.score = Main.score +400;
							building.gotoAndStop(7);
							hit = true;
						}
						
					}
					if (this.arm.hitTestObject(building)==true && hit == false && building.currentFrame == 5){
						Main.score = Main.score + 200;
						building.gotoAndStop(2);
						hit = true;
					}
					if (this.arm.hitTestObject(building)==true && hit == false && building.currentFrame == 4){
						Main.score = Main.score +400;
						Main.lives = Main.lives+1;
						building.gotoAndStop(3);
						hit = true;
					}
					if (this.arm.hitTestObject(building)==true && hit == false && building.currentFrame == 7){
						Main.score = Main.score +1000;
						building.gotoAndStop(3);
						hit = true;
					}
				}
			}
		}
	}
}