package monsters;

import monsters.MonsterListSheet;
import msignal.Signal.Signal0;
import msignal.Signal.Signal1;
import openfl.filesystem.File;
import ui.Binder;
import ui.Tab;

/**
 * ...
 * @author damrem
 */
class MonsterBinder extends Binder
{
	public var monsterPicked:Signal1<Monster>;
	public var listSheet:MonsterListSheet;

	public function new() 
	{
		super();
		
		monsterPicked = new Signal1<Monster>();
		
		var monstersTab = new Tab("Monsters");
		
		listSheet = new MonsterListSheet();
		listSheet.monsterPicked.add(monsterPicked.dispatch);
		listSheet.y = 32;
		monstersTab.addChild(listSheet);
		
		addTab(monstersTab);
		
		
		var marketTab = new Tab("Buy-a-Monster");
		
		var marketSheet = new MarketSheet();
		marketSheet.y = 32;
		marketTab.addChild(marketSheet);
		
		addTab(marketTab);
		
		setCurrentTab(monstersTab);
		
		
	}
	
}