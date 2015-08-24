package;

import missions.sheets.AvailableMissionSheet;
import missions.Mission;
import missions.MissionBinder;
import missions.sheets.AbstractMissionSheet;
import missions.ReportBinder;
import monsters.Monster;
import monsters.MonsterBinder;
import monsters.MonsterListSheet;
import motion.Actuate;
import motion.easing.Cubic;
import motion.easing.Linear;
import openfl.Assets;
import openfl.display.Sprite;
import openfl.events.MouseEvent;
import openfl.Lib;
import openfl.text.TextFieldAutoSize;
import openfl.text.TextFormat;
import openfl.text.TextFormatAlign;
import rewards.UpgradeBinder;
import ui.Calendar;
import ui.Desk;
import ui.Binder;
import ui.DollarIndicator;
import ui.Styles;
import ui.TF;

/**
 * ...
 * @author damrem
 */
class UIGame extends Sprite
{
	
	var desk:Desk;
	var researchFile:Binder;
	var monsterBinder:MonsterBinder;
	var missionBinder:MissionBinder;
	var gameManager:GameManager;
	var reportBinder:missions.ReportBinder;
	var binderContainer:Sprite;
	var mission3dContainer:openfl.display.Sprite;
	var monster3dContainer:openfl.display.Sprite;
	var repport3dContainer:openfl.display.Sprite;
	var upgradeBinder:UpgradeBinder;
	var upgrade3dContainer:Sprite;
	//var monsterListSheet:monsters.MonsterListSheet;
	//var missionSheet:missions.MissionSheet;
	//var mission:missions.Mission;
	//var reportFile:missions.ReportFile;
	var dayBlackTransition : Sprite;
	var calendar:Calendar;

	public function new(gameManager:GameManager) 
	{
		super();
		this.gameManager = gameManager;
		
		desk = new Desk();
		desk.addEventListener(MouseEvent.CLICK, onClickDesk);
		addChild(desk);
		
		dayBlackTransition = new Sprite();
		dayBlackTransition.graphics.beginFill(0);
		dayBlackTransition.graphics.drawRect(0, 0, Lib.current.stage.stageWidth, Lib.current.stage.stageHeight);
		
		var objective = GameManager.objective;
		
		gameManager.message("Son,\n"+
							"I sent you here to extend the Company.\n\n" + 
							"Don't disapoint me.\n\n" +
							"\tYou're on a trial and have to get $" + objective + " as soon as possible." + 
							"This world is full of cheap workforce! Use it!\n\n" +
							"\tAll the folder you need are on your desk.\n\n" +
							"\tYou'll first need a sla... employee to send him in mission.\n\n" +
							"\tUse the monster folder\n" + 
							"to bu... recruit one in the market section.\n\n" +
							"Then use the mission folder to send him into mission!\n" +
							"Good luck !");
							
		gameManager.market.newDay();
		gameManager.addBaseMissions();
		
		binderContainer = new Sprite();
		
		upgradeBinder = new UpgradeBinder();
		upgradeBinder.x = 150;
		upgradeBinder.y = 230;
		upgradeBinder.rotation = Math.random() * 20 - 10;
		
		upgrade3dContainer = new Sprite();
		binderContainer.addChild(upgrade3dContainer);
		upgrade3dContainer.addChild(upgradeBinder);
		upgrade3dContainer.rotationX = -60;
		upgrade3dContainer.z = 500;
		upgrade3dContainer.y = 200;
		
		monsterBinder = new MonsterBinder();
		monsterBinder.x = 400;
		monsterBinder.y = 225;
		monsterBinder.rotation = -10;
		
		monster3dContainer = new Sprite();
		binderContainer.addChild(monster3dContainer);
		monster3dContainer.addChild(monsterBinder);
		monster3dContainer.rotationX = -60;
		monster3dContainer.z = 500;
		monster3dContainer.y = 200;
		
		missionBinder = new MissionBinder();
		missionBinder.x = 630;
		missionBinder.y = 230;
		missionBinder.rotation = 10;
		
		mission3dContainer = new Sprite();
		binderContainer.addChild(mission3dContainer);
		mission3dContainer.addChild(missionBinder);
		mission3dContainer.rotationX = -60;
		mission3dContainer.z = 500;
		mission3dContainer.y = 200;
		
		reportBinder = new ReportBinder();
		reportBinder.x = 180;
		reportBinder.y = 250;
		reportBinder.rotation = 0;
		
		repport3dContainer = new Sprite();
		binderContainer.addChild(repport3dContainer);
		repport3dContainer.addChild(reportBinder);
		repport3dContainer.rotationX = -60;
		repport3dContainer.z = 500;
		repport3dContainer.y = 200;
		
		monsterBinder.monsterPicked.add(addMonsterToMission);
		missionBinder.monsterRequested.add(openMonsterListForPicking);
		
		monsterBinder.isOpenedChanged.add(openMonsterBinder);
		missionBinder.isOpenedChanged.add(openMissionBinder);
		reportBinder.isOpenedChanged.add(openReportBinder);
		upgradeBinder.isOpenedChanged.add(openUpgradeBinder);
		
		//reportFile = new ReportFile();
		//researchFile = new File();
		
		//binderContainer.addChild(reportBinder);
		//binderContainer.addChild(monsterBinder);
		//binderContainer.addChild(missionBinder);
		//addChild(monsterFile);
		
		calendar = new Calendar(this);
		calendar.x = 80;
		calendar.y = 50;
		addChild(calendar);
		
		var dollarIndic = new DollarIndicator();
		addChild(dollarIndic);
		dollarIndic.x = 800 - dollarIndic.width;
		
		/*
		
		
		var monster = Monster.get();
		
		monsterListSheet = new MonsterListSheet(gameManager);
		monsterListSheet.visible = false;
		
		mission = gameManager.availableMissions[0];
		missionSheet = new MissionSheet(mission);
		missionSheet.x = 200;

		
		monsterListSheet.monsterPicked.add(addMonsterToMission);
		
		
		
		
		
		
		addChild(missionSheet);
		addChild(monsterListSheet);
		*/
		
		//GameManager.getInstance().endedMission.push(Mission.get());
		addChild(binderContainer);
		
		dayBlackTransition.alpha = 1;
		Lib.current.stage.addChild(dayBlackTransition);
		fadeIn(checkRepport,1);
	}
	
	private function onClickDesk(e:MouseEvent):Void 
	{
		trace("desk");
		missionBinder.close(true);
		reportBinder.close();
		monsterBinder.close(true);
		upgradeBinder.close(true);
		trace(missionBinder.x, missionBinder.y);
		trace(reportBinder.x, reportBinder.y);
		trace(monsterBinder.x, monsterBinder.y);
		trace(upgradeBinder.x, upgradeBinder.y);
		
	}
	
	function openMissionBinder(isOpened:Bool) 
	{
		if (isOpened) {
			binderContainer.addChild(mission3dContainer);
			monsterBinder.close(true);
			reportBinder.close();
			upgradeBinder.close();
		}
	}
	
	function openMonsterBinder(isOpened:Bool) 
	{
		if (isOpened) {
			binderContainer.addChild(monster3dContainer);
			missionBinder.close(true);
			reportBinder.close();
			upgradeBinder.close();
		}
	}
	
	function openReportBinder(isOpened:Bool) 
	{
		if (isOpened) {
			binderContainer.addChild(repport3dContainer);
			missionBinder.close(true);
			monsterBinder.close(true);
			upgradeBinder.close();
		}
	}
	
	function openUpgradeBinder(isOpened:Bool)
	{
		if (isOpened)
		{
			binderContainer.addChild(upgrade3dContainer);
			missionBinder.close(true);
			monsterBinder.close(true);
			reportBinder.close();
		}
	}
	
	function addMonsterToMission(monster:Monster) 
	{
		trace("addMonsterToMission(" + monster);
		cast(missionBinder.availablePile.getCurrentSheet(), AvailableMissionSheet).addMonster(monster);
		monsterBinder.listSheet.cancelPicking();
		//monsterBinder.close();
		missionBinder.open();
	}
	
	function openMonsterListForPicking() 
	{
		trace("openMonsterList");
		monsterBinder.listSheet.pickMode = true;
		monsterBinder.listSheet.update();
		
		monsterBinder.open();
		
		//monsterListSheet.visible = true;
		
	}
	
	function fadeOut(onComplete : Dynamic) {
		dayBlackTransition.alpha = 0;
		Lib.current.stage.addChild(dayBlackTransition);
		Actuate.tween(dayBlackTransition, 0.25, { alpha:1 } ).ease(Cubic.easeOut).onComplete(onComplete);
	}
	
	function fadeIn(onComplete : Dynamic, duration : Float = 0.25) {
		Actuate.tween(dayBlackTransition, duration, { alpha:0 } ).ease(Cubic.easeOut).onComplete(function() {
			Lib.current.stage.removeChild(dayBlackTransition);
			onComplete();
		});
	}
	
	public function dayTransition(start : Bool = false) {
		fadeOut(checkEndGame);
	}
	
	function checkEndGame() {
		var end = gameManager.endDay();
		if (!end) {
			gameManager.startNewDay();
			calendar.updateDate();
			showDay();
			//fadeIn(checkRepport);
		}else {
			trace("this is the end.");
		}
	}
	
	function showDay() {
		var dayTF : TF = new TF("Day : " + gameManager.getDate(), Styles.WHITE24, TextFieldAutoSize.LEFT);
		dayTF.x = (Lib.current.stage.stageWidth - dayTF.width) / 2;
		dayTF.y = Lib.current.stage.stageHeight;
		Lib.current.stage.addChild(dayTF);
		
		var midScreen = Lib.current.stage.stageHeight / 2;
		
		Actuate.tween(dayTF, 0.2, { y:midScreen }, false).ease(Cubic.easeOut);
		Actuate.tween(dayTF, 1, { y:midScreen - dayTF.height }, false).ease(Linear.easeNone).delay(0.2);
		Actuate.tween(dayTF, 0.2, { y:0 - dayTF.height }, false).ease(Cubic.easeIn).delay(1.2).onComplete(function() {
			Lib.current.stage.removeChild(dayTF);
			fadeIn(checkRepport);
		});
	}
	
	function checkRepport() {
		var openReport = false;
				
		if (gameManager.messages.length > 0){
			reportBinder.addMessagePage();
			openReport = true;
		}
		
		if (gameManager.endedMission.length > 0)
			openReport = true;
		
		if (openReport)
			reportBinder.open();
	}
	
	
	
}