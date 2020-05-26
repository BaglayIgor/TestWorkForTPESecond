package models;
class Tab
{
    @:isVar var name(get, set):String;
    @:isVar var linesArray(get, set):Array<Line>;

    public function new(name:String, lines:Array<Line>)
    {
        this.name = name;
        this.linesArray = lines;
    }

    public function get_linesArray():Array<Line> {
        return linesArray;
    }

    public function set_linesArray(value:Array<Line>):Array<Line> {
        return this.linesArray = value;
    }


    public function get_name():String {
        return name;
    }

    public function set_name(value:String):String {
        return this.name = value;
    }

}