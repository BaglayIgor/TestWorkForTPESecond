import openfl.display.DisplayObject;
import feathers.core.PopUpManager;
import openfl.events.MouseEvent;
import openfl.display.Bitmap;
import openfl.Assets;
import feathers.layout.HorizontalLayout;
import openfl.events.Event;
import feathers.data.ArrayCollection;
import feathers.controls.TabBar;
import feathers.layout.VerticalLayout;
import feathers.controls.ScrollContainer;
import feathers.controls.Button;
import openfl.display.Sprite;
import haxe.Timer;
import models.Tab;
import models.MyButton;
import models.Line;

class Main extends Sprite
{
	var xmlString:String;
	var tabs:Array<Tab> = new Array();
	var lines:Array<Line> = new Array();
	var buttons:Array<MyButton> = new Array();
	var linesInContainer:Array<ScrollContainer> = new Array();

	var container:ScrollContainer;
	var containerForCurrentTabs:ScrollContainer;
	var lastClickedButton:Button;
	var image:DisplayObject;

	public function new()
	{
		super();

		xmlString = sys.io.File.getContent("Assets/TabsForTest.xml");

		var xml = Xml.parse(xmlString).firstElement().elements();

		for (elem in xml) {
			var name = elem.get('name');

			var linesForCurrentTab:Array<Line> = parceLines(elem.firstElement().toString());

			var tab = new Tab(name, linesForCurrentTab);

			tabs.push(tab);

		}
		createUI(tabs);
	}


	function parceLines(string:String):Array<Line> {

		var xml = Xml.parse(string).firstElement().elements();
		var linesForCurrentTab:Array<Line> = new Array();

		for(element in xml) {
			var nameLine = element.toString();
			var buttonsForCurrentLine:Array<MyButton> = parceButtons(element.firstElement().toString());
			var line = new Line(buttonsForCurrentLine);
			lines.push(line);
			linesForCurrentTab.push(line);

//			parceButtons(element.firstElement().toString());
		}
		return linesForCurrentTab;
	}


	function parceButtons(string:String) {

		var xml = Xml.parse(string).firstElement().elements();

		var buttonsForCurrentLine:Array<MyButton> = new Array();

		for(button in xml)
		{
			var name = button.get('name');
			var image = button.get('image');

			var button = new MyButton(name, image);

			buttons.push(button);
			buttonsForCurrentLine.push(button);
		}
		return buttonsForCurrentLine;
	}

	function createUI(listTabs)
	{

		container = new ScrollContainer();
		var layout = new VerticalLayout();
		layout.gap = 20;
		layout.paddingTop = 20;
		container.layout = layout;
		container.width = stage.stageWidth;
		container.height = stage.stageHeight;

		stage.addEventListener(Event.RESIZE, resize_handler);

		this.addChild(container);

		var tabBar = new TabBar();

		tabBar.dataProvider = new ArrayCollection(listTabs);

		tabBar.itemToText = function(item:Dynamic):String {
			return item.get_name();
		};


		container.addChild(tabBar);

		containerForCurrentTabs = new ScrollContainer();
		containerForCurrentTabs.layout = new VerticalLayout();
		container.addChild(containerForCurrentTabs);

		var linesForFirstTab:Array<Line> = tabBar.selectedItem.get_linesArray();

		for (line in linesForFirstTab)
		{
			createLine(line, containerForCurrentTabs);
		}

		tabBar.addEventListener(Event.CHANGE, tabBar_changeHandler);

	}

	function createLine(line:Line, container:ScrollContainer) {

		 var containerForLines = new ScrollContainer();
		containerForLines.layout = new HorizontalLayout();

		linesInContainer.push(containerForLines);

		container.addChild(containerForLines);

		var buttonsFromCurrentLine = line.get_buttons();

		for(button in buttonsFromCurrentLine) {
			createButton(button, containerForLines);
		}

	}

	function createButton(btn:MyButton, containerForLine:ScrollContainer) {
		var button = new Button();
		button.setSize(100, 100);

		var bitmapData  = Assets.getBitmapData(btn.get_image());
		var bitmap  = new Bitmap(bitmapData);
		button.backgroundSkin = bitmap;

		button.addEventListener(MouseEvent.CLICK, createPoopUp);

		containerForLine.addChild(button);
	}

	function resize_handler(event: Event)
	{
		container.width = stage.stageWidth;
		container.height = stage.stageHeight;
	}

	function tabBar_changeHandler(event:Event) {
		container.removeChild(containerForCurrentTabs);
		var newContainerForLine = new ScrollContainer();
		newContainerForLine.layout = new VerticalLayout();
		containerForCurrentTabs = newContainerForLine;
		container.addChild(newContainerForLine);

		var tab = cast(event.currentTarget, TabBar);

		var lines:Array<Line> = tab.selectedItem.get_linesArray();

		for(line in lines)
		{
			createLine(line, newContainerForLine);
		}
	}
	function createPoopUp(event:Event)
		{
			var closeButton = new Button();
			closeButton.text = "back";

			var popUpContainer = new ScrollContainer();
			popUpContainer.layout = new VerticalLayout();

			lastClickedButton = cast(event.currentTarget, Button);
			image = lastClickedButton.backgroundSkin;

			popUpContainer.addChild(image);
			popUpContainer.addChild(closeButton);

			closeButton.addEventListener(MouseEvent.CLICK, closePopUp);

			PopUpManager.addPopUp(popUpContainer, this, true, true);
//			Timer.delay(closePopUp, 3000);
		}

	function closePopUp(event:Event):Void {
		lastClickedButton.addChild(image);
		PopUpManager.removeAllPopUps();
	}
}

