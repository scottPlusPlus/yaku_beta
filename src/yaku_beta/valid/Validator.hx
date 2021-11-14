package yaku_beta.valid;

import tink.CoreApi.Outcome;
import tink.core.Error;

using yaku_core.NullX;

class Validator<T> {
	public var rules:Array<ValidationRule<T>> = [];
	public var allowNull:Bool = false;

	/*
	 *   Strategy for converting / combinig validation errors to a tink.core.Error
	 *  Validator.errorsAsTinkError is the default 
	 */
	public var tinkErrAdapter:Array<String>->String->Error = errorsAsTinkError;

    /*
    * Used in the default error messages. Example: '$itemName cannot be null'
    */
	public var itemName:String;

	public function new(itemName:String) {
		this.itemName = itemName;
	}

	public function errors(x:T):Array<String> {
		if (x == null) {
			if (allowNull) {
				return [];
			} else {
				return ['${itemName} cannot be null.'];
			}
		}

		var errs = new Array<String>();
		for (rule in rules) {
			var res = rule(x);
			switch (res) {
				case Pass:
				case Fail(errors):
					errs = errs.concat(errors);
				case FailAndExit(errors):
					errs = errs.concat(errors);
					break;
			}
		}
		return errs;
	}

	public function firstError(x:T):Null<String> {
		return errors(x).shift();
	}

	public function isValid(x:T):Bool {
		return errors(x).length == 0;
	}

	public function validOutcome(x:T):Outcome<T, Error> {
		var errs = errors(x);
		if (errs.length == 0) {
			return Success(x);
		}
		var tinkErr = tinkErrAdapter(errs, itemName);
		return Failure(tinkErr);
	}

	public function asRule<X>(mapper:X->T):ValidationRule<X> {
		return function(x:X):ValidationOutcome {
			var t = mapper(x);
			var errs = errors(t);
			if (errs.length == 0) {
				return Pass;
			}
			return Fail(errs);
		}
	}

	/*
	 * returns this, for fluid api
	 */
	public function addRule(rule:ValidationRule<T>):Validator<T> {
		rules.push(rule);
		return this;
	}

	public static function errorsAsTinkError(errs:Array<String>, name:String):Error {
		var msg = errs.join(" ");
		return new Error(ErrorCode.BadRequest, msg);
	}
}
