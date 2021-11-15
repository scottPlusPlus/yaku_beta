package yaku_beta.valid;

import yaku_beta.valid.*;
import haxe.ds.ReadOnlyArray;

using yaku_core.ArrayX;
// static function validate(g:Gallery) {
//     var v = new Validation("Gallery"); //effectively just an Array<String> ??
//     v.assertThat(g.title).minChar(3).maxChar(123);
//     v.assertThat(g.description).contains("foo");
//     v.also(g.child).rule(Gallery.validate)
//     return v;
// }

abstract Validator(Array<String>) from Array<String> {

    //potentially all this is just an abstract...

    public function new(){
        this = [];
    }

    private function addError(err:String){
        this.push(err);
    }

    public function errors():ReadOnlyArray<String> {
        return this;
    }

    public function assertThat<T>(obj:T, name:String):ValueValidator<T>{
        return new ValueValidator<T>(obj, name, this);
    }

    public function firstError():Null<String> {
		return this.getOrNull(0);
	}

	public function isValid():Bool {
		return this.length == 0;
	}

}



