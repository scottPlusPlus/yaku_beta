package yaku_beta.valid1;

import yaku_beta.valid1.*;

using yaku_core.NullX;

@:forward(allowNull, itemName, rules, tinkErrAdapter, errors, firstError, isValid, validOutcome, asRule, addRule)
@:access(yaku_beta.valid.Validator)
abstract StringValidator(Validator<String>) from Validator<String> to Validator<String> {
	public function new(itemName:String) {
		this = new Validator<String>(itemName);
	}

	public function minLength(v:UInt, ?errMsgOverride:String):StringValidator {
		var f = function(str:String):ValidationOutcome {
			if (str.length < v) {
				var errMsg = errMsgOverride.orFallback('${this.itemName} must be at least ${v} chars.');
				return Fail([errMsg]);
			}
			return Pass;
		}
		this.rules.push(f);
		return this;
	}

	public function maxLength(v:UInt, ?errMsgOverride:String):StringValidator {
		var f = function(str:String):ValidationOutcome {
			if (str.length > v) {
				var errMsg = errMsgOverride.orFallback('${this.itemName} must be less than ${v} chars.');
				return Fail([errMsg]);
			}
			return Pass;
		}
		this.rules.push(f);
		return this;
	}

	public function regex(regex:EReg, errMsg:String):StringValidator {
		var f = function(str:String):ValidationOutcome {
			if (!regex.match(str)) {
				return Fail([errMsg]);
			}
			return Pass;
		}
		this.rules.push(f);
		return this;
	}

	public function isTrim(?errMsgOverride:String):StringValidator {
		var f = function(str:String):ValidationOutcome {
			if (StringTools.trim(str) != str) {
				var errMsg = errMsgOverride.orFallback('${this.itemName} must not have any extra spaces.');
				return Fail([errMsg]);
			}
			return Pass;
		}
		this.rules.push(f);
		return this;
	}

	public function contains(needle:String, ?errMsgOverride:String):StringValidator {
		var f = function(str:String):ValidationOutcome {
			if (!StringTools.contains(str, needle)) {
				var errMsg = errMsgOverride.orFallback('${this.itemName} must contain ${needle}.');
				return Fail([errMsg]);
			}
			return Pass;
		}
		this.rules.push(f);
		return this;
	}
}
