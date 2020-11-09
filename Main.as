package  {
	import flash.events.*;
	import flash.display.Stage;
	import flash.display.MovieClip;
	import flash.utils.Timer;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.FileReference;
	
	public class Main extends MovieClip{
		// global variables go here
		private var urlLoader:URLLoader = new URLLoader();
		private var xml:XML = new XML();
		private var xmlFile:FileReference = new FileReference();
		private var player:Player = new Player();
		private var plane:Plane = new Plane();
		private var backGround:Background = new Background();
		private var startScreen:StartScreen = new StartScreen();
		private var helpScreen:HelpScreen = new HelpScreen();
		static var endScreen:EndScreen = new EndScreen();
		private var highScoreScreen:HighScoreScreen = new HighScoreScreen();
		private var nextButton:NextButton = new NextButton();
		static var buildingNumber:Number;
		private var ui:hud = new hud();
		private var newRecord:Number;
		static var lives:Number = 3;
		static var score:Number = 0;
		private var highestScore1:Number = 0;
		private var highestScore2:Number = 0;
		private var highestScore3:Number = 0;
		private var highScoreName1:String;
		private var highScoreName2:String;
		private var highScoreName3:String;
		static var Time:Number = 60;
		static var level:Number = 1;
		static var fall:Boolean = false;
		private var fallen:Boolean;
		private var gameTimer:Timer = new Timer (1000);
		private var buildingTimer:Timer = new Timer (200);
		private var ourArray:Array = new Array([0,1,2,3,4,5],
												[0,1,2,3,4,5],
												[0,1,2,3,4,5],
												[0,1,2,3,4,5],
												[0,1,2,3,4,5],
												[0,1,2,3,4,5]);
		static var buildings:Array = new Array();
		static var players:Array = new Array();
		static var bullets:Array = new Array();
		public function Main() {
			//program initialization code goes here
			stage.addChild(plane);
			plane.x = 100;
			stage.addChild(player);
			player.y = 325;
			player.x = 25;
			players.push(player);
			stage.addChildAt(backGround,0);
			stage.addChild(ui);
			stage.addChild(startScreen);
			stage.addChild(helpScreen);
			helpScreen.visible = false;
			stage.addChild(endScreen);
			stage.addChild(highScoreScreen);
			highScoreScreen.visible = false;
			highScoreScreen.nameInput.multiline = false;
			highScoreScreen.nameInput.restrict = "A-Z a-z";
			addChild(nextButton);
			nextButton.x = 175;
			nextButton.y = 100;
			endScreen.visible = false;
			stage.addEventListener(Event.ENTER_FRAME, loop);
			endScreen.restartButton.addEventListener(MouseEvent.MOUSE_DOWN, startGame);
			endScreen.saveButton.addEventListener(MouseEvent.MOUSE_DOWN, saveGame);
			startScreen.startButton.addEventListener(MouseEvent.MOUSE_DOWN, startGame);
			startScreen.helpButton.addEventListener(MouseEvent.MOUSE_DOWN, showHelp);
			helpScreen.back.addEventListener(MouseEvent.MOUSE_DOWN, goBack);
			nextButton.addEventListener(MouseEvent.MOUSE_DOWN, nextLevel);
			highScoreScreen.submitNameButton.addEventListener(MouseEvent.MOUSE_DOWN, submitName);
			gameTimer.addEventListener(TimerEvent.TIMER, gameTimerRun);
			buildingTimer.addEventListener(TimerEvent.TIMER, buildingTimerRun);
			urlLoader.addEventListener(Event.COMPLETE,XMLLoaded);
			urlLoader.load(new URLRequest("leaderboard.xml"));
			
		}
		//loads data from XML
		private function XMLLoaded(e:Event){
			xml = XML(e.target.data);
			highestScore1 = xml.HIGHSCORE[0];
			highestScore2 = xml.HIGHSCORE[1];
			highestScore3 = xml.HIGHSCORE[2];
			highScoreName1 = xml.NAME[0];
			highScoreName2 = xml.NAME[1];
			highScoreName3 = xml.NAME[2];
			
		}
		//saves data to XML
		private function saveGame(e:Event){
			xml.HIGHSCORE[0] = highestScore1
			xml.HIGHSCORE[1] = highestScore2
			xml.HIGHSCORE[2] = highestScore3
			xml.NAME[0] = highScoreName1;
			xml.NAME[1] = highScoreName2;
			xml.NAME[2] = highScoreName3;
			xmlFile.save(xml, "leaderboard.xml");
			}
		private function submitName(e:Event){
			if(newRecord == 1){
					highScoreName1 = String(highScoreScreen.nameInput.text);
			}
			else if (newRecord == 2){
					highScoreName2 = String(highScoreScreen.nameInput.text);
			}
			else if (newRecord == 3){
					highScoreName3 = String(highScoreScreen.nameInput.text);
			}
			endScreen.name1.text = String(highScoreName1);
			endScreen.name2.text = String(highScoreName2);
			endScreen.name3.text = String(highScoreName3);
			highScoreScreen.visible = false;
			newRecord = 0;
		}
		//makes building fall
		private function buildingTimerRun (e:Event){
			if(score >= 15000*level && buildings.length >= 1){
				fall = true;
				for (var i:int = 0; i<6; i++){
					removeChild(buildings[0]);
					buildings.splice(0,1);
				}
				if(buildings.length == 0){
				fallen = true;
				}
			}
			buildingTimer.start();
		}
		//makes game timer count down
		private function gameTimerRun (e:Event){
			Time = Time -1;
			gameTimer.start();
			if (Time == 0){
				endGame();
			}
		}
		//sets up the game
		private function startGame (e:Event){
			startScreen.visible = false;
			endScreen.visible = false;
			lives = 3;
			Time = 60;
			score = 0;
			level = 1;
			player.y = 325;
			player.x = 25;			
			for (var row:int = 0; row<ourArray.length; row++){
				for (var col:int = 0; col<ourArray[row].length; col++){
					buildingNumber = ourArray[row][col];
					var building:Building = new Building();
					buildings.push(building);
					addChildAt(building,0);
					building.x = 125+50*col;
					building.y = 50+50*row;
					
				}
			}
			gameTimer.start();
			buildingTimer.start();
			nextButton.visible=false;
		}
		//ends the game after losing
		public function endGame(){
			if(score > highestScore1){
				highScoreScreen.visible = true;
				highScoreName3 = highScoreName2;
				highScoreName2 = highScoreName1;
				highestScore3 = highestScore2;
				highestScore2 = highestScore1;
				highestScore1 = score;
				newRecord = 1;
			}
			else if (score > highestScore2 && score < highestScore1){
				highScoreScreen.visible = true;
				highScoreName3 = highScoreName2;
				highestScore3 = highestScore2;
				highestScore2 = score;
				newRecord = 2;
			}
			else if (score > highestScore3 && score < highestScore2){
				highScoreScreen.visible = true;
				highestScore3 = score;
				newRecord = 3
			}
				highScoreScreen.finalScore.text = String(score);
				endScreen.finalScore.text = String(score);
				endScreen.highScore1.text = String(highestScore1);
				endScreen.highScore2.text = String(highestScore2);
				endScreen.highScore3.text = String(highestScore3);
				endScreen.name1.text = String(highScoreName1);
				endScreen.name2.text = String(highScoreName2);
				endScreen.name3.text = String(highScoreName3);
				
				endScreen.visible = true;
				for each(var bullet:Bullet in bullets){
					bullet.parent.removeChild(bullet);
				}
				for each(var building:Building in buildings){
					removeChild(building);
				}
				Enemy.shootTimer.stop();
				bullets.length = 0;
				buildings.length = 0;
		}
		//brings the player to the next level
		private function nextLevel(e:Event){
			if (fallen == true){
				player.y = 325;
				player.x = 25;
				Building.difficulty = Building.difficulty + 1;
				for (var row:int = 0; row<ourArray.length; row++){
					for (var col:int = 0; col<ourArray[row].length; col++){
						buildingNumber = ourArray[row][col];
						var building:Building = new Building();
						buildings.push(building);
						this.addChildAt(building,0);
						building.x = 125+50*col;
						building.y = 50+50*row;
					}
				}
				score = score + Time*100;
				Time = 60;
				gameTimer.start();
				buildingTimer.start();
				level = level+1;
				nextButton.visible = false;
				fall = false;
				fallen = false;
			}
		}
		//shows the help screen
		private function showHelp (e:Event){
			helpScreen.visible = true;
		}
		//closes the help screen
		private function goBack (e:Event){
			helpScreen.visible = false;
		}
		private function loop(e:Event){
			//code that needs to update constantly goes here
			ui.scoreText.text = String(score);
			ui.timeText.text = String(Time);
			if (lives > 3){
				ui.life1.x = -88;
				ui.life2.visible = false;
				ui.life3.visible = false;
				ui.lifeCount.visible = true;
				ui.lifeCount.text = String("x " + lives)
			}
			if (lives == 3){
				ui.life1.x = -100;
				ui.life1.visible = true;
				ui.life2.visible = true;
				ui.life3.visible = true;
				ui.lifeCount.visible = false;
			}
			if (lives == 2){
				ui.life1.x = -100;
				ui.life1.visible = true;
				ui.life2.visible = true;
				ui.life3.visible = false;
				ui.lifeCount.visible = false;
			}
			if (lives == 1){
				ui.life1.x = -100;
				ui.life1.visible = true;
				ui.life2.visible = false;
				ui.life3.visible = false;
				ui.lifeCount.visible = false;
			}
			if (lives <= 0){
				ui.life1.x = -100;
				ui.life1.visible = false;
				ui.life2.visible = false;
				ui.life3.visible = false;
				ui.lifeCount.visible = false;
				endGame();
			}
			//checks if a bullet hits the player
			if(bullets.length>0){
				for each(var bullet:Bullet in bullets){
					if (player.hitTestObject(bullet)){
						bullets.splice(bullets.indexOf(bullet),1);
						bullet.parent.removeChild(bullet);
						lives=lives-1;
					}
				}
			}
			//updates progress bar
			if (score < 15000*level){
				ui.progressBar.width = (score/100)-((level-1)*150);
			}
			//ends the level when player reaches required score
			if(score >= 15000*level){
				ui.progressBar.width = 150;
				gameTimer.stop();
				nextButton.visible = true;
				for each(bullet in bullets){
					bullet.parent.removeChild(bullet);
				}
				bullets.length = 0;
				
				if (buildings.length >= 1){
				fall = true;
				}
				for each(var building:Building in Main.buildings){
					if (building.currentFrame == 3){
						building.gotoAndStop(6);
					}
				}
				ui.progressBar.width = 150;
			}
		}
	}
}