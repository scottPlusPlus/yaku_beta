package yaku_beta.valid;

using yaku_core.NullX;

class StringValidator {
	public static inline function minLength(validation:Validation<String>, v:UInt, ?errMsgOverride:String):Validation<String> {
		if (validation.value.length < v) {
			var msg = errMsgOverride.orFallback('${validation.name} must be less than ${v} chars.');
			validation.addRule([msg]);
		}
		return validation;
	}

	public static inline function maxLength(validation:Validation<String>, v:UInt, ?errMsgOverride:String):Validation<String> {
		if (validation.value.length > v) {
			var msg = errMsgOverride.orFallback('${validation.name} must be at least ${v} chars.');
			validation.addRule([msg]);
		}
		return validation;
	}

	public static inline function contains(validation:Validation<String>, needle:String, ?errMsgOverride:String):Validation<String> {
		if (!StringTools.contains(validation.value, needle)) {
			var msg = errMsgOverride.orFallback('${validation.name} must contain ${needle}');
			validation.addRule([msg]);
		}
		return validation;
	}

	public static inline function regex(validation:Validation<String>, regex:EReg, errMsg:String):Validation<String> {
		if (!regex.match(validation.value)) {
			validation.addRule([errMsg]);
		}
		return validation;
	}
}
