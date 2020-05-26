package models;
class Line
{
    @:isVar var buttons(get, set):Array<MyButton>;

    public function get_buttons():Array<MyButton> {
        return buttons;
    }

    public function set_buttons(value:Array<MyButton>):Array<MyButton> {
        return this.buttons = value;
    }

    public function new(buttons:Array<MyButton>)
    {
    this.buttons = buttons;
    }
}