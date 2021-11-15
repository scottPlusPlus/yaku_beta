package yaku_beta.valid;

using yaku_core.NullX;

@:access(yaku_beta.valid2.Validator)
class ValueValidator<T> {

    public function new(value:T, name:String, ?errors:Array<String>){
        this.errors = errors.orFallback([]);
        this.value = value;
        this.isNull = (value == null);
        if (isNull){
            this.nullErr = '$name is null';
            errors.push(this.nullErr);
        }
    }

    private var errors:Array<String> = [];
    private var nullErr:String;

    public var value(default,null):T;
    public var name(default,null):String; 
    public var isNull(default,null):Bool;

    public function allowNull(){
        errors.remove(nullErr);
    }

    public function rule(r:T->String->Validator):ValueValidator<T>{
        if (isNull){
            return this;
        }
        var res = r(value, name);
        for (err in res.errors()){
            errors.push(err);
        }
        return this;
    }

    public inline function asValidator():Validator {
        return errors;
    }
}