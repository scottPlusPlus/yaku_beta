package yaku_beta.valid;

import yaku_beta.valid.ValidationRule;
import haxe.ds.ReadOnlyArray;
import tink.core.Error;
import tink.CoreApi.Outcome;

using yaku_core.NullX;
using yaku_core.ArrayX;

class Validation<T> {

	public function new(value:T, name:String, ?errors:Array<String>) {
		this._errors = errors.orFallback([]);
		this.value = value;
		this.isNull = (value == null);
        this.name = name;
		if (isNull) {
			this._nullErr = '$name is null';
			this._errors.push(this._nullErr);
		}
	}

	private var _errors:Array<String> = [];
	private var _nullErr:String;

	public var value(default, null):T;
	public var name(default, null):String;
	public var isNull(default, null):Bool;

	public function allowNull() {
        //we assume null is bad from the constructor, so need to remove that error if it is later allowed
		_errors.remove(_nullErr);
        return this;
	}

	public function addRule(v:ValidationRule<T>):Validation<T> {
		if (isNull) {
			return this;
		}
        var newErrors = v.errors(value, name);
		for (err in newErrors) {
			_errors.push(err);
		}
		return this;
	}

	public function assertThat<U>(obj:U, name:String):Validation<U> {
		return new Validation<U>(obj, name, _errors);
	}


    public inline function errors():ReadOnlyArray<String> {
		return _errors;
	}

	public inline function firstError():Null<String> {
		return _errors.getOrNull(0);
	}

	public inline function isValid():Bool {
		return _errors.length == 0;
	}

	public inline function asOutcome():Outcome<T, Error> {
		if (_errors.length == 0) {
			return Success(value);
		}
		var tinkErr = tinkErrAdapter(_errors, name);
		return Failure(tinkErr);
	}

    /*
	 *  Strategy for converting / combinig validation errors to a tink.core.Error
	 *  Validator.errorsAsTinkError is the default 
	 */
	public static var tinkErrAdapter:Array<String>->String->Error = errorsAsTinkError;

	public static function errorsAsTinkError(errs:Array<String>, name:String):Error {
		var msg = errs.join(", ");
		return new Error(ErrorCode.BadRequest, msg);
	}

}
