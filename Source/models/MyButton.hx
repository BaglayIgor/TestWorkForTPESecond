package models;
class MyButton
{
    @:isVar var name(get, set):String;
    @:isVar var image(get, set):String;

    public function new(name, image)
    {
        this.name = name;
        this.image = image;
    }

    public function get_name():String {
        return name;
    }

    public function set_name(value:String):String {
        return this.name = value;
    }

    public function get_image():String {
        return image;
    }

    public function set_image(value:String):String {
        return this.image = value;
    }
}